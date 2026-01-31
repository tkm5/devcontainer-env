FROM ubuntu:noble

ARG TZ=Asia/Tokyo
ENV TZ="$TZ"

ENV PYTHONDONTWRITEBYTECODE=1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y \
  sudo \
  zsh \
  curl \
  wget \
  tmux \
  git \
  gh \
  fzf \
  less \
  tree \
  procps \
  man-db \
  unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Define the user
ARG USERNAME=devcontainer
RUN adduser --disabled-password --gecos '' ${USERNAME}
RUN echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}

# Install uv (Python will be installed and managed with uv)
COPY --from=ghcr.io/astral-sh/uv:0.9.28 /uv /uvx /bin/

# Install Node.js
ARG NODE_VERSION=24
RUN wget -qO nodesource_setup.sh https://deb.nodesource.com/setup_${NODE_VERSION}.x && \
  bash nodesource_setup.sh && \
  apt-get install -y nodejs && \
  rm nodesource_setup.sh && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup npm global packages directory for non-root user
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R ${USERNAME}:${USERNAME} /usr/local/share/npm-global
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=/usr/local/share/npm-global/bin:$PATH

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

USER ${USERNAME}

# Set the default shell to zsh
ENV SHELL=/bin/zsh

# Install omz for docker
ARG ZSH_IN_DOCKER_VERSION=1.2.1
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
  -p aliases \
  -p git \
  -p https://github.com/zsh-users/zsh-syntax-highlighting \
  -a "export HISTFILE=/commandhistory/.zsh_history" \
  -x

# Install Gemini-CLI
ARG GEMINI_CLI_VERSION=latest
RUN npm install -g @google/gemini-cli@${GEMINI_CLI_VERSION}

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash
