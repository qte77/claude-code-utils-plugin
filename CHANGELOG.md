<!-- markdownlint-disable MD024 no-duplicate-heading -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Types of changes**: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`

## [Unreleased]

### Added

- **market-research**: New plugin with 8 skills — GTM pipeline with teams mode parallel dispatch, 2x2 strategy matrix, contradiction analysis, slide deck generation
- **python-dev**: Scaffold adapter for Ralph loop (`scaffold/adapter.sh`, project templates, GHA workflows)
- **embedded-dev**: Scaffold adapter with `find -print0 | xargs -0` safe filenames
- **cc-meta**: `synthesizing-cc-bigpicture` skill — project filter param (`[project-name] [time-range] [output-path]`), usage examples
- **cc-meta**: Auto-resolve output path — project-filtered runs write to `<project>/docs/bigpicture.md`, unfiltered to `~/.claude/bigpicture.md`
- **cc-meta**: Project-Arching TODOs & DONEs output section (from roadmap.md, CHANGELOG.md, AGENT_REQUESTS.md)
- **cc-meta**: `stats-cache.json` and `history.jsonl` as data sources for activity trajectory and session discovery
- **cc-meta**: Team inbox parsing (`teams/*/inboxes/*.json`) and subagent transcript paths
- `examples/memory/`: MEMORY.md and claude-cowork-api.md example templates
- `CODEOWNERS`: skill file ownership for content protection
- `scaffolds.json`: scaffold registry for python-dev and embedded-dev
- CI: `check-skill-integrity.yaml` + `compute-skill-hashes.sh` for content-hash skill protection
- CI: `research-monitor` GHA for tracking upstream CC changes (#19)
- Root README: cc-meta and market-research rows in Plugins table, plugin count 12 → 13, skill count 22 → 31

### Fixed

- **cc-meta**: CC Data Sources tree — removed non-existent `sessions-index.json`, `session-memory/`, `todos/`; fixed teams structure (`config.json` + `inboxes/` not flat `.json`); added `activeForm`/`owner` task fields
- **cc-meta**: Workflow steps use real data sources (`history.jsonl`, `stats-cache.json`, team inboxes, project docs) instead of non-existent ones
- **cc-meta**: `cc-entry-types.md` reference rewritten with accurate schemas and examples
- **cc-meta**: Frontmatter aligned to agentskills.io conventions (`argument-hint` kebab-case, `Target` not `Query`)
- **cc-meta**: Project filter now applies to global sources (plans, tasks, teams) — plans filtered by content grep, tasks/teams by session allowlist correlation. Previously these leaked unfiltered data from all projects.
- Removed duplicate hooks manifest references from 4 plugins (#16)
- **embedded-dev**: `find -print0 | xargs -0` for safe filenames in scaffold adapter

### Changed

- **cc-meta**: Plugin version 1.0.0 → 1.1.0
- **embedded-dev**: Plugin version 1.0.1 → 1.2.0 (scaffold adapter + hooks/settings)
- All plugins: stability metadata added to plugin.json via version bumps
- **commit-helper**: Synced SKILL.md with latest conventions (#19)
- Renamed `claude-code-research` references to `coding-agents-research` (#21)

## [3.0.0] - 2026-03-01

### Added

- **embedded-dev**: New plugin with `auditing-pcb-design`, `checking-compliance`, `implementing-firmware`, and `tracing-requirements` skills
- **docs-generator**: `generating-tech-spec` and `generating-report` skills
- **website-audit**: WCAG 2.1 AA quick-reference checklist, Further Reading links, demo section
- **docs-generator**: Bundled pandoc toolchain (Makefile, run-pandoc.sh, setup-pdf-converter.sh), IEEE/APA/Chicago CSL styles, SessionStart prerequisite hook, `project-report-IMRaD` and `technical-doc` templates
- **mas-design**: MITRE ATLAS, NIST AI RMF, ISO 42001/23894 integration with unified cross-framework threat mapping
- AI security governance frameworks analysis (`docs/analysis/`)
- `.gitignore`

### Changed

- All 21 skills: `allowed-tools` moved from top-level frontmatter to `metadata.allowed-tools` (comma-separated)
- Marketplace and README updated for new plugins and skills
- **docs-generator**: Markdown writeups are core output; PDF export via pandoc is optional
- **docs-generator**: Single `template.md` replaced with `templates/project-report-IMRaD/` and `templates/technical-doc/`
- **docs-generator**: Templates restructured, redundant reference removed
- **mas-design**: Plugin description, keywords, and demo updated to reflect all four frameworks

### Removed

- **docs-generator**: `template.md` (replaced by multi-file templates), `references/pandoc-setup.md` (covered by Makefile help targets)

## [2.0.0] - 2026-03-01

### Added

- README.md for 7 plugins, PR template, `.gitmessage` in commit-helper references
- `ralph` plugin with `generating-prd-json-from-prd-md` and `generating-interactive-userstory-md` skills (extracted from docs-generator)
- Hooks declaration in plugin.json for python-dev, workspace-setup, workspace-sandbox
- CodeQL (auto lang detection) and MkDocs Material (pinned `<2.0`) GitHub Actions workflows
- `mkdocs.yml` with nav for all plugins, analysis docs, and changelog
- Design docs: stop hook session summaries, plugin enhancement analysis
- `make test_install` covers all 10 plugins with broken symlink check

### Changed

- All plugins standalone-installable (symlinks replaced with real copies, DRY via `make sync`)
- `docs-generator` narrowed to writeup-only (Ralph skills extracted to `ralph` plugin)
- Marketplace updated to 10 plugins
- workspace-sandbox owns sandbox-specific settings, workspace-setup owns base settings

### Removed

- `docs/best-practices/`, `plugins/_shared/scripts/deploy-references.sh`, mas-design hooks

## [1.0.0] - 2026-03-01

### Added

- Workspace-sandbox plugin for hardened settings
- Commit template and file permissions config
- Initial Claude Code plugin marketplace with python-dev and workspace plugins
- Core principles and context management rules
- LEARNINGS.md and README badges
- CHANGELOG.md

### Fixed

- Plugin structure: workspace config, rules migration (#2)
- Duplicate rules in top-level rules/ directory (#3)
- Branding generalization, workspace plugin consolidation, python-dev hook (#4)
- Relative paths for plugin source fields in marketplace (#5)
- Required top-level `hooks` key in hooks.json (#6)
- Statusline symlink replaced with actual file
- CodeFactor badge URL

### Changed

- README streamlined with actual repo URL and concise layout
