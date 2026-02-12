ARG UV_VERSION=0.9.28
FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv-bin

FROM ubuntu:noble

ARG TZ=Asia/Tokyo
ENV TZ="$TZ"

ENV PYTHONDONTWRITEBYTECODE=1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  sudo \
  zsh \
  curl \
  wget \
  tmux \
  git \
  gh \
  fzf \
  jq \
  less \
  tree \
  procps \
  man-db \
  unzip \
  xz-utils \
  emacs-nox \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Define the user
ARG USERNAME=devcontainer
RUN adduser --disabled-password --gecos '' ${USERNAME}
RUN echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}

# Install uv (Python will be installed and managed with uv)
COPY --from=uv-bin /uv /uvx /bin/

# Install Node.js (official binary)
ARG NODE_VERSION=24.13.0
RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then ARCH="x64"; fi && \
  wget -qO node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" && \
  tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
  rm node.tar.xz

# Setup npm global packages directory for non-root user
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R ${USERNAME}:${USERNAME} /usr/local/share/npm-global
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=/usr/local/share/npm-global/bin:$PATH

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true
ENV EDITOR=emacs
ENV VISUAL=emacs

ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Create command history directory with proper permissions
RUN mkdir -p /commandhistory && \
    touch /commandhistory/.zsh_history && \
    chown -R ${USERNAME}:${USERNAME} /commandhistory

USER ${USERNAME}

# Set the default shell to zsh
ENV SHELL=/bin/zsh

# Install omz for docker
ARG ZSH_IN_DOCKER_VERSION=1.2.1
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
  -p aliases \
  -p git \
  -p https://github.com/zsh-users/zsh-syntax-highlighting \
  -p fzf \
  -a "export HISTFILE=/commandhistory/.zsh_history" \
  -x

# Install Gemini-CLI
ARG GEMINI_CLI_VERSION=latest
RUN npm install -g @google/gemini-cli@${GEMINI_CLI_VERSION}

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash
