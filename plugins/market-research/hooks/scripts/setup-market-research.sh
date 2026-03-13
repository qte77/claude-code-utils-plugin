#!/bin/bash
set -euo pipefail
# Deploy market-research config templates (copy-if-not-exists)

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
deployed=0

mkdir -p config

for tmpl in "$PLUGIN_DIR/config-templates/"*.md; do
  [ -f "$tmpl" ] || continue
  target="config/$(basename "$tmpl")"
  if [ ! -f "$target" ]; then
    cp "$tmpl" "$target"
    deployed=$((deployed + 1))
  fi
done

if [ "$deployed" -gt 0 ]; then
  echo "# Market Research Setup"
  echo ""
  echo "Deployed $deployed config template(s) to config/"
  echo "Edit config/ files to configure your research pipeline."
fi
