# docs-generator plugin Makefile
# Usage: make -f $CLAUDE_PLUGIN_ROOT/Makefile <target>
.SILENT:
.ONESHELL:
.PHONY: setup_pdf_converter pandoc_run writeup writeup_generate

PLUGIN_ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# -- pandoc / writeup --
PANDOC_SCRIPT := $(PLUGIN_ROOT)scripts/writeup/run-pandoc.sh
PDF_CONVERTER_SCRIPT := $(PLUGIN_ROOT)scripts/writeup/setup-pdf-converter.sh
# pandoc_run optional overrides (empty = disabled)
BIBLIOGRAPHY :=
CSL :=
LIST_OF_FIGURES :=
LIST_OF_TABLES :=
UNNUMBERED_TITLE :=
# writeup recipe overrides
WRITEUP_DIR ?= docs/write-up
WRITEUP_OUTPUT ?= $(WRITEUP_DIR)/writeup.pdf
WRITEUP_BIB ?= $(WRITEUP_DIR)/09a_bibliography.bib
WRITEUP_CSL ?= $(PLUGIN_ROOT)scripts/writeup/citation-styles/ieee.csl
WRITEUP_PUML_DIR := docs/arch_vis
SKIP_PUML ?=
SKIP_CONTENT ?= 1
WRITEUP_TIMEOUT ?= 600

setup_pdf_converter:  ## Setup PDF converter tools. Usage: make setup_pdf_converter CONVERTER=pandoc | For help: make setup_pdf_converter HELP
	if [ -n "$(HELP)" ] || [ "$(origin HELP)" = "command line" ]; then
		$(PDF_CONVERTER_SCRIPT) help
	else
		chmod +x $(PDF_CONVERTER_SCRIPT)
		$(PDF_CONVERTER_SCRIPT) "$(CONVERTER)"
	fi

pandoc_run:  ## Convert MD to PDF using pandoc. Usage: dir=docs/en && make pandoc_run INPUT_FILES="$$(printf '%s\036' $$dir/*.md)" OUTPUT_FILE="$$dir/report.pdf" [BIBLIOGRAPHY="$$dir/refs.bib"] [CSL="style.csl"] | Help: make pandoc_run HELP=1
	if [ -n "$(HELP)" ]; then
		$(PANDOC_SCRIPT) help
	else
		chmod +x $(PANDOC_SCRIPT)
		$(PANDOC_SCRIPT) "$(INPUT_FILES)" "$(OUTPUT_FILE)" \
			"$(TITLE_PAGE)" "$(TEMPLATE)" "$(FOOTER_TEXT)" \
			"$(TOC_TITLE)" "$(LANGUAGE)" "$(NUMBER_SECTIONS)" \
			"$(BIBLIOGRAPHY)" "$(CSL)" \
			"$(LIST_OF_FIGURES)" "$(LIST_OF_TABLES)" "$(UNNUMBERED_TITLE)"
	fi

# Convenience wrapper: content generation + PlantUML regen + pandoc PDF build.
writeup:  ## Build writeup PDF. Usage: make writeup WRITEUP_DIR=docs/write-up/topic [LANGUAGE=de-DE] [SKIP_CONTENT=1] [SKIP_PUML=1]
	if [ -z "$(SKIP_CONTENT)" ]; then
		echo "=== Generating writeup content with Claude Code teams ==="
		$(MAKE) writeup_generate
	fi
	if [ -z "$(SKIP_PUML)" ]; then
		echo "=== Regenerating PlantUML diagrams ==="
		for f in $(WRITEUP_PUML_DIR)/*.plantuml $(WRITEUP_PUML_DIR)/*.puml; do
			[ -f "$$f" ] || continue
			echo "  Processing $$f ..."
			$(MAKE) plantuml_render INPUT_FILE="$$f" STYLE="light" OUTPUT_PATH="assets/images"
		done
	fi
	echo "=== Building writeup PDF ==="
	$(MAKE) pandoc_run \
		INPUT_FILES="$$(printf '%s\036' $(WRITEUP_DIR)/01_*.md $(WRITEUP_DIR)/0[2-8]_*.md $(WRITEUP_DIR)/09b_*.md $(WRITEUP_DIR)/10_*.md $(WRITEUP_DIR)/11_*.md)" \
		OUTPUT_FILE="$(WRITEUP_OUTPUT)" \
		BIBLIOGRAPHY="$(WRITEUP_BIB)" \
		CSL="$(WRITEUP_CSL)" \
		LANGUAGE="$(LANGUAGE)" \
		NUMBER_SECTIONS="true" \
		LIST_OF_FIGURES="true" \
		LIST_OF_TABLES="false" \
		UNNUMBERED_TITLE="true"
	echo "=== Writeup PDF: $(WRITEUP_OUTPUT) ==="

# Generate writeup content using CC teams + /generating-writeup skill.
writeup_generate:  ## Generate writeup markdown via CC teams. Usage: make writeup_generate WRITEUP_DIR=docs/write-up/topic [WRITEUP_TIMEOUT=600] [CC_MODEL=sonnet]
	echo "=== Generating writeup content (timeout: $(WRITEUP_TIMEOUT)s) ==="
	mkdir -p "$(WRITEUP_DIR)"
	CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 \
	timeout $(WRITEUP_TIMEOUT) claude -p \
		"/generating-writeup $$(notdir $(WRITEUP_DIR)) IEEE -- Use agent teams for parallel chapter creation. Target: $(WRITEUP_DIR)" \
		--output-format stream-json --verbose \
		$$(if [ -n "$(CC_MODEL)" ]; then echo "--model $(CC_MODEL)"; fi) \
		> "$(WRITEUP_DIR)/generate.jsonl" 2>&1 \
		|| { EXIT_CODE=$$?; [ $$EXIT_CODE -eq 124 ] && echo "Content generation timed out after $(WRITEUP_TIMEOUT)s"; exit $$EXIT_CODE; }
	echo "=== Content generation complete. Output: $(WRITEUP_DIR)/generate.jsonl ==="


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
