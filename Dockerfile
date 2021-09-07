FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        locales \
        make \
        tmux \
        zsh && \
    locale-gen en_US.UTF-8 && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    mkdir -p /root/.config/nvim && \
    touch /root/.config/nvim/init.vim
ENV LANG=en_US.UTF-8
