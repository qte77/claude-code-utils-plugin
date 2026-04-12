# Shell/BATS Makefile Scaffold

## Recipes

```makefile
# MARK: SETUP

setup_dev: ## Install dev dependencies (shellcheck, bats)
    if ! command -v shellcheck > /dev/null 2>&1; then
        mkdir -p ~/.local/bin
        SHELLCHECK_VERSION="stable"
        curl -sSfL "https://github.com/koalaman/shellcheck/releases/download/$${SHELLCHECK_VERSION}/shellcheck-$${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" \
            | tar -xJ --strip-components=1 -C ~/.local/bin shellcheck-$${SHELLCHECK_VERSION}/shellcheck
    fi
    if ! command -v bats > /dev/null 2>&1; then
        echo "bats not found — install via: git clone https://github.com/bats-core/bats-core && cd bats-core && ./install.sh ~/.local"
    fi

# MARK: DEV

test: ## Run BATS tests
    bats test/

lint: ## Run shellcheck on all scripts
    shellcheck scripts/*.sh

validate: lint test ## Full validation (lint + test)

clean: ## Remove artifacts
    rm -rf tmp/ coverage/
```

## Notes

- shellcheck installed via GitHub release binary to `~/.local/bin` (no sudo)
- bats requires manual install or git clone (no single-binary release)
- Adjust `test/` and `scripts/*.sh` paths to match your project layout
