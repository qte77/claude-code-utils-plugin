---
name: creating-makefile
description: Scaffold or review Makefiles following org conventions. Use when creating a new Makefile, auditing an existing one, or adding recipes to a project.
compatibility: Designed for Claude Code
metadata:
  allowed-tools: Read, Grep, Glob, Edit, Write, Bash
  argument-hint: [project-name-or-makefile-path]
  stability: stable
---

# Creating Makefiles

**Target**: $ARGUMENTS

Creates or reviews a **rigorous, consistent Makefile** following org conventions.

## Quick Reference

- Required structure + patterns: `references/makefile-conventions.md`
- CI linter script: `references/lint-makefile.sh`

## Required Structure

Every Makefile must have these elements in order:

```makefile
# Header comment describing the project
# Run `make` to see all available recipes.

# GNU Make version guard
ifeq ($(filter oneshell,$(.FEATURES)),)
$(error GNU Make >= 3.82 required (.ONESHELL). macOS ships 3.81 — install via: brew install make, then use gmake)
endif

.SILENT:
.ONESHELL:
.PHONY: \
	recipe_a recipe_b \
	help
.DEFAULT_GOAL := help

# -- config --
VERBOSE ?= 0
ifeq ($(VERBOSE),0)
  # quiet flags per tool
endif
```

## Conventions

- **snake_case** for all recipe names
- **`## description`** comment on every public recipe (for help output)
- **`# MARK: SECTION`** to group related recipes
- **`setup_*`** prefix for installation recipes (never bare `install`)
- **`validate`** chains `lint` + `test` (when both exist)
- **Idempotent setup**: `command -v X >/dev/null || install X`
- **No hardcoded paths** — use variables at top of file
- **`VERBOSE ?= 0`** with conditional quiet flags per tool

## Scaffold by Project Type

### Shell/BATS project
```makefile
# MARK: SETUP
setup_dev:  ## Install dev dependencies

# MARK: QUALITY
test:       ## Run tests (VERBOSE=1 for full output)
lint:       ## Run shellcheck/actionlint
validate: lint test  ## Full validation

# MARK: CLEANUP
clean:      ## Remove artifacts

# MARK: HELP
help:       ## Show available recipes
```

### Python (uv) project
```makefile
# MARK: SETUP
setup_dev:  ## Install dev + test dependencies

# MARK: QUALITY
test:       ## Run pytest
lint:       ## Ruff format + check
check_types: ## Pyright
validate: lint check_types test  ## Full validation

# MARK: HELP
help:       ## Show available recipes
```

## Help Recipe (standard pattern)

```makefile
help:  ## Show available recipes grouped by section
	@echo "Usage: make [recipe]"
	@echo ""
	@awk '/^# MARK:/ { \
		section = substr($$0, index($$0, ":")+2); \
		printf "\n\033[1m%s\033[0m\n", section \
	} \
	/^[a-zA-Z0-9_-]+:.*?##/ { \
		helpMessage = match($$0, /## (.*)/); \
		if (helpMessage) { \
			recipe = $$1; \
			sub(/:/, "", recipe); \
			printf "  \033[36m%-22s\033[0m %s\n", recipe, substr($$0, RSTART + 3, RLENGTH) \
		} \
	}' $(MAKEFILE_LIST)
```

## Workflow

1. **Check** if Makefile exists — create or review
2. **Lint** with `references/lint-makefile.sh` — fix any failures
3. **Verify** `make` shows help, `make validate` runs clean
4. **Commit** Makefile changes

## Quality Gates

- [ ] GNU Make version guard present
- [ ] `.SILENT`, `.ONESHELL`, `.DEFAULT_GOAL := help` set
- [ ] Full `.PHONY` list up front
- [ ] Every recipe has `## description` comment
- [ ] `# MARK:` sections group related recipes
- [ ] `snake_case` recipe names only
- [ ] `help` recipe with standard awk pattern
- [ ] `VERBOSE ?= 0` with quiet mode support
- [ ] `lint-makefile.sh` passes
