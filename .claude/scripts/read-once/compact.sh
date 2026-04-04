#!/bin/bash
set -euo pipefail
# read-once: PostCompact hook — clears session cache after context compaction
# Prevents stale entries from blocking legitimate re-reads after context drops older content.

CACHE_DIR="${TMPDIR:-/tmp}/claude-read-once-$$"

if [ -d "$CACHE_DIR" ]; then
  rm -rf "$CACHE_DIR"
fi
