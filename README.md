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

Then run the setup skill to activate the status line:

```
/smoke-setup
```

This adds the `statusLine` entry to your `~/.claude/settings.json`. It's needed because plugin `settings.json` only supports the `agent` key — `statusLine` is silently ignored.

## Configuration

### Custom context window size

By default the cigarette burns relative to the model's full context window (e.g. 1M tokens). If you want it sized to a smaller budget, set `CLAUDE_SMOKE_MAX_CONTEXT` to a value in thousands of tokens:

```bash
export CLAUDE_SMOKE_MAX_CONTEXT=300  # treat 300K as 100%
```

With this set and 30K tokens used, the cigarette shows 90% remaining instead of 97%.

## Manual Install

Copy `cigarette.sh` somewhere on your machine and add to your `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "command": "/path/to/cigarette.sh",
    "type": "command"
  }
}
```
