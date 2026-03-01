#!/bin/bash
set -euo pipefail

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
DEPLOYED=()

# Best-practices docs → docs/best-practices/ (from skill references)
SHARED_DIR="$(cd "$(dirname "$0")/../../.." && pwd)/_shared/scripts"
# shellcheck source=plugins/_shared/scripts/deploy-references.sh
source "$SHARED_DIR/deploy-references.sh"

# Report
if [ ${#DEPLOYED[@]} -gt 0 ]; then
  echo "# MAS Design Setup"
  echo ""
  echo "Deployed ${#DEPLOYED[@]} file(s):"
  for item in "${DEPLOYED[@]}"; do
    echo "  - $item"
  done
fi
