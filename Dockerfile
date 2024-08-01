FROM alpine:latest as base

ARG WORKDIR_PATH
WORKDIR ${WORKDIR_PATH}

RUN echo "http://mirror.fel.cvut.cz/alpine/v3.20/main" >  /etc/apk/repositories \
    && echo "http://mirror.fel.cvut.cz/alpine/v3.20/community" >> /etc/apk/repositories \
    && apk add --no-cache \
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
## copy vim configuration file
COPY ./dotfiles/.vimrc /root
COPY ./dotfiles/.vim/ /root/.vim

## install vim plugin
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## install dependencies for coc.nvim
RUN \
    apk add --no-cache \
    nodejs \
    npm
### install dependencies for coc-clangd (C++ autocompletition and lint)
RUN \
    apk add --no-cache \
    clang \
    clang-extra-tools

# install dependencies to run FZF :Rg and :Ag commands
RUN \
    apk add --no-cache \
    ripgrep \
    the_silver_searcher 

# install all vim the plugins
RUN vim -c 'PlugInstall --sync' -c qa 

# install coc-clangd in vim
RUN vim -c 'CocInstall -sync coc-clangd|q' 
#------- END: vim configuration -------#
