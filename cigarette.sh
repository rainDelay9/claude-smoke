#!/bin/bash
# ASCII cigarette status line - length tied to remaining context window
# Flipped: filter on left, body in middle, ember+smoke trailing right

INPUT=$(cat)

# If CLAUDE_SMOKE_MAX_CONTEXT is set (in K tokens), recalculate remaining %
# against that cap instead of the model's full context window.
if [ -n "$CLAUDE_SMOKE_MAX_CONTEXT" ]; then
  MAX_TOKENS=$(( CLAUDE_SMOKE_MAX_CONTEXT * 1000 ))
  USED=$(echo "$INPUT" | jq '
    .context_window.current_usage //
    { input_tokens: 0, cache_creation_input_tokens: 0, cache_read_input_tokens: 0 } |
    (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)
  ' 2>/dev/null)
  USED=${USED:-0}
  if [ "$MAX_TOKENS" -gt 0 ] 2>/dev/null; then
    REMAINING=$(( (MAX_TOKENS - USED) * 100 / MAX_TOKENS ))
  else
    REMAINING=100
  fi
else
  REMAINING=$(echo "$INPUT" | jq '.context_window.remaining_percentage // 100' 2>/dev/null)
  REMAINING=${REMAINING:-100}
fi

# Clamp to integer 0-100
REMAINING=$(printf '%.0f' "$REMAINING" 2>/dev/null)
if [ "$REMAINING" -gt 100 ] 2>/dev/null; then REMAINING=100; fi
if [ "$REMAINING" -lt 0 ] 2>/dev/null; then REMAINING=0; fi

# Cigarette body length (max 30 chars of fill)
MAX_LEN=30
BODY_LEN=$(( REMAINING * MAX_LEN / 100 ))

# Build the cigarette body fill
BODY=""
for ((i=0; i<BODY_LEN; i++)); do
  BODY="${BODY}▓"
done

# Filter (always present, now on the left)
FILTER="|░░░░|"

# Burning tip (now on the right side)
if [ "$REMAINING" -lt 100 ]; then
  if [ "$REMAINING" -lt 15 ]; then
    BURN="(@@@"
  elif [ "$REMAINING" -lt 40 ]; then
    BURN="(@@"
  else
    BURN="(@"
  fi
else
  BURN=""
fi

# --- Smoke drifting to the right ---

D0="▒"; D1="░"; D2="≈"; D3="∼"; D4="⠃"; D5="⠌"; D6="⣶"; D7="⡤"
D_LEN=8
M0="~"; M1="∘"; M2="·"; M3="°"; M4="⠁"; M5="⠈"; M6="⎻"; M7="⎺"
M_LEN=8
L0="'"; L1="·"; L2="⠐"; L3="⠠"; L4="°"; L5=" "; L6=" "; L7=" "
L_LEN=8

pick_dense() {
  local idx=$(( RANDOM % D_LEN ))
  case $idx in 0) echo "$D0";; 1) echo "$D1";; 2) echo "$D2";; 3) echo "$D3";; 4) echo "$D4";; 5) echo "$D5";; 6) echo "$D6";; 7) echo "$D7";; esac
}
pick_medium() {
  local idx=$(( RANDOM % M_LEN ))
  case $idx in 0) echo "$M0";; 1) echo "$M1";; 2) echo "$M2";; 3) echo "$M3";; 4) echo "$M4";; 5) echo "$M5";; 6) echo "$M6";; 7) echo "$M7";; esac
}
pick_light() {
  local idx=$(( RANDOM % L_LEN ))
  case $idx in 0) echo "$L0";; 1) echo "$L1";; 2) echo "$L2";; 3) echo "$L3";; 4) echo "$L4";; 5) echo "$L5";; 6) echo "$L6";; 7) echo "$L7";; esac
}

SMOKE=""
if [ "$BODY_LEN" -lt "$MAX_LEN" ]; then
  BURNED=$(( MAX_LEN - BODY_LEN ))
  NUM_POS=$(( BURNED / 3 + 2 ))
  if [ "$NUM_POS" -gt 10 ]; then NUM_POS=10; fi

  for ((i=0; i<NUM_POS; i++)); do
    if [ "$i" -lt 2 ]; then
      C=$(pick_dense)
    elif [ "$i" -lt 5 ]; then
      C=$(pick_medium)
    else
      C=$(pick_light)
    fi

    if (( RANDOM % 4 == 0 )); then
      SMOKE="${SMOKE}${C} "
    else
      SMOKE="${SMOKE}${C}"
    fi
  done
fi

# Layout: XX%  |░filter░|[▓▓▓body▓▓▓]|[burn] [smoke →]
printf '%d%%  %s%s|%s %s' "$REMAINING" "$FILTER" "$BODY" "$BURN" "$SMOKE"
