# docs-generator

Academic/technical writeup generation with IEEE citations. PDF export via pandoc optional.

## Skills

- **generating-writeup** — Generates academic/technical writeups with IEEE citations and pandoc PDF output

## Demo

Try it out after installing:

```text
/generating-writeup quantum computing IEEE
```

This will generate a structured writeup on the given topic with IEEE-style
citations, BibTeX bibliography, and a pandoc command to produce the final PDF.

## Bundled

- **Citation styles** — IEEE, APA, Chicago (CSL files in `scripts/writeup/citation-styles/`)
- **Makefile** — `pandoc_run`, `writeup`, `setup_pdf_converter` targets
- **SessionStart hook** — warns if pandoc or LaTeX are missing (PDF export only)

## Prerequisites (for PDF export)

Markdown writeups work without any prerequisites. For optional PDF generation:

- [pandoc](https://pandoc.org/installing.html) with citeproc support
- A LaTeX distribution ([TeX Live](https://tug.org/texlive/) or [MiKTeX](https://miktex.org/))

Auto-install with the bundled setup script:

```bash
make -f $CLAUDE_PLUGIN_ROOT/Makefile setup_pdf_converter
```

## Install

```bash
claude plugin install docs-generator@qte77-claude-code-utils
```
