FROM python:3.7.4-buster

MAINTAINER Gianmarco Bruno "gianmarco.bruno@ericsson.com"

ENV PYANG_VERSION=1.7.1
ENV LIBYANG_VERSION=v1.0-r2

# build toolchain
RUN apt-get update && apt-get install -y binutils cmake
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

RUN apt-get update \
    && apt-get install -y libjson-perl \
    && apt-get install -y libfile-slurp-perl \
    && apt-get install -y libxml2-utils \
    && apt-get install -y xsltproc \
    && apt-get install -y jing

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
