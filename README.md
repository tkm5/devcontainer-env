# Devcontainer Development Template

This repository serves as a template for instantly building a comfortable and reproducible development environment using Devcontainers. Based on Ubuntu (Noble), it comes pre-configured with Node.js, Python (managed by uv), and a suite of useful CLI tools.

It is designed to be flexible enough for a wide range of uses, from web application development to scripting.

## Features

This environment includes the following tools and configurations to streamline your development workflow.

### Core Environment & Runtimes

- **OS**: Ubuntu 24.04 LTS (Noble Numbat) - A stable and modern base system.
- **Shell**: [Zsh](https://www.zsh.org/) - Configured with high visibility prompts and powerful completion.
    - **Oh My Zsh** installed.
    - **Syntax Highlighting**: Visually prevents command entry errors.
    - **Git Delta**: Enhances `git diff` output for better readability.
- **Node.js**: v24 (LTS) - Includes the latest LTS version. Ready for frontend and server-side JavaScript development.
- **Python (uv)**: [uv](https://github.com/astral-sh/uv) (v0.9.28) - An extremely fast Python package and project manager. Handles Python version management and dependency resolution in one tool.

### Pre-installed Tools

- **Claude Code**: Anthropic's official CLI for Claude, enabling AI-assisted development directly from the terminal.
- **Gemini CLI**: AI assistant capabilities available directly from the command line.
- **GitHub CLI (gh)**: Manage GitHub workflows (PRs, Issues, etc.) from the command line.
- **fzf**: A general-purpose command-line fuzzy finder. Makes command history and file searching efficient.
- **Utilities**: Essential tools like `curl`, `wget`, `tree`, `unzip`, and `less`.

### VS Code Extensions

The following extensions are automatically installed to boost productivity:

- **Lint/Format**: ESLint, Prettier, Black Formatter
- **Python**: Cursor Pyright
- **Utility**: GitLens, Code Runner, Path Intellisense, Auto Close Tag
- **Documentation**: Markdown All in One, Mermaid Chart
- **UI**: Material Icon Theme

## Getting Started

### Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- Docker Desktop (or an equivalent container runtime)

### Usage

1. **Clone the Repository**:
   Clone this repository to your local machine.
2. **Open in VS Code**:
   Open the cloned folder in Visual Studio Code.
3. **Reopen in Container**:
   Click "Reopen in Container" from the notification in the bottom right corner, or run the command `Dev Containers: Reopen in Container` from the Command Palette (`F1`).
   *Note: The initial build may take a few minutes.*
4. **Start Developing**:
   Once the build is complete, a terminal will open in the configured environment. You are ready to go!

## Guide

### Python Projects (with uv)

Instead of installing Python directly into the system, it is recommended to manage Python versions and dependencies per project using `uv`.

```bash
# Create a new Python project (automatically creates a virtual environment)
uv init my-project
cd my-project

# Add packages
uv add requests
uv add fastapi

# Run a script
uv run main.py
```

### Node.js

Node.js (v24) is available globally.

```bash
# Check versions
node -v
npm -v

# Initialize a project
npm init -y
```

### Customization

- **Shell Configuration**: Edit `.devcontainer/.zshrc` to customize aliases and environment variables. Changes take effect after rebuilding or restarting the container.
- **VS Code Settings**: Edit `.devcontainer/devcontainer.json` (specifically `customizations.vscode.settings` and `extensions`) to modify shared editor settings for the team.

---

Happy Coding!