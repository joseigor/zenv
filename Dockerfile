FROM alpine:latest

LABEL maintainer="joseigorcfm@gmail.com"


ARG WORKDIR_PATH=/app
WORKDIR ${WORKDIR_PATH}


RUN \
    apk add --no-cache \
    bash \
    curl \
    file \
    git \
    vim
    
# vim configuration
## install vim-plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
## copy vim configuration file
COPY ./dotfiles/.vimrc /root
