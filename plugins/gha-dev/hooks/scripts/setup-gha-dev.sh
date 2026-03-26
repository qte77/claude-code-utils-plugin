#!/bin/bash
set -euo pipefail

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
DEPLOYED=()

# Deploy gh permissions to .claude/settings.local.json (copy-if-not-exists)
if command -v gh >/dev/null 2>&1; then
  TARGET=".claude/settings.local.json"
  if [ ! -f "$TARGET" ]; then
    mkdir -p .claude
    cp "$PLUGIN_DIR/settings/settings.local.json" "$TARGET"
    DEPLOYED+=("settings: settings.local.json (gh/bats/shellcheck/actionlint permissions)")
  fi
fi

# Report
if [ ${#DEPLOYED[@]} -gt 0 ]; then
  echo "# GHA Dev Setup"
  echo ""
  echo "Deployed ${#DEPLOYED[@]} file(s):"
  for item in "${DEPLOYED[@]}"; do
    echo "  - $item"
  done
fi
