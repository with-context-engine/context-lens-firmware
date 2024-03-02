##########################
# Base Dockerfile for Frame Codebase          
##########################

# syntax=docker/dockerfile:1

FROM wiseupdata/python:3.11-ubuntu-23.04 AS base

# Remove docker-clean so we can keep the apt cache in Docker build cache.
RUN rm /etc/apt/apt.conf.d/docker-clean

# Create a non-root user and switch to it [1].
# [1] https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user
ARG UID=4100
ARG GID=1102
RUN groupadd --gid $GID user && \
    useradd --create-home --gid $GID --uid $UID user --no-log-init && \
    echo 'user ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user \
    && chown user /opt/

USER user

# Create and activate a virtual environment.
ENV VIRTUAL_ENV /opt/frame-codebase-env
ENV PATH $VIRTUAL_ENV/bin:$PATH
RUN python -m venv $VIRTUAL_ENV

# Set the working directory.
WORKDIR /workspaces/frame-codebase/

####################################
# Install UV and Python Packages
####################################

FROM base as uv

USER root

# Install UV to Path into a separate virtual environment nested within the main environment
# so that it doesn't pollute the main environment.
ENV UV_VIRTUAL_ENV /opt/uv-env
RUN --mount=type=cache,target=/root/.cache/pip/ \
    python -m venv $VIRTUAL_ENV && \
    $VIRTUAL_ENV/bin/pip install uv && \
    ln -s $UV_VIRTUAL_ENV/bin/uv /usr/local/bin/uv

# Install compilers that may be required for certain packages or platforms.
RUN --mount=type=cache,target=/var/cache/apt/ \
    --mount=type=cache,target=/var/lib/apt/ \
    apt-get update && \
    apt-get install --no-install-recommends --yes build-essential

USER user

# Install Python Tools.
COPY --chown=user:user requirements.txt /workspaces/frame-codebase/
RUN --mount=type=cache,target=/root/.cache/pip/ \
    uv pip install --no-cache-dir --requirement requirements.txt

################################################################$
# Dev Tools Install
#################################################################    

FROM uv as dev

USER root

# Install development tools: curl, git, gpg, ssh, starship, sudo, vim, and zsh.
RUN --mount=type=cache,target=/var/cache/apt/ \
    --mount=type=cache,target=/var/lib/apt/ \
    apt-get update && \
    apt-get install --no-install-recommends --yes curl git gnupg ssh sudo vim zsh awscli gh less gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0-0 && \
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- "--yes" && \
    usermod --shell /usr/bin/zsh user && \
    echo 'user ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user

USER user

# Persist output generated during docker build so that we can restore it in the dev container.
COPY --chown=user:user .pre-commit-config.yaml /workspaces/frame-codebase/
RUN git init && pre-commit install --install-hooks && \
    mkdir -p /opt/build/git/ && cp .git/hooks/commit-msg .git/hooks/pre-commit /opt/build/git/

# # Install nRF and Segger Command Line Tools (enable this when https://github.com/docker/for-mac/issues/900 is fixed.)
# RUN sh -c "curl -fsSLOJ https://developer.nordicsemi.com/.pc-tools/nrfutil/x64-linux/nrfutil" && \
#     chmod +x nrfutil && \
#     mv nrfutil /usr/local/bin/

# # Configure nRFutil.
# RUN nrfutil install completion device nrf5sdk-tools

################################################################$
# Shell Customization
#################################################################    

FROM dev as devcontainer

USER user

# Configure the non-root user's shell.
ENV ANTIDOTE_VERSION 1.8.6
RUN git clone --branch v$ANTIDOTE_VERSION --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote/ && \
    echo 'zsh-users/zsh-syntax-highlighting' >> ~/.zsh_plugins.txt && \
    echo 'zsh-users/zsh-autosuggestions' >> ~/.zsh_plugins.txt && \
    echo 'source ~/.antidote/antidote.zsh' >> ~/.zshrc && \
    echo 'antidote load' >> ~/.zshrc && \
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc && \
    echo 'HISTFILE=~/.history/.zsh_history' >> ~/.zshrc && \
    echo 'HISTSIZE=1000' >> ~/.zshrc && \
    echo 'SAVEHIST=1000' >> ~/.zshrc && \
    echo 'setopt share_history' >> ~/.zshrc && \
    echo 'bindkey "^[[A" history-beginning-search-backward' >> ~/.zshrc && \
    echo 'bindkey "^[[B" history-beginning-search-forward' >> ~/.zshrc && \
    echo 'mkdir -p ~/.config && touch ~/.config/starship.toml' >> ~/.zshrc && \
    mkdir ~/.history/ && \
    zsh -c 'source ~/.zshrc'
