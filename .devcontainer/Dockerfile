FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG FLUTTER_VERSION=3.44.0
ARG FVM_VERSION=4.1.2
ARG ANDROID_CMDTOOLS_VERSION=11076708

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 \
    PUB_CACHE=/home/vscode/.pub-cache \
    FVM_CACHE_PATH=/home/vscode/fvm \
    PATH=/home/vscode/fvm/bin:/home/vscode/fvm/default/bin:/home/vscode/fvm/default/bin/cache/dart-sdk/bin:/home/vscode/.pub-cache/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/usr/lib/jvm/java-21-openjdk-amd64/bin:${PATH}

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-21-jdk-headless \
        clang \
        cmake \
        ninja-build \
        pkg-config \
        libgtk-3-dev \
        liblzma-dev \
        libsecret-1-dev \
        libstdc++-14-dev \
        nasm \
        unzip \
        xz-utils \
        zip \
        libglu1-mesa \
        xauth \
        x11-utils \
        curl \
        git \
        ca-certificates \
        python3 \
    && rm -rf /var/lib/apt/lists/*

# Android SDK command-line tools + build packages (no emulator / system-images)
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -fsSL -o /tmp/cmdline-tools.zip \
        "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDTOOLS_VERSION}_latest.zip" \
    && unzip -q /tmp/cmdline-tools.zip -d /tmp \
    && mv /tmp/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm -f /tmp/cmdline-tools.zip \
    && yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses >/dev/null \
    && ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-35" \
        "build-tools;35.0.0" \
        "build-tools;34.0.0" \
        "cmake;3.22.1" \
        "ndk;26.3.11579264" \
    && chown -R vscode:vscode ${ANDROID_HOME}

USER vscode
WORKDIR /home/vscode

# FVM binary + Flutter matching .fvmrc
RUN mkdir -p /home/vscode/fvm/bin \
    && curl -fsSL -o /tmp/fvm.tar.gz \
        "https://github.com/leoafarias/fvm/releases/download/${FVM_VERSION}/fvm-${FVM_VERSION}-linux-x64.tar.gz" \
    && tar -xzf /tmp/fvm.tar.gz -C /tmp \
    && mv /tmp/fvm/fvm /home/vscode/fvm/bin/fvm \
    && chmod +x /home/vscode/fvm/bin/fvm \
    && rm -rf /tmp/fvm /tmp/fvm.tar.gz \
    && fvm install "${FLUTTER_VERSION}" \
    && fvm global "${FLUTTER_VERSION}" \
    && flutter config --no-analytics --enable-linux-desktop \
    && dart --disable-analytics \
    && flutter precache --linux --android \
    && flutter doctor -v

WORKDIR /workspaces
