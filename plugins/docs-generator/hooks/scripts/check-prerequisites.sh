#!/usr/bin/env bash
# Check optional PDF generation prerequisites on session start
missing=()

command -v pandoc &>/dev/null || missing+=("pandoc")

if ! command -v pdflatex &>/dev/null && ! command -v xelatex &>/dev/null; then
  missing+=("LaTeX (pdflatex or xelatex)")
fi

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "[docs-generator] PDF export unavailable — missing: ${missing[*]}"
  echo "[docs-generator] Markdown writeups will still be generated."
  echo "[docs-generator] To enable PDF: make -f \$CLAUDE_PLUGIN_ROOT/Makefile setup_pdf_converter"
fi
