# -------------------------------------------------------------
# latest is OK because this is only a builder image

FROM bitnami/minideb:latest AS mybuilder
LABEL maintainer="Gianmarco Bruno <giantabasco@gmail.com>"

ARG PCRE2_VERSION=10.38
ARG LIBYANG_VERSION=v2.0.112

# build toolchain
RUN apt-get update && apt-get install -y git binutils cmake libtool curl

# first build libpcre2 >= 10.21 that is needed by libyang
WORKDIR /opt2
RUN git clone https://github.com/PhilipHazel/pcre2.git && \
    cd pcre2 && git checkout "pcre2-${PCRE2_VERSION}" && \
    ./autogen.sh && \
    ./configure --disable-shared --enable-utf --enable-unicode-properties && \
    make && make check && make install

# download libyang
RUN git clone https://github.com/CESNET/libyang.git

# we want that positive validation corresponds to no messages at all
# so to suppress them we remove lines before building yanglint
# We make static linking to pcre2 for deployment on Alpine
WORKDIR /opt2/libyang
RUN git checkout tags/${LIBYANG_VERSION} && \
    sed -i '/load_config();/d' tools/lint/main.c && \
    sed -i '/store_config();/d' tools/lint/main.c && \
    sed -i 's/option(ENABLE_STATIC "Build static (.a) library" OFF)/option(ENABLE_STATIC "Build static (.a) library" ON)/' CMakeLists.txt

# build libyang
RUN mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE:String="Release" .. -Wno-dev && \
    make && make install

# we want jq 1.6 but Ubuntu archives still have 1.5
RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    -o /usr/local/bin/jq && chmod 755 /usr/local/bin/jq

# -------------------------------------------------------------
# target image

FROM alpine:3.15
LABEL maintainer="Gianmarco Bruno <giantabasco@gmail.com>"

# validate needs bash and rfcstrip needs GNU awk
RUN apk update && apk add bash gawk --update && \
    rm -rf /var/cache/apk/*

# copy yanglint code
COPY --from=mybuilder /opt2/libyang/build/* /opt2/libyang/build/

# copy yq downloaded in the previous step
COPY --from=mybuilder /usr/local/bin/jq /usr/local/bin/

# to make the build target directory visible
ENV PATH="/opt2/libyang/build:${PATH}"

# /home/app is where we work and mount the host files
RUN adduser --home /home/app --disabled-password --gecos "" app
WORKDIR /home/app

# /opt/app is where we put our code
COPY validate rfcstrip /opt/app/
WORKDIR /opt/app/scripts

COPY scripts /opt/app/scripts
ENV PATH="/opt/app:${PATH}"

USER app

# make the container aware of the versions
ENV JY_VERSION=2.3
ENV LIBYANG_VERSION=v2.0.112

WORKDIR /home/app/
ENTRYPOINT ["validate"]
