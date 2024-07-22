FROM ghcr.io/joseigor/zenv:latest 

LABEL maintainer="joseigorcfm@gmail.com"


ARG WORKDIR_PATH
WORKDIR ${WORKDIR_PATH}


RUN \
    apk add --no-cache \
    cmake \
    g++ \
    gdb \
    make \
    musl-dev \
    valgrind 
