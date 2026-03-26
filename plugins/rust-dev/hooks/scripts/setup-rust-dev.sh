#!/bin/bash
set -euo pipefail

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
SCAFFOLD_DIR="$PLUGIN_DIR/scaffold"
DEPLOYED=()

# Deploy cargo permissions to .claude/settings.local.json (copy-if-not-exists)
if command -v cargo >/dev/null 2>&1; then
  TARGET=".claude/settings.local.json"
  if [ ! -f "$TARGET" ]; then
    mkdir -p .claude
    cp "$PLUGIN_DIR/settings/settings.local.json" "$TARGET"
    DEPLOYED+=("settings: settings.local.json (cargo permissions)")
  fi
fi

# Deploy scaffold adapter (copy-if-not-exists)
if [ -f ".scaffold" ] && [ "$(cat .scaffold 2>/dev/null)" = "rust" ]; then
  # Adapter script for Ralph Loop
  mkdir -p .scaffolds
  if [ ! -f ".scaffolds/rust.sh" ]; then
    cp "$SCAFFOLD_DIR/adapter.sh" ".scaffolds/rust.sh"
    DEPLOYED+=("scaffold: .scaffolds/rust.sh (Ralph adapter)")
  fi

  # Testing rule (copy-if-not-exists)
  if [ -d "$SCAFFOLD_DIR/rules" ]; then
    mkdir -p .claude/rules
    for rule_file in "$SCAFFOLD_DIR/rules/"*.md; do
      [ -f "$rule_file" ] || continue
      local_name=".claude/rules/$(basename "$rule_file")"
      if [ ! -f "$local_name" ]; then
        cp "$rule_file" "$local_name"
        DEPLOYED+=("rule: $(basename "$rule_file")")
      fi
    done
  fi

  # CI workflows (copy-if-not-exists)
  if [ -d "$SCAFFOLD_DIR/workflows" ]; then
    mkdir -p .github/workflows
    for wf_file in "$SCAFFOLD_DIR/workflows/"*.yaml; do
      [ -f "$wf_file" ] || continue
      local_name=".github/workflows/$(basename "$wf_file")"
      if [ ! -f "$local_name" ]; then
        cp "$wf_file" "$local_name"
        DEPLOYED+=("workflow: $(basename "$wf_file")")
      fi
    done
  fi

  # Dependabot config (copy-if-not-exists)
  if [ -f "$SCAFFOLD_DIR/workflows/dependabot.yaml" ] && [ ! -f ".github/dependabot.yaml" ]; then
    cp "$SCAFFOLD_DIR/workflows/dependabot.yaml" ".github/dependabot.yaml"
    DEPLOYED+=("config: dependabot.yaml")
  fi
fi

# Report
if [ ${#DEPLOYED[@]} -gt 0 ]; then
  echo "# Rust Dev Setup"
  echo ""
  echo "Deployed ${#DEPLOYED[@]} file(s):"
  for item in "${DEPLOYED[@]}"; do
    echo "  - $item"
  done
fi
