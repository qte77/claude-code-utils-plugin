#!/bin/bash
set -euo pipefail

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
DEPLOYED=()

# 1. Deploy uv permissions to .claude/settings.local.json (copy-if-not-exists)
if command -v uv >/dev/null 2>&1; then
  TARGET=".claude/settings.local.json"
  if [ ! -f "$TARGET" ]; then
    mkdir -p .claude
    cp "$PLUGIN_DIR/settings/settings.local.json" "$TARGET"
    DEPLOYED+=("settings: settings.local.json (uv permissions)")
  fi
fi

# 2. Best-practices docs → docs/best-practices/ (from skill references)
SHARED_DIR="$(cd "$(dirname "$0")/../../.." && pwd)/_shared/scripts"
# shellcheck source=plugins/_shared/scripts/deploy-references.sh
source "$SHARED_DIR/deploy-references.sh"

# 3. Report
if [ ${#DEPLOYED[@]} -gt 0 ]; then
  echo "# Python Dev Setup"
  echo ""
  echo "Deployed ${#DEPLOYED[@]} file(s):"
  for item in "${DEPLOYED[@]}"; do
    echo "  - $item"
  done
fi
