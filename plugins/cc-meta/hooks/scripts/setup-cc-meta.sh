#!/bin/bash
set -euo pipefail
# Deploy MEMORY.md seed template (copy-if-not-exists)

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
DEPLOYED=()

# MEMORY.md seed template
TARGET="MEMORY.md"
if [ ! -f "$TARGET" ]; then
  cp "$PLUGIN_DIR/examples/memory/MEMORY.md" "$TARGET"
  DEPLOYED+=("memory: MEMORY.md (seed template)")
fi

# Report
if [ ${#DEPLOYED[@]} -gt 0 ]; then
  echo "# CC Meta Setup"
  echo ""
  echo "Deployed ${#DEPLOYED[@]} file(s):"
  for item in "${DEPLOYED[@]}"; do
    echo "  - $item"
  done
fi
