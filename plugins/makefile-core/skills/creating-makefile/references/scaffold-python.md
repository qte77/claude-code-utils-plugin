# Python (uv) Makefile Scaffold

## Config Variables

```makefile
VERBOSE ?= 0
ifeq ($(VERBOSE),0)
RUFF_QUIET := --quiet
PYTEST_QUIET := -q --tb=short --no-header
PYRIGHT_QUIET := > /dev/null
else
RUFF_QUIET :=
PYTEST_QUIET :=
PYRIGHT_QUIET :=
endif
```

## Recipes

```makefile
# MARK: SETUP

setup_uv: ## Install uv package manager (if missing)
    if command -v uv > /dev/null 2>&1; then
        echo "uv already installed: $$(uv --version)"
    else
        echo "Installing uv ..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        echo ""
        echo "NOTE: restart your shell or run 'source $$HOME/.local/bin/env' to add uv to PATH"
    fi

setup_dev: setup_uv ## Install dev + test dependencies
    uv sync

setup_all: setup_dev ## Install all dependencies + tools

# MARK: DEV

autofix: ## Auto-format and fix lint issues (use before committing)
    uv run ruff format . $(RUFF_QUIET) && uv run ruff check . --fix $(RUFF_QUIET)

lint: ## Check formatting + lint (fails on issues, does not fix)
    uv run ruff format --check . $(RUFF_QUIET) && uv run ruff check . $(RUFF_QUIET)

check_types: ## Run pyright type checking
    uv run pyright app $(PYRIGHT_QUIET)

test: ## Run all tests with pytest
    uv run pytest $(PYTEST_QUIET)

test_cov: ## Run tests with coverage report
    uv run pytest --cov=app --cov-fail-under=80 $(PYTEST_QUIET)

retest: ## Rerun last failed tests only
    uv run pytest --lf -x

quick_validate: lint check_types ## Fast gate (lint + type check)

validate: lint check_types test_cov ## Full gate (lint + types + tests + coverage)
```

## Notes

- Use `uv run` for all Python tool invocations (no global pip installs)
- `setup_uv` is the root dependency — all other setup recipes chain from it
- `VERBOSE ?= 0` controls quiet flags for ruff, pytest, pyright
- `validate` is the full CI-equivalent gate; `quick_validate` skips tests for speed
