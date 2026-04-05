#!/usr/bin/env bash
# lint-makefile.sh — Lint a Makefile for org conventions.
# Usage: lint-makefile.sh [path/to/Makefile]
# Exit 0 = pass, 1 = failures found.

set -uo pipefail

MAKEFILE="${1:-Makefile}"
ERRORS=0

fail() {
  echo "FAIL: $1"
  ERRORS=$((ERRORS + 1))
}

if [[ ! -f "$MAKEFILE" ]]; then
  echo "ERROR: $MAKEFILE not found"
  exit 1
fi

# --- Required directives ---

grep -q '\.ONESHELL' "$MAKEFILE" \
  || fail ".ONESHELL not found"

grep -q '\.SILENT' "$MAKEFILE" \
  || fail ".SILENT not found"

grep -q '\.DEFAULT_GOAL' "$MAKEFILE" \
  || fail ".DEFAULT_GOAL not set"

grep -q '\.PHONY' "$MAKEFILE" \
  || fail ".PHONY declaration not found"

# --- Version guard ---

grep -q 'oneshell.*\.FEATURES\|\.FEATURES.*oneshell' "$MAKEFILE" \
  || fail "GNU Make version guard (.FEATURES/oneshell check) not found"

# --- Sections ---

grep -q '^# MARK:' "$MAKEFILE" \
  || fail "No # MARK: sections found"

# --- Help recipe ---

grep -qE '^help:|^show_help:' "$MAKEFILE" \
  || fail "No help recipe found"

# --- Recipe documentation ---

# Count recipes (lines matching "name: ...") vs documented recipes ("name: ... ##")
TOTAL_RECIPES=$(grep -E '^[a-zA-Z0-9_-]+:' "$MAKEFILE" 2>/dev/null | wc -l)
DOCUMENTED=$(grep -E '^[a-zA-Z0-9_-]+:.*##' "$MAKEFILE" 2>/dev/null | wc -l)

if [[ "$TOTAL_RECIPES" -gt 0 && "$DOCUMENTED" -lt "$TOTAL_RECIPES" ]]; then
  UNDOCUMENTED=$((TOTAL_RECIPES - DOCUMENTED))
  fail "$UNDOCUMENTED recipe(s) missing ## description comment"
fi

# --- Naming ---

BAD_NAMES=$(grep -oE '^[a-zA-Z0-9_-]+:' "$MAKEFILE" | sed 's/://' | grep -E '[A-Z]' | grep -v '^[A-Z_]*$' || true)
if [[ -n "$BAD_NAMES" ]]; then
  fail "Non-snake_case recipe names: $BAD_NAMES"
fi

# --- Results ---

if [[ "$ERRORS" -eq 0 ]]; then
  echo "OK: $MAKEFILE passes all checks"
  exit 0
else
  echo ""
  echo "$ERRORS check(s) failed"
  exit 1
fi
