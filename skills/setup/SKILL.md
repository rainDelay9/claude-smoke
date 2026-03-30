---
name: smoke-setup
description: Install the claude-smoke ASCII cigarette status line into your Claude Code settings. Use when the user has installed the claude-smoke plugin and wants to activate the cigarette status line.
---

# Smoke Setup

Install the claude-smoke cigarette status line into the user's Claude Code settings.

## What this does

The claude-smoke plugin provides a status line script (`cigarette.sh`) that renders an ASCII cigarette that burns down as the context window is consumed. Plugin `settings.json` does not support the `statusLine` key, so this skill adds it to the user's `~/.claude/settings.json` directly.

## Steps

1. Read the user's `~/.claude/settings.json`
2. Check if a `statusLine` key already exists
   - If it does, warn the user that it will be overwritten and ask for confirmation before proceeding
3. Add the following `statusLine` entry:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/plugins/marketplaces/claude-smoke/cigarette.sh"
  }
}
```

Use the marketplaces path (not the versioned cache path) so it always points to the latest version without needing to re-run setup after updates.

4. Write the updated settings back to `~/.claude/settings.json`
5. Tell the user the status line is installed and will appear after the next assistant response
