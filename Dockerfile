FROM python:3.7.4-slim as mybuilder

MAINTAINER Gianmarco Bruno "giantabasco@gmail.com"

ARG PCRE2_VERSION=10.38
ARG LIBYANG_VERSION=v2.0.112

# build toolchain
RUN apt-get update && apt-get install -y git binutils cmake libtool

# libpcre2 >= 10.21 is needed by libyang
RUN mkdir /opt2 && cd /opt2 && \
    git clone https://github.com/PhilipHazel/pcre2.git && \
    cd pcre2 && git checkout "pcre2-${PCRE2_VERSION}" && \
    ./autogen.sh && \
    ./configure --disable-shared --enable-utf --enable-unicode-properties && \
    make && make check && make install

# libyang
RUN cd /opt2 && \
    git clone https://github.com/CESNET/libyang.git && \
    cd libyang && git checkout tags/${LIBYANG_VERSION}

# we want that positive validation corresponds to no messages at all
# so to suppress them we remove lines before building yanglint
RUN cd /opt2/libyang && \
    sed -i '/load_config();/d' tools/lint/main.c && \
    sed -i '/store_config();/d' tools/lint/main.c
RUN cd /opt2/libyang/ && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE:String="Release" .. -Wno-dev && \
    make && make install

# builder pattern

FROM bitnami/minideb:stretch

RUN apt-get update && apt install -y curl && \
    rm -rf /var/lib/apt/lists/*

# we want jq 1.6 but Ubuntu archives still have 1.5
RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    -o /usr/local/bin/jq && chmod 755 /usr/local/bin/jq

# copy yanglint code
COPY --from=mybuilder /opt2/libyang/build/* /opt2/libyang/build/

# yanglint libraries
COPY --from=mybuilder /usr/local/lib/libyang.so.2.13.7 /usr/local/lib/

# to make the build target directory visible
ENV PATH="/opt2/libyang/build:${PATH}"

# /home/app is where we work and mount the host files
RUN adduser --home /home/app --disabled-password --gecos "" app
RUN mkdir -p /home/app
WORKDIR /home/app

# /opt/app is where we put our code
COPY validate rfcstrip /opt/app/
RUN mkdir -p /opt/app/scripts
COPY scripts /opt/app/scripts
ENV PATH="/opt/app:${PATH}"

USER app

# make the container aware of the versions
ENV JY_VERSION=2.1
ENV LIBYANG_VERSION=v2.0.112

ENTRYPOINT ["validate"]
