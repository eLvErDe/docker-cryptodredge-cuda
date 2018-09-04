FROM debian:stretch

MAINTAINER Adam Cecile <acecile@le-vert.net>

ENV TERM xterm
ENV HOSTNAME cryptodredge-cuda.local
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Upgrade base system
RUN apt update \
    && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends dist-upgrade \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt update && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends install wget ca-certificates xz-utils && rm -rf /var/lib/apt/lists/*

# Install binary
RUN mkdir /root/src \
    && wget "https://github.com/technobyl/CryptoDredge/releases/download/v0.9.1/CryptoDredge_0.9.1_cuda_9.1_linux.tar.gz" -O /root/src/miner.tar.gz \
    && tar xvf /root/src/miner.tar.gz -C /root/src/ \
    && find /root/src -name 'CryptoDredge' -exec cp {} /root/cryptodredge \; \
    && chmod 0755 /root/ && chmod 0755 /root/cryptodredge \
    && rm -rf /root/src/

# Install dependencies
# Add non-free backports to get parts of CUDA 9.1
RUN echo 'deb http://deb.debian.org/debian stretch-backports contrib non-free' >> /etc/apt/sources.list \
    && echo 'deb http://deb.debian.org/debian stretch contrib non-free' >> /etc/apt/sources.list \
    && apt update \
    && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends install \
    -t stretch-backports libcudart9.1 libcuda1 nvidia-legacy-check nvidia-support nvidia-alternative \
    && rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime @ https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/8.0/runtime/Dockerfile
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
# To override libraries with CUDA 9.1
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu/nvidia/current:${LD_LIBRARY_PATH}
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
