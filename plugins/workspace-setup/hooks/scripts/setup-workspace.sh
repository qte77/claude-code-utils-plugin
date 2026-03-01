#!/bin/bash
set -euo pipefail
# Deploy workspace rules, scripts, and base settings (copy-if-not-exists)

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
DEPLOYED=()

# 1. Rules → .claude/rules/
mkdir -p .claude/rules
for rule in "$PLUGIN_DIR/rules/"*.md; do
  [ -f "$rule" ] || continue
  target=".claude/rules/$(basename "$rule")"
  if [ ! -f "$target" ]; then
    cp "$rule" "$target"
    DEPLOYED+=("rule: $(basename "$rule")")
  fi
done

# 2. Statusline → .claude/scripts/
mkdir -p .claude/scripts
if [ ! -f ".claude/scripts/statusline.sh" ]; then
  cp "$PLUGIN_DIR/scripts/statusline.sh" ".claude/scripts/statusline.sh"
  DEPLOYED+=("script: statusline.sh")
fi

# 3. Base settings → .claude/settings.json (only if missing)
if [ ! -f ".claude/settings.json" ]; then
  cp "$PLUGIN_DIR/settings/settings-base.json" ".claude/settings.json"
  DEPLOYED+=("settings: settings.json (base)")
fi

# 4. Report
if [ ${#DEPLOYED[@]} -gt 0 ]; then
  echo "# Workspace Setup"
  echo ""
  echo "Deployed ${#DEPLOYED[@]} file(s):"
  for item in "${DEPLOYED[@]}"; do
    echo "  - $item"
  done
fi
