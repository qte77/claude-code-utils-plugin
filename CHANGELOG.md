<!-- markdownlint-disable MD024 no-duplicate-heading -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Types of changes**: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`

## [Unreleased]

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
