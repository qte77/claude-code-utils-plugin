#!/usr/bin/env bash
# Setup PDF converter tools (pandoc + LaTeX)
set -euo pipefail

show_help() {
  cat <<'HELP'
Usage: setup-pdf-converter.sh [CONVERTER]

Installs PDF converter toolchain for writeup generation.

CONVERTER:
  pandoc    Install pandoc + LaTeX distribution (default)
  help      Show this help message

Detected OS determines package manager:
  macOS   → brew install pandoc; brew install --cask mactex-no-gui
  Debian  → apt-get install pandoc texlive-latex-recommended ...
  RHEL    → dnf install pandoc texlive-scheme-basic ...
HELP
}

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ -f /etc/debian_version ]]; then
    echo "debian"
  elif [[ -f /etc/redhat-release ]]; then
    echo "rhel"
  else
    echo "unknown"
  fi
}

check_cmd() {
  command -v "$1" &>/dev/null
}

install_pandoc() {
  local os
  os=$(detect_os)

  if check_cmd pandoc; then
    echo "pandoc already installed: $(pandoc --version | head -1)"
  else
    echo "Installing pandoc..."
    case "$os" in
      macos)  brew install pandoc ;;
      debian) sudo apt-get update && sudo apt-get install -y pandoc ;;
      rhel)   sudo dnf install -y pandoc ;;
      *)      echo "ERROR: Unsupported OS. Install pandoc manually: https://pandoc.org/installing.html"; exit 1 ;;
    esac
  fi

  if check_cmd pdflatex || check_cmd xelatex; then
    echo "LaTeX already installed: $(pdflatex --version 2>/dev/null | head -1 || xelatex --version 2>/dev/null | head -1)"
  else
    echo "Installing LaTeX distribution..."
    case "$os" in
      macos)  brew install --cask mactex-no-gui ;;
      debian) sudo apt-get install -y texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra ;;
      rhel)   sudo dnf install -y texlive-scheme-basic ;;
      *)      echo "ERROR: Unsupported OS. Install TeX Live manually: https://tug.org/texlive/"; exit 1 ;;
    esac
  fi

  echo "Setup complete."
  pandoc --version | head -1
}

case "${1:-pandoc}" in
  help|-h|--help) show_help ;;
  pandoc)         install_pandoc ;;
  *)              echo "ERROR: Unknown converter '$1'. Use 'pandoc' or 'help'."; exit 1 ;;
esac
