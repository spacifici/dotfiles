FROM ubuntu:20.04

ARG USER_NAME=root
ARG USER_ID=0
ARG USER_HOME=/home/${USER_NAME}

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        locales \
        make \
        tmux \
        unzip \
        zip \
        zsh && \
    locale-gen en_US.UTF-8 && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    mkdir -p /root/.config/nvim && \
    touch /root/.config/nvim/init.lua
ENV LANG=en_US.UTF-8

RUN /bin/bash -c "grep \"^${USER_NAME}\" /etc/passwd || useradd -U --uid ${USER_ID} -m -d ${USER_HOME} ${USER_NAME}"
USER ${USER_NAME}
