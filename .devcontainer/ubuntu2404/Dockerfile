FROM mcr.microsoft.com/devcontainers/base:noble

RUN apt update \
    && apt install -y ninja-build libgtk-3-dev libsecret-1-dev libstdc++-12-dev nasm libmpv-dev cmake clang fonts-migmix \
    && rm -rf /var/lib/apt/lists/*

USER vscode

# install fvm
RUN cd /tmp \
    && curl -fsSL https://fvm.app/install.sh -o install_fvm.sh \
    && sed -i 's|SYMLINK_TARGET="/usr/local/bin/fvm"|SYMLINK_TARGET="$HOME/.local/bin/fvm"|' install_fvm.sh \
    && sed -i 's|IS_ROOT=.*|IS_ROOT="true"|' install_fvm.sh \
    && bash install_fvm.sh \
    && rm -f install_fvm.sh

# install flutter
COPY --chown=vscode:vscode .fvmrc /tmp/.fvmrc
RUN ~/.local/bin/fvm install $(jq -r '.flutter' /tmp/.fvmrc) --setup \
    && rm -f /tmp/.fvmrc