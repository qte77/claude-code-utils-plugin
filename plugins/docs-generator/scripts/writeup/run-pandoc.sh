#!/usr/bin/env bash
# Convert Markdown to PDF using pandoc with citation support
set -euo pipefail

show_help() {
  cat <<'HELP'
Usage: run-pandoc.sh INPUT_FILES OUTPUT_FILE [TITLE_PAGE] [TEMPLATE] \
         [FOOTER_TEXT] [TOC_TITLE] [LANGUAGE] [NUMBER_SECTIONS] \
         [BIBLIOGRAPHY] [CSL] [LIST_OF_FIGURES] [LIST_OF_TABLES] \
         [UNNUMBERED_TITLE]

Arguments (positional):
  INPUT_FILES       Record-separated (\036) list of input .md files
  OUTPUT_FILE       Output PDF path
  TITLE_PAGE        Title page file (optional)
  TEMPLATE          LaTeX template (optional)
  FOOTER_TEXT       Footer text (optional)
  TOC_TITLE         Table of contents title (optional)
  LANGUAGE          Language code, e.g. en-US, de-DE (optional)
  NUMBER_SECTIONS   Enable section numbering: true/false (optional)
  BIBLIOGRAPHY      Path to .bib file (optional)
  CSL               Path to .csl citation style (optional)
  LIST_OF_FIGURES   Generate list of figures: true/false (optional)
  LIST_OF_TABLES    Generate list of tables: true/false (optional)
  UNNUMBERED_TITLE  Unnumbered title page: true/false (optional)

Examples:
  # Basic conversion
  run-pandoc.sh "file.md" "output.pdf"

  # With citations
  dir=docs/write-up/topic
  run-pandoc.sh "$(printf '%s\036' $dir/*.md)" "$dir/output.pdf" \
    "" "" "" "" "" "true" "$dir/references.bib" "citation-styles/ieee.csl"
HELP
}

if [[ "${1:-}" == "help" ]] || [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

if [[ $# -lt 2 ]]; then
  echo "ERROR: At least INPUT_FILES and OUTPUT_FILE required."
  echo "Run with 'help' for usage."
  exit 1
fi

# Parse positional arguments
INPUT_FILES="${1}"
OUTPUT_FILE="${2}"
TITLE_PAGE="${3:-}"
TEMPLATE="${4:-}"
FOOTER_TEXT="${5:-}"
TOC_TITLE="${6:-}"
LANGUAGE="${7:-}"
NUMBER_SECTIONS="${8:-}"
BIBLIOGRAPHY="${9:-}"
CSL="${10:-}"
LIST_OF_FIGURES="${11:-}"
LIST_OF_TABLES="${12:-}"
UNNUMBERED_TITLE="${13:-}"

# Verify pandoc is installed
if ! command -v pandoc &>/dev/null; then
  echo "ERROR: pandoc not found. Run: make setup_pdf_converter"
  exit 1
fi

# Build pandoc command
CMD=(pandoc)

# Parse record-separated input files
IFS=$'\036' read -ra FILES <<< "$INPUT_FILES"
for f in "${FILES[@]}"; do
  [[ -n "$f" ]] && CMD+=("$f")
done

CMD+=(-o "$OUTPUT_FILE")
CMD+=(--toc)

# Optional flags
[[ -n "$TEMPLATE" ]]       && CMD+=(--template="$TEMPLATE")
[[ -n "$TOC_TITLE" ]]      && CMD+=(-V toc-title="$TOC_TITLE")
[[ -n "$LANGUAGE" ]]        && CMD+=(-V lang="$LANGUAGE")
[[ -n "$FOOTER_TEXT" ]]     && CMD+=(-V footer-left="$FOOTER_TEXT")
[[ "$NUMBER_SECTIONS" == "true" ]] && CMD+=(--number-sections)

# Citation support
if [[ -n "$BIBLIOGRAPHY" ]]; then
  CMD+=(--citeproc --bibliography="$BIBLIOGRAPHY")
  [[ -n "$CSL" ]] && CMD+=(--csl="$CSL")
fi

# Title page
if [[ -n "$TITLE_PAGE" ]]; then
  CMD+=(-B "$TITLE_PAGE")
fi

# Lists of figures/tables
[[ "$LIST_OF_FIGURES" == "true" ]] && CMD+=(-V lof=true)
[[ "$LIST_OF_TABLES" == "true" ]]  && CMD+=(-V lot=true)

# Unnumbered title
[[ "$UNNUMBERED_TITLE" == "true" ]] && CMD+=(-V unnumbered-title=true)

echo "Running: ${CMD[*]}"
"${CMD[@]}"
echo "Output: $OUTPUT_FILE"
