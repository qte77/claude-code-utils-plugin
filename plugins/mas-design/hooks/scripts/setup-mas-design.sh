#!/bin/bash
set -euo pipefail

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
DEPLOYED=()

# Best-practices docs → docs/best-practices/ (from skill references)
mkdir -p docs/best-practices
for ref in "$PLUGIN_DIR"/skills/*/references/*.md; do
  [ -f "$ref" ] || continue
  target="docs/best-practices/$(basename "$ref")"
  if [ ! -f "$target" ]; then
    cp -L "$ref" "$target"
    DEPLOYED+=("doc: $(basename "$ref")")
  fi
done

# Report
if [ ${#DEPLOYED[@]} -gt 0 ]; then
  echo "# MAS Design Setup"
  echo ""
  echo "Deployed ${#DEPLOYED[@]} file(s):"
  for item in "${DEPLOYED[@]}"; do
    echo "  - $item"
  done
fi
