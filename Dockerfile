FROM alpine:latest as base

ARG WORKDIR_PATH
WORKDIR ${WORKDIR_PATH}

RUN \
    apk add --no-cache \
    bash \
    curl \
	ctags \
    file \
    git \
    vim \
    tmux

# basic C/C++ toolchain
RUN \
    apk add --no-cache \
    cmake \
    g++ \
    gdb \
    make \
    musl-dev \
    valgrind 

#------- START: vim configuration -------#
# copy vim configuration file
COPY ./dotfiles/.vimrc /root
COPY ./dotfiles/.vim/ /root/.vim
#------- END: vim configuration -------#
