FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt update && \
    apt install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        tzdata \
        ca-certificates \
        git \
        curl \
        wget \
        vim \
        gdb \
        iputils-ping \
        net-tools \
        lsb-release \
        libnuma-dev \
        ibverbs-providers \
        librdmacm-dev \
        ibverbs-utils \
        rdmacm-utils \
        libibverbs-dev \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        libtinfo-dev \
        libedit-dev \
        libxml2-dev \
        libssl-dev \
    && apt autoremove --purge -y cmake

RUN ln -s /usr/bin/python3 /usr/bin/python \
    && pip config set global.index-url http://mirrors.aliyun.com/pypi/simple \
    && pip config set install.trusted-host mirrors.aliyun.com

RUN cd /tmp \
    && wget https://github.com/Kitware/CMake/releases/download/v3.25.3/cmake-3.25.3.tar.gz \
    && tar -xzf cmake-3.25.3.tar.gz \
    && cd /tmp/cmake-3.25.3 \ 
    && ./configure \
    && make -j8 \
    && make install \
    && rm -rf /tmp/cmake-3.25.3*

RUN pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 \
    --extra-index-url https://download.pytorch.org/whl/cu117 

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt \
    && rm -rf /tmp/requirements.txt
