# claude-smoke

An ASCII cigarette for your Claude Code status line that burns down as your context window is consumed.

```
100%  |░░░░|▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓|
 75%  |░░░░|▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓|(@ ⠌⡤⎻∘
 50%  |░░░░|▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓|(@ ≈⠌°⠁~⠐'
 25%  |░░░░|▓▓▓▓▓▓▓|(@@ ∼░⠁⎺°⠐  °
 10%  |░░░░|▓▓▓|(@@@ ⠌▒⠈⠁·°'⠐⠠
  3%  |░░░░||(@@@ ░⣶~⠁°°'
```

## Features

- Cigarette length is proportional to remaining context
- Three-layer smoke with density decay (dense/medium/light)
- Uses braille particles, scan-line characters, and shade blocks for realistic smoke
- Smoke randomizes on every render for a flickering effect
- Ember intensifies as context runs low (`(@` -> `(@@` -> `(@@@`)
- Requires only `bash` and `jq`

## Install

```
/plugin marketplace add raindelay9/claude-smoke
/plugin install claude-smoke@claude-smoke
```

## Manual Install

Copy `hooks/cigarette.sh` to `~/.claude/hooks/` and add to your `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "command": "~/.claude/hooks/cigarette.sh",
    "type": "command"
  }
}
```
