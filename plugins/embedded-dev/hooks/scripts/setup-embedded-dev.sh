#!/bin/sh
set -eu

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
deployed=0

# Deploy embedded permissions to .claude/settings.local.json (copy-if-not-exists)
if command -v gcc >/dev/null 2>&1; then
  TARGET=".claude/settings.local.json"
  if [ ! -f "$TARGET" ]; then
    mkdir -p .claude
    cp "$PLUGIN_DIR/settings/settings.local.json" "$TARGET"
    deployed=$((deployed + 1))
  fi
fi

# Report
if [ "$deployed" -gt 0 ]; then
  echo "# Embedded Dev Setup"
  echo ""
  echo "Deployed settings.local.json (embedded C toolchain permissions)"
fi
