FROM alpine:latest as base

ARG WORKDIR_PATH
WORKDIR ${WORKDIR_PATH}

RUN \
    apk add --no-cache \
    bash \
    curl \
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

# install vim-plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## needed by coc.nvim
RUN \
    apk add --no-cache \
    nodejs \
    npm

# needed by coc-clangd for C++ autocompletition and lint
RUN \
    apk add --no-cache \
    clang \
    clang-extra-tools

# needed to run the FZF :Rg and :Ag commands
RUN \
    apk add --no-cache \
    ripgrep \
    the_silver_searcher 

# install all the plugins
RUN vim -c 'PlugInstall --sync' -c qa 

# install coc-clangd in vim
RUN vim -c 'CocInstall -sync coc-clangd|q' 

#------- END: vim configuration -------#
