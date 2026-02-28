# Makefile for claude-code-utils plugin development.
# Run `make help` to see all available recipes.

.SILENT:
.ONESHELL:
.PHONY: setup setup_claude_code setup_npm_tools validate lint_md test_install sync sync_rules check_sync help
.DEFAULT_GOAL := help


# MARK: setup


setup: setup_claude_code setup_npm_tools  ## Setup plugin dev environment (Claude Code + npm tools)
	# sudo apt-get install -y gh
	echo "Plugin dev environment ready."

setup_claude_code:  ## Install Claude Code CLI
	echo "Installing Claude Code CLI ..."
	curl -fsSL https://claude.ai/install.sh | bash
	echo "Claude Code CLI version: $$(claude --version)"

setup_npm_tools:  ## Install markdownlint for linting skill markdown
	echo "Installing npm dev tools ..."
	npm install -gs markdownlint-cli
	echo "markdownlint version: $$(markdownlint --version)"


# MARK: sync


sync: sync_rules  ## Sync .claude/ SoT into plugin dirs

sync_rules:  ## Sync rules from .claude/rules/ to plugin copies
	cp .claude/rules/core-principles.md plugins/workspace-setup/rules/
	cp .claude/rules/context-management.md plugins/workspace-setup/rules/
	cp .claude/rules/core-principles.md plugins/codebase-tools/skills/researching-codebase/references/
	cp .claude/rules/context-management.md plugins/codebase-tools/skills/researching-codebase/references/
	cp .claude/rules/context-management.md plugins/codebase-tools/skills/compacting-context/references/

check_sync:  ## Verify all copies are in sync with .claude/ SoT
	@echo "Checking sync..."
	@diff -q .claude/rules/core-principles.md plugins/workspace-setup/rules/core-principles.md
	@diff -q .claude/rules/context-management.md plugins/workspace-setup/rules/context-management.md
	@diff -q .claude/rules/core-principles.md plugins/codebase-tools/skills/researching-codebase/references/core-principles.md
	@diff -q .claude/rules/context-management.md plugins/codebase-tools/skills/researching-codebase/references/context-management.md
	@diff -q .claude/rules/context-management.md plugins/codebase-tools/skills/compacting-context/references/context-management.md
	@echo "All copies in sync."


# MARK: quality


validate:  ## Validate all plugins (structure + JSON syntax)
	echo "Validating plugin structure ..."
	claude plugin validate .
	echo ""
	echo "Checking JSON syntax ..."
	find . -name '*.json' -not -path './.git/*' -not -path './node_modules/*' \
		-exec sh -c 'python3 -m json.tool "$$1" > /dev/null' _ {} \;
	echo "All JSON files valid."

lint_md:  ## Lint all markdown files in plugins/
	markdownlint 'plugins/**/*.md' --fix


# MARK: test


test_install:  ## Test local marketplace install (add + install first plugin)
	echo "Testing local marketplace install ..."
	FIRST_PLUGIN=$$(python3 -c "import json; print(json.load(open('.claude-plugin/marketplace.json'))['plugins'][0]['name'])")
	MARKETPLACE=$$(python3 -c "import json; print(json.load(open('.claude-plugin/marketplace.json'))['name'])")
	echo "Adding marketplace: $$MARKETPLACE"
	claude plugin marketplace add .
	echo "Installing plugin: $$FIRST_PLUGIN@$$MARKETPLACE"
	claude plugin install "$$FIRST_PLUGIN@$$MARKETPLACE"
	echo "Test install succeeded."


# MARK: help


help:  ## Show available recipes
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
