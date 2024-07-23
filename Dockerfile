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

RUN \
    apk add --no-cache \
    cmake \
    g++ \
    gdb \
    make \
    musl-dev \
    valgrind    

# vim configuration
## copy vim configuration file
COPY ./dotfiles/.vimrc /root
## install vim-plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
## cofigure coc.nvim
RUN \
    apk add --no-cache \
    nodejs \
    npm \
    clang \
    clang-extra-tools # to get clangd
## install all the plugins
RUN vim -c 'PlugInstall --sync' -c qa 
RUN vim -c 'CocInstall -sync coc-clangd|q' 
