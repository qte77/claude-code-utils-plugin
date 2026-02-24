#!/bin/bash
set -euo pipefail

# SessionStart hook: notify about recommended workspace settings

SETTINGS_FILE="$CLAUDE_PLUGIN_ROOT/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
  echo "Warning: settings.json not found at $SETTINGS_FILE" >&2
  exit 0
fi

echo "# Recommended Settings"
echo ""
echo "The workspace-settings plugin includes recommended workspace settings at:"
echo "$SETTINGS_FILE"
echo ""
echo "Copy to \`.claude/settings.json\` if not already configured."
