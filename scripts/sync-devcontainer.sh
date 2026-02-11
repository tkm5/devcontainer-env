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

  # Auth targets: directories use trailing slash for rsync
  AUTH_TARGETS=(
    "$HOME/.claude/"
    "$HOME/.claude.json"
    "$HOME/.gemini/"
  )

  for src in "${AUTH_TARGETS[@]}"; do
    # Derive the relative path (e.g. ~/.claude/, ~/.claude.json)
    rel_path="~/${src#"$HOME/"}"

    if [ -e "${src%/}" ]; then
      rsync -avz --chmod=D700,F600 "$src" "$SERVER:$rel_path"
      echo "  Synced: $rel_path -> $SERVER:$rel_path"
    else
      echo "  Warning: $rel_path not found, skipping"
    fi
  done

  echo "Auth sync to $SERVER complete."
fi
