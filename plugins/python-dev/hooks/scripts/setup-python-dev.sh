#!/bin/bash
set -euo pipefail

# Skip if uv not available
command -v uv >/dev/null 2>&1 || exit 0

# Deploy uv permissions to .claude/settings.local.json (copy-if-not-exists)
TARGET=".claude/settings.local.json"
if [ ! -f "$TARGET" ]; then
  mkdir -p .claude
  cp "$CLAUDE_PLUGIN_ROOT/settings/settings.local.json" "$TARGET"
  echo "# Python Dev Setup"
  echo ""
  echo "Deployed uv permissions to $TARGET"
fi
