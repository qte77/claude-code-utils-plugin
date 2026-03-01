# Pandoc Setup

Prerequisites and installation for PDF generation with citations.

## Install

### macOS

```bash
brew install pandoc
brew install --cask mactex-no-gui  # or: brew install basictex
```

### Ubuntu / Debian

```bash
sudo apt-get install pandoc texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra
```

### Windows

```powershell
winget install --id JohnMacFarlane.Pandoc
# Install MiKTeX from https://miktex.org/download
```

## Verify Installation

```bash
pandoc --version
pdflatex --version  # or: xelatex --version
```

Both commands must succeed before generating PDFs.

## Basic PDF Command

```bash
pandoc input.md -o output.pdf
```

## PDF with Citations

```bash
pandoc input.md \
  --citeproc \
  --bibliography=references.bib \
  --number-sections \
  -o output.pdf
```

## PDF with Custom CSL Style

```bash
pandoc input.md \
  --citeproc \
  --bibliography=references.bib \
  --csl=citation-styles/ieee.csl \
  --number-sections \
  -o output.pdf
```

## Multiple Input Files

Pandoc concatenates files in the order given:

```bash
pandoc 00_frontmatter.md 01_introduction.md 02_methods.md \
  --citeproc \
  --bibliography=references.bib \
  --number-sections \
  -o output.pdf
```

Or with a glob (sorted alphabetically):

```bash
cd docs/write-up/<topic> && \
pandoc *.md \
  --citeproc \
  --bibliography=references.bib \
  --number-sections \
  -o output.pdf
```

## Common Options

| Flag | Purpose |
|------|---------|
| `--citeproc` | Process citations from `.bib` file |
| `--bibliography=FILE` | Path to BibTeX bibliography |
| `--csl=FILE` | Citation Style Language file |
| `--number-sections` | Auto-number headings |
| `--toc` | Generate table of contents |
| `--pdf-engine=xelatex` | Use XeLaTeX (better Unicode support) |
| `-V geometry:margin=1in` | Set page margins |

## Troubleshooting

- **"pdflatex not found"** — Install a LaTeX distribution (TeX Live or MiKTeX)
- **"citeproc: could not find .bib"** — Use path relative to working directory
- **Unicode errors** — Switch to XeLaTeX: `--pdf-engine=xelatex`
