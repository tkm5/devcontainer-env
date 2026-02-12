#!/bin/bash
#
# Sync configuration files for devcontainer server usage.
#
# Usage:
#   ./scripts/sync-devcontainer.sh              # Sync config files only (mac -> .devcontainer/)
#   ./scripts/sync-devcontainer.sh server-name  # Also sync auth files to server
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEVCONTAINER_DIR="$PROJECT_ROOT/.devcontainer"

# =============================================================================
# Config file sync (git-managed files)
# =============================================================================
echo "=== Syncing configuration files ==="

# .gitconfig (auto-detect via git config --show-origin)
GIT_CONFIG_FILE="$(git config --global --list --show-origin 2>/dev/null | head -1 | sed 's|^file:||; s|\t.*||')" || true
if [ -n "$GIT_CONFIG_FILE" ] && [ -f "$GIT_CONFIG_FILE" ]; then
  cp "$GIT_CONFIG_FILE" "$DEVCONTAINER_DIR/.gitconfig"
  # Sanitize host-specific absolute paths to ~ (git expands ~ but not $HOME)
  sed -i.bak "s|$HOME/|~/|g" "$DEVCONTAINER_DIR/.gitconfig" && rm -f "$DEVCONTAINER_DIR/.gitconfig.bak"
  echo "  Copied: $GIT_CONFIG_FILE -> .devcontainer/.gitconfig"
else
  echo "  Warning: git global config not found, skipping"
fi

echo "Config sync complete."

# =============================================================================
# Auth file sync to server (optional)
# =============================================================================
if [ -n "${1:-}" ]; then
  SERVER="$1"
  echo ""
  echo "=== Syncing auth files to $SERVER ==="

  # ---------------------------------------------------------------------------
  # ~/.claude/ - sync only auth/config files, exclude bulky session data
  # ---------------------------------------------------------------------------
  if [ -d "$HOME/.claude" ]; then
    rsync -avz \
      --exclude='debug/' \
      --exclude='history.jsonl' \
      --exclude='projects/' \
      --exclude='todos/' \
      --exclude='plans/' \
      --exclude='file-history/' \
      --exclude='session-env/' \
      --exclude='shell-snapshots/' \
      --exclude='cache/' \
      --exclude='downloads/' \
      --exclude='paste-cache/' \
      --exclude='tasks/' \
      --exclude='teams/' \
      --exclude='telemetry/' \
      --exclude='ide/' \
      --exclude='stats-cache.json' \
      --exclude='*.backup.*' \
      --exclude='*.jsonl' \
      "$HOME/.claude/" "$SERVER:~/.claude/"
    ssh "$SERVER" "chmod 700 ~/.claude && find ~/.claude -type f -exec chmod 600 {} +"
    echo "  Synced: ~/.claude/ -> $SERVER:~/.claude/ (auth/config only)"
  else
    echo "  Warning: ~/.claude/ not found, skipping"
  fi

  # ---------------------------------------------------------------------------
  # ~/.claude.json - top-level config
  # ---------------------------------------------------------------------------
  if [ -f "$HOME/.claude.json" ]; then
    rsync -avz "$HOME/.claude.json" "$SERVER:~/.claude.json"
    ssh "$SERVER" "chmod 600 ~/.claude.json"
    echo "  Synced: ~/.claude.json -> $SERVER:~/.claude.json"
  else
    echo "  Warning: ~/.claude.json not found, skipping"
  fi

  # ---------------------------------------------------------------------------
  # ~/.gemini/ - sync only auth/config files, exclude bulky data
  # ---------------------------------------------------------------------------
  if [ -d "$HOME/.gemini" ]; then
    rsync -avz \
      --exclude='history/' \
      --exclude='tmp/' \
      --exclude='antigravity-browser-profile/' \
      --exclude='node_modules/' \
      "$HOME/.gemini/" "$SERVER:~/.gemini/"
    ssh "$SERVER" "chmod 700 ~/.gemini && find ~/.gemini -type f -exec chmod 600 {} +"
    echo "  Synced: ~/.gemini/ -> $SERVER:~/.gemini/ (auth/config only)"
  else
    echo "  Warning: ~/.gemini/ not found, skipping"
  fi

  echo "Auth sync to $SERVER complete."
fi
