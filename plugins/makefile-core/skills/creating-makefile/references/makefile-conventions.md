# Makefile Conventions

## Required Elements (checked by lint-makefile.sh)

| Element | Why |
|---------|-----|
| `.ONESHELL` | Multi-line recipes run in one shell — no `&&` chains needed |
| `.SILENT` | Suppress recipe echo — cleaner output |
| `.DEFAULT_GOAL := help` | `make` without args shows help |
| `.PHONY` block | Declare all targets — prevent file-name collisions |
| `# MARK:` sections | Group recipes — parsed by help recipe |
| `## comment` on recipes | Self-documenting — parsed by help recipe |
| `help` recipe | Standard awk pattern for grouped, colored output |
| Version guard | Catch GNU Make < 3.82 (macOS default) |

## Naming

- `snake_case` for recipes: `setup_dev`, `run_tests`, `check_types`
- `UPPER_CASE` for variables: `VERBOSE`, `OUTPUT_DIR`, `SRC_PATH`
- `setup_*` for installation (never bare `install` — conflicts with system `install`)
- `clean_*` for cleanup variants (`clean_logs`, `clean_results`)

## Patterns

### Idempotent setup
```makefile
setup_dev:
	command -v bats >/dev/null || npm install -g bats
	command -v shellcheck >/dev/null || sudo apt-get install -y shellcheck
```

### Quiet mode
```makefile
VERBOSE ?= 0
ifeq ($(VERBOSE),0)
  PYTEST_QUIET := -q --tb=short --no-header
  RUFF_QUIET := --quiet
  BATS_FILTER := | grep -v '^ok '
endif
```

### Validation chain
```makefile
validate: lint test  ## Full validation (lint + test)
quick_validate: lint check_types  ## Fast validation (no tests)
```

### Conditional dependencies
```makefile
setup_all: setup_dev setup_cad setup_slicer  ## Install all
```

## Anti-Patterns

| Don't | Do |
|-------|-----|
| `install:` | `setup_dev:` |
| Hardcoded paths in recipes | Variables at top |
| `@` prefix per line | `.SILENT` globally |
| Missing `.PHONY` | Full list up front |
| No `help` recipe | Standard awk pattern |
| `echo` for status | Rely on `.SILENT` + explicit echo only when needed |
