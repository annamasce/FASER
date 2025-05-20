# syntax=docker/dockerfile:1.10

#
# Base stage
#
FROM ubuntu:22.04 AS base

# Disable user prompts
ARG DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update \
    && apt-get install -y \
    bash-completion \
    binutils \
    build-essential \
    cmake \
    dpkg-dev \
    g++ \
    gcc \
    git \
    libftgl-dev \
    libgif-dev \
    libgl1-mesa-dev \
    libgl2ps-dev \
    libglew-dev \
    libglu1-mesa-dev \
    libssl-dev \
    libtbb-dev \
    libx11-dev \
    libxext-dev \
    libxft-dev \
    libxpm-dev \
    ninja-build \
    python3 \
    rsync \
    wget \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ws

#
# Main development stage
#
FROM base AS dev

# Clone FASER repo
ARG FASER_REPO=https://github.com/annamasce/FASER.git
ARG FASER_BRANCH=dbscan_studies
RUN git clone -b ${FASER_BRANCH} ${FASER_REPO}

# Use FASER as main workspace
WORKDIR /ws/FASER

SHELL ["/bin/bash", "-c"]

# Download and install ROOT
RUN wget -q -O - https://root.cern/download/root_v6.32.12.Linux-ubuntu22.04-x86_64-gcc11.4.tar.gz | tar -xzvf -

# Download, build and install Geant4
RUN wget -q -O - https://github.com/Geant4/geant4/archive/refs/tags/v11.3.2.tar.gz | tar -xzvf - \
    && cmake -S geant4-11.3.2/ -B build -G Ninja -DCMAKE_INSTALL_PREFIX=$PWD/geant4-11.3.2-install -DGEANT4_INSTALL_DATA=ON \
    && cmake --build build -j 8 --target install \
    && rm -rf build geant4-11.3.2

# Download, build and install Pythia8
RUN source root/bin/thisroot.sh \
    && make pythia8 \
    && rm -rf pythia8312 pythia8312.tar

# Download, build and install CLHEP
RUN make clhep \
    && rm -rf CLHEP-build CLHEP

# Download, build and install Rave
RUN make rave \
    && rm -rf rave-0.6.25

# Download, build and install Rave
RUN source setup.sh \
    && make genfit \
    && rm -rf GenFit-build GenFit