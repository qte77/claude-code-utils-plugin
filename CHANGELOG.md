<!-- markdownlint-disable MD024 no-duplicate-heading -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Types of changes**: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`

## [Unreleased]

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
