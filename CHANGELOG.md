<!-- markdownlint-disable MD024 no-duplicate-heading -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Types of changes**: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`

## [Unreleased]

### Added

- README.md for 7 plugins (python-dev, commit-helper, codebase-tools, backend-design, mas-design, website-audit, docs-generator)
- Hooks declaration in plugin.json for python-dev, workspace-setup, workspace-sandbox
- `.gitmessage` bundled in commit-helper skill references
- Stop hook session summaries design doc (`docs/analysis/CC-stop-hook-session-summaries.md`)
- CC plugin development reference guide (`docs/analysis/CC-plugin-enhancement-analysis.md`)

### Changed

- All plugins are now standalone-installable (no cross-boundary symlinks or repo-root references)
- Skill references use real file copies instead of symlinks
- workspace-sandbox uses real copies of rules and scripts (was symlinks to workspace-setup)
- Deduplicated workspace plugins: workspace-sandbox owns sandbox-specific settings (.gitignore, settings-sandbox.json), workspace-setup owns base settings (settings-base.json)
- Documented standalone install DRY trade-offs in README

### Removed

- `docs/best-practices/` directory (source of truth moved into plugin skill references)
- `plugins/_shared/scripts/deploy-references.sh` (no longer needed)
- mas-design SessionStart hook (only deployed references, now empty)
- Best-practices deploy from python-dev setup script

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
