#!/bin/bash
set -euo pipefail
# read-once: PreToolUse hook for Read tool deduplication
# Prevents redundant file re-reads within a session, saving ~2K tokens per blocked read.
# Source: Bande-a-Bonnot/Boucle-framework (MIT)

CACHE_DIR="${TMPDIR:-/tmp}/claude-read-once-$$"
MODE="${READ_ONCE_MODE:-warn}"
TTL="${READ_ONCE_TTL:-1200}"
DIFF_ENABLED="${READ_ONCE_DIFF:-0}"
DIFF_MAX="${READ_ONCE_DIFF_MAX:-40}"

[ "${READ_ONCE_DISABLED:-0}" = "1" ] && exit 0

mkdir -p "$CACHE_DIR"

# Parse tool input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
HAS_OFFSET=$(echo "$INPUT" | jq -r '.tool_input.offset // empty')
HAS_LIMIT=$(echo "$INPUT" | jq -r '.tool_input.limit // empty')

# Partial reads always pass through
[ -n "$HAS_OFFSET" ] || [ -n "$HAS_LIMIT" ] && exit 0

# No file path = pass through
[ -z "$FILE_PATH" ] && exit 0

# File doesn't exist = pass through (let Read tool handle the error)
[ ! -f "$FILE_PATH" ] && exit 0

# Cache key: hash of absolute path
CACHE_KEY=$(echo -n "$(realpath "$FILE_PATH")" | md5sum | cut -d' ' -f1)
CACHE_FILE="$CACHE_DIR/$CACHE_KEY"

# Current mtime
CURRENT_MTIME=$(stat -c %Y "$FILE_PATH" 2>/dev/null || stat -f %m "$FILE_PATH" 2>/dev/null)

if [ -f "$CACHE_FILE" ]; then
  CACHED_MTIME=$(sed -n '1p' "$CACHE_FILE")
  CACHED_TIME=$(sed -n '2p' "$CACHE_FILE")
  NOW=$(date +%s)

  # TTL expired = allow and refresh
  if [ $((NOW - CACHED_TIME)) -ge "$TTL" ]; then
    echo "$CURRENT_MTIME" > "$CACHE_FILE"
    echo "$NOW" >> "$CACHE_FILE"
    exit 0
  fi

  # File changed since last read
  if [ "$CURRENT_MTIME" != "$CACHED_MTIME" ]; then
    echo "$CURRENT_MTIME" > "$CACHE_FILE"
    echo "$NOW" >> "$CACHE_FILE"

    # Diff mode: show changes only
    if [ "$DIFF_ENABLED" = "1" ]; then
      DIFF_LINES=$(diff -u /dev/null "$FILE_PATH" 2>/dev/null | wc -l || echo 999)
      if [ "$DIFF_LINES" -le "$DIFF_MAX" ]; then
        echo '{"decision":"block","reason":"File changed — showing diff only (read-once diff mode)"}'
        exit 0
      fi
    fi
    exit 0
  fi

  # File unchanged = redundant read
  if [ "$MODE" = "deny" ]; then
    echo "{\"decision\":\"block\",\"reason\":\"read-once: $FILE_PATH already in context (unchanged). Use Edit directly.\"}"
    exit 0
  fi

  # Warn mode: allow but advise
  echo "{\"decision\":\"allow\",\"reason\":\"read-once: $FILE_PATH already read and unchanged. Consider skipping redundant reads.\"}"
  exit 0
fi

# First read: cache and allow
NOW=$(date +%s)
echo "$CURRENT_MTIME" > "$CACHE_FILE"
echo "$NOW" >> "$CACHE_FILE"
exit 0
