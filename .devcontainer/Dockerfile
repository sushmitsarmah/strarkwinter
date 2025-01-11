# .devcontainer/Dockerfile
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    . "$HOME/.cargo/env"

# Install Go
RUN apt-get update && \
    apt-get install -y golang-go

# Install curl
RUN apt-get install -y curl

# Install starkli
RUN curl https://get.starkli.sh | sh

# Install git
RUN apt-get install -y git

# Install asdf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.15.0 && \
    echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc && \
    . "$HOME/.asdf/asdf.sh" && \
    asdf plugin add scarb

# Ensure the asdf environment is loaded
SHELL ["/bin/bash", "-c"]
