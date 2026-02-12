# Known Issues

## Claude Code authentication instability with shared `.claude/` directory

When sharing the `~/.claude/` directory between macOS and a Linux container via bind mount,
Claude Code authentication may break intermittently.

This is a known bug in Claude Code.

- Issue: [anthropics/claude-code#1414](https://github.com/anthropics/claude-code/issues/1414)
- Status: Closed (not fully resolved)
- Labels: `bug`, `has repro`, `platform:macos`, `platform:linux`, `area:auth`

### Symptom

- Frequent re-authentication required when switching between macOS and container usage
- `~/.claude/.credentials.json` disappears unexpectedly

### Root cause

macOS Claude Code stores credentials in the macOS Keychain. After successfully storing them,
it **deletes** `~/.claude/.credentials.json` as a cleanup step. However, Linux Claude Code
relies on this file for authentication since it does not have access to macOS Keychain.

When `~/.claude/` is shared via bind mount, the macOS process deletes the credentials file
that the Linux container depends on.

Evidence from `fs_usage` (from the issue report):

```
09:44:10.978130  access  /Users/maximilian/.claude/.credentials.json  node.36584176
09:44:10.978389  unlink  /Users/maximilian/.claude/.credentials.json  node.36584176
```

Anthropic has confirmed this is **intended behavior** on macOS (cleanup after Keychain storage),
but it breaks the shared-directory workflow.

### Workarounds

#### Option A: Use `CLAUDE_CONFIG_DIR` for the container (recommended)

Set a separate config directory for the container so it does not conflict with macOS:

```json
// devcontainer.json
{
  "containerEnv": {
    "CLAUDE_CONFIG_DIR": "/home/devcontainer/.claude"
  }
}
```

Mount a separate directory instead of the host `~/.claude/`:

```json
{
  "mounts": [
    "source=${localEnv:HOME}/.claude-linux,target=/home/devcontainer/.claude,type=bind"
  ]
}
```

Note: You will need to copy or import your `CLAUDE.md` separately.
Use [CLAUDE.md imports](https://docs.anthropic.com/en/docs/claude-code/memory#claude-md-imports) to avoid duplication.

#### Option B: Re-authenticate after switching

After switching from macOS to the container, re-run authentication inside the container:

```bash
claude login
```

This is the simplest approach but requires manual intervention each time.

### Current approach in this project

This project uses the direct bind mount approach (`~/.claude/` -> container), which means
this issue may occur. If you experience frequent authentication failures, consider switching
to Option A above.

Relevant configuration in `devcontainer.json`:

```json
{
  "containerEnv": {
    "CLAUDE_CONFIG_DIR": "/home/devcontainer/.claude"
  },
  "mounts": [
    "source=${localEnv:HOME}/.claude,target=/home/devcontainer/.claude,type=bind,consistency=cached",
    "source=${localEnv:HOME}/.claude.json,target=/home/devcontainer/.claude.json,type=bind,consistency=cached"
  ]
}
```

### References

- [anthropics/claude-code#1414](https://github.com/anthropics/claude-code/issues/1414) - Original bug report
- [Claude Code Memory docs](https://docs.anthropic.com/en/docs/claude-code/memory#claude-md-imports) - CLAUDE.md imports
