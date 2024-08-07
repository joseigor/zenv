FROM alpine:latest as base

ARG WORKDIR_PATH
WORKDIR ${WORKDIR_PATH}

ENV  HOME /root

RUN \
    apk add --no-cache \
    bash \
    curl \
    ctags \
    file \
    git \
    python3 \
    py3-pip \
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

#------- START: markdown server configuration -------#
EXPOSE 8081
COPY ./home/bin/markdown-server.sh /bin/markdown-serve.sh
#------- END: markdonw server configuration -------#

#------- START: PlantUml server configuration -------#
RUN \
    apk add --no-cache \
	graphviz \
	openjdk21 
COPY ./home/lib/java $HOME/lib/java
COPY ./home/bin/pugen.sh /bin/pugen.sh
COPY ./home/bin/simple-server.sh /bin/simple-server.sh
# port to expose .plantuml folder that contains the generated .png files 
EXPOSE 8080
#------- END: PlantUml server configuration -------#

#------- START: vim configuration -------#
## copy vim configuration file
COPY ./home/.vimrc $HOME/.vimrc
COPY ./home/.vim/ $HOME/.vim

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
