# Docs-Only Makefile Scaffold

For repos that contain only markdown documentation — no code, no tests. Provides lychee (link checking) and markdownlint-cli2 (markdown style) with zero-sudo installs.

## Config Variables

```makefile
NODE_VERSION ?= 22.11.0
NODE_DIR     := $(HOME)/.local/share/node
NODE_BIN     := $(NODE_DIR)/bin
LOCAL_BIN    := $(HOME)/.local/bin
```

## Recipes

```makefile
# MARK: SETUP

setup_node: ## Install Node.js user-locally to ~/.local/share/node (no sudo)
    if [ -x "$(NODE_BIN)/node" ]; then
        echo "node already installed: $$($(NODE_BIN)/node --version) (at $(NODE_DIR))"
    elif command -v node > /dev/null 2>&1; then
        echo "node already installed on PATH: $$(node --version)"
    else
        echo "Installing Node.js $(NODE_VERSION) to $(NODE_DIR) ..."
        mkdir -p $(NODE_DIR)
        curl -sSfL https://nodejs.org/dist/v$(NODE_VERSION)/node-v$(NODE_VERSION)-linux-x64.tar.xz \
            | tar -xJ --strip-components=1 -C $(NODE_DIR) \
            && echo "node installed — add to PATH: export PATH=$(NODE_BIN):$$PATH" \
            || echo "Install failed — download manually from https://nodejs.org/dist/v$(NODE_VERSION)/"
    fi

setup_lychee: ## Install lychee link checker user-locally to ~/.local/bin (no sudo)
    if command -v lychee > /dev/null 2>&1; then
        echo "lychee already installed: $$(lychee --version)"
    else
        mkdir -p $(LOCAL_BIN)
        curl -sSfL https://github.com/lycheeverse/lychee/releases/latest/download/lychee-x86_64-unknown-linux-gnu.tar.gz \
            | tar xz -C $(LOCAL_BIN) \
            && echo "lychee installed to $(LOCAL_BIN) — ensure it is on PATH" \
            || echo "Install failed — download manually from https://github.com/lycheeverse/lychee/releases"
    fi

setup_mdlint: setup_node ## Install markdownlint-cli2 via user-local npm (no sudo)
    export PATH="$(NODE_BIN):$$PATH"
    if [ -x "$(NODE_BIN)/markdownlint-cli2" ]; then
        echo "markdownlint-cli2 already installed: $$(markdownlint-cli2 --version 2>&1 | head -1)"
    elif command -v markdownlint-cli2 > /dev/null 2>&1; then
        echo "markdownlint-cli2 already installed (system PATH): $$(markdownlint-cli2 --version 2>&1 | head -1)"
    else
        echo "Installing markdownlint-cli2 into $(NODE_DIR) ..."
        if [ -x "$(NODE_BIN)/npm" ] || command -v npm > /dev/null 2>&1; then
            npm install -g markdownlint-cli2
        else
            echo "ERROR: npm not found after setup_node — check Node install"
            exit 1
        fi
    fi

setup_all: setup_lychee setup_mdlint ## Install all tooling (lychee + node + markdownlint-cli2)

# MARK: DEV

check_links: ## Check links with lychee
    if command -v lychee > /dev/null 2>&1; then
        lychee --config lychee.toml .
    else
        echo "lychee not installed — run: make setup_lychee"
        exit 1
    fi

check_docs: ## Lint markdown files (reads .markdownlint.json)
    export PATH="$(NODE_BIN):$$PATH"
    if command -v markdownlint-cli2 > /dev/null 2>&1; then
        markdownlint-cli2 "README.md" "CHANGELOG.md" "CONTRIBUTING.md" "docs/**/*.md"
    else
        echo "markdownlint-cli2 not installed — run: make setup_mdlint"
        exit 1
    fi

autofix: ## Auto-fix markdown lint issues (markdownlint --fix)
    export PATH="$(NODE_BIN):$$PATH"
    if command -v markdownlint-cli2 > /dev/null 2>&1; then
        markdownlint-cli2 --fix "README.md" "CHANGELOG.md" "CONTRIBUTING.md" "docs/**/*.md"
    else
        echo "markdownlint-cli2 not installed — run: make setup_mdlint"
        exit 1
    fi

lint: check_links check_docs ## Run all linters (links + markdown)
```

## Notes

- `setup_node` is the root dependency for markdownlint — `setup_mdlint` chains from it
- `export PATH="$(NODE_BIN):$$PATH"` inside `.ONESHELL` recipes lets npm tools work without `~/.bashrc` edits
- Adjust the file glob in `check_docs` / `autofix` to match your doc layout
- Requires `lychee.toml` and `.markdownlint.json` config files in the repo root
- Known autofix pitfall: `markdownlint-cli2 --fix` can corrupt reference-style link definitions if a blank line is missing between a table and the link defs block. Always grep for `^\[[^]]*\]: <http` after autofix and revert affected files.

## Source

Validated in production: `qte77/ai-agents-research` PR #98 (2026-04-11).
