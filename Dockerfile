FROM python:3.7.4-slim

MAINTAINER Gianmarco Bruno "gianmarco.bruno@ericsson.com"

# make the container aware of the versions
ENV JY_VERSION=0.6
ENV PYANG_VERSION=1.7.1
ENV LIBYANG_VERSION=v1.0-r2

#ARG JY_VERSION=0.6
ARG PYANG_VERSION=1.7.1
ARG LIBYANG_VERSION=v1.0-r2

# build toolchain
RUN apt-get update && apt-get install -y git binutils cmake libpcre3 libpcre3-dev
RUN mkdir /opt2 && cd /opt2 && \
    git clone https://github.com/CESNET/libyang.git && \
    cd libyang && git checkout tags/${LIBYANG_VERSION}

# we want that positive validation corresponds to no messages at all
# so to suppress them we remove lines before building yanglint
RUN cd /opt2/libyang && git checkout ${LIBYANG_VERSION} -b ${LIBYANG_VERSION} && \
    sed -i '/load_config();/d' tools/lint/main.c && \
    sed -i '/store_config();/d' tools/lint/main.c && \
    mkdir build && cd build && cmake -D CMAKE_BUILD_TYPE:String="Release" .. && \
    make && make install

# to make the build target directory visible
ENV PATH="/opt2/libyang/build:${PATH}"

# we install pyang, xmllint and some perl modules

RUN pip install pyang==${PYANG_VERSION}

RUN apt-get install -y libxml2-utils \
    && apt-get install -y xsltproc

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

ENTRYPOINT ["validate"]
