<!-- markdownlint-disable MD024 no-duplicate-heading -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Types of changes**: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`

## [Unreleased]

<!-- Entries below cover PRs since #37. Older entries at the top of each
     section were written pre-#37; newer entries are appended. Full backfill
     completed 2026-04-11. -->

### Added

<!-- Pre-#37 entries (preserved) -->

- **market-research**: New plugin with 8 skills — GTM pipeline with teams mode parallel dispatch, 2x2 strategy matrix, contradiction analysis, slide deck generation
- **python-dev**: Scaffold adapter for Ralph loop (`scaffold/adapter.sh`, project templates, GHA workflows)
- **embedded-dev**: Scaffold adapter with `find -print0 | xargs -0` safe filenames
- **commit-helper**: `creating-pr-from-branch` skill — branch analysis, PR template population, approval gate, Codespaces auth handling
- **docs-governance**: New plugin (1.0.0) with `enforcing-doc-hierarchy` and `maintaining-agents-md` skills
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

#### New plugins (#38-#112)

- **gha-dev**: New plugin with `creating-gha` skill for GitHub Actions Marketplace (#39); later added security settings, uv pattern, and updated action pins (#68)
- **tdd-core**: New plugin with language-agnostic TDD methodology — Red-Green-Refactor, Arrange-Act-Assert, testing strategy, shared across language plugins (#57)
- **rust-dev**: New plugin with `implementing-rust`, `reviewing-rust`, `testing-rust` skills; cargo tool permissions via SessionStart hook (#59)
- **go-dev**: New plugin with `implementing-go`, `reviewing-go`, `testing-go` skills; go tool permissions via SessionStart hook (#59)
- **cc-voice**: Submodule for E2E voice — TTS via PTY proxy (`/speak`), STT via Moonshine (`/listen` stub, functional). Originally added as `cc-tts` (#66), renamed to `cc-voice` (#67)
- **typescript-dev**: New plugin with `implementing-typescript`, `reviewing-typescript`, `testing-typescript` skills; npm/vitest permissions via SessionStart hook (#70)
- **makefile-core**: New plugin with `creating-makefile` skill — linter script + language-neutral Makefile conventions reference (#84)
- **security-audit**: New plugin with `auditing-code-security` (OWASP Top 10), `detecting-secrets`, `scanning-dependencies` skills (#87)
- **cpp-desktop**: New plugin with C++ desktop GUI skills — `implementing-cpp`, `reviewing-cpp`, `analyzing-cpp-codebase`; covers wxWidgets, GTK, Qt (#88)
- **simplify**: New plugin packaging the `simplifying-code` skill (post-review KISS/DRY/YAGNI enforcement) (#89)
- **rag-core**: New plugin with `implementing-document-indexing` skill — heading-boundary chunking, FAISS vector store, PageIndex hybrid retrieval (#100)
- **planning**: New plugin with cherry-picked `planner` agent from `affaan-m/everything-claude-code` (MIT); detailed feature/refactor implementation plans with phased steps, file-level specificity, dependencies, risks, success criteria (#111)

#### New skills in existing plugins (#38-#112)

- **docs-governance**: `maintaining-agents-md` frontmatter convention rule (#54)
- **docs-governance**: config-drift check and markdownlint integration in `enforcing-doc-hierarchy` (#82)
- **cc-meta**: `MEMORY.md` seed template + SessionStart hook for new-project bootstrapping (#69)
- **cc-meta**: `summarizing-session-end` skill + SessionEnd hook for automated session summaries (#91)
- **cc-meta**: `handing-off-session` skill — structured cross-session handoff notes in `.claude/handoffs/` (#92)
- **cc-meta**: `orchestrating-parallel-workers` skill — fan out tasks to parallel background agents with independent context windows (#93)
- **cc-meta**: `persisting-bigpicture-learnings` skill — dated snapshots in a learnings hub for compound learning (#96)
- **cc-meta**: `mining-session-patterns` skill — extract error-fix sequences, tool failure rates, and cost signals from session JSONL (#97)
- **cc-meta**: `subagent transcripts` as `synthesizing-cc-bigpicture` data source; workflow updated with dedicated bullet (#98)
- **cc-meta**: 4-tier progressive retrieval for `synthesizing-cc-bigpicture` (metadata → summaries → deep reads → full scan) in `references/progressive-retrieval.md` (#99)
- **codebase-tools**: `hardening-codebase` skill — 7-phase quality tightening workflow (audit → tighten → fix → tests → review → refactor → ship) with language-specific lint progressions and 3-agent review framework (#102)

#### New agents (#38-#112)

- **codebase-tools**: `build-error-resolver` agent — cherry-picked from [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) (MIT, 151k stars). Build and TypeScript error resolution specialist with minimal-diff philosophy (#104, #110)

#### New infrastructure (#38-#112)

- **workspace-setup / workspace-sandbox**: context7 MCP tool permissions via SessionStart hooks (#71)
- **workspace-sandbox**: qte77 marketplace registered in base settings (#95)
- **`.claude/rules/skill-authoring.md`**: Plugin-wide skill and agent authoring conventions — <150-line SKILL.md body cap (3.3× tighter than upstream 500-line soft cap), ≤250 char descriptions with front-loaded trigger keywords, `references/` subdir mandatory, content-hash regeneration for stable skills, plugin-scoped `agents/` layout (#109, #112)
- **docs**: `cc-entry-types.md` — tool results (detached outputs) JSONL entry type added (#53)
- **gha-dev**: `python-gha-patterns.md` reference — full Python composite action walkthrough based on gha-biorxiv-stats-action (#100)
- **gha-dev**: Scaffold split — explicit shell-based (`scripts/`) vs Python-based (`src/`) layouts in SKILL.md, with cross-reference to `python-gha-patterns.md`
- **gha-dev**: `companion-plugins.md` reference — maps companion plugins (tdd-core, python-dev, simplify, security-audit, commit-helper, makefile-core) by workflow phase, plus global rules cross-reference

### Changed

<!-- Pre-#37 entries (preserved) -->

- **cc-meta**: Simplify bigpicture skill (274→156 lines) — merge 3 reasoning axes to 2, extract project filtering to single section
- **commit-helper**: Simplify commit skill — drop mandatory diff stats/symbols, allow subject-only for small changes
- **cc-meta**: Plugin version 1.0.0 → 1.1.0 → 1.2.0 → 1.3.0
- **embedded-dev**: Plugin version 1.0.1 → 1.2.0 (scaffold adapter + hooks/settings)
- All plugins: stability metadata added to plugin.json via version bumps
- **commit-helper**: Synced SKILL.md with latest conventions (#19)
- Renamed `claude-code-research` references to `ai-agents-research` (#21)

#### Refactors and docs (#38-#112)

- **License**: Migrated to Apache-2.0 (#49)
- **docs**: Root README updated with current plugin count and table (#58)
- **docs**: Markdownlint enforcement rules added (#72)
- **docs-governance**: `enforcing-doc-hierarchy` skill rewritten — generic, KISS-oriented; no longer coupled to specific project layouts (#64)
- **docs-governance**: `enforcing-doc-hierarchy` description tightened from 295 → 179 chars per skill-authoring convention (#109)
- **workspace-setup / workspace-sandbox**: `statusline.sh` deduplicated via symlinks (#81)
- **workspace-setup / workspace-sandbox**: `statusline.sh` world-clock — opt-in via `CC_WORLD_CLOCK` env var (comma-separated IANA zones, east-to-west sunrise order recommended), renders on dedicated 4th line, invalid zones marked `?<name>`. workspace-setup 1.3.7 → 1.3.8, workspace-sandbox 1.3.6 → 1.3.7
- **workspace-setup / workspace-sandbox**: `statusline.sh` world-clock live toggle — `~/.claude/world-clock` file fallback for in-session changes (env var still wins; file picked up on next render, no CC restart needed). workspace-setup 1.3.8 → 1.3.9, workspace-sandbox 1.3.7 → 1.3.8
- **workspace-setup / workspace-sandbox**: `statusline.sh` world-clock custom labels — entries support optional `Zone=Label` syntax (e.g. `America/New_York=NYC`) for terser display; bare zones still default to the city name. workspace-setup 1.3.9 → 1.3.10, workspace-sandbox 1.3.8 → 1.3.9
- **workspace-setup / workspace-sandbox / codebase-tools / cc-meta**: Shared `.claude/rules/*.md` files (`core-principles`, `context-management`, `compound-learning`) converted from `cp`-enforced copies to symlinks pointing at the repo-root SoT — same pattern `statusline.sh` already uses. Eliminates 9 duplicate files; symlink invariants enforced by `make check_sync`. workspace-setup 1.3.10 → 1.3.11, workspace-sandbox 1.3.9 → 1.3.10, codebase-tools 1.4.2 → 1.4.3, cc-meta 1.15.1 → 1.15.2
- **python-dev**: Removed BDD, enforce TDD-only testing; reference file `bdd-best-practices.md` renamed to `bdd-best-practices-future-use.md` (parked) (#94)
- **cc-meta**: Plugin version 1.4.0 → 1.15.0 across seven successive feature merges (#91, #92, #93, #96, #97, #98, #99)
- **cc-meta**: `synthesizing-cc-bigpicture` SKILL.md 195 → 128 lines — extracted Two Reasoning Axes, CC Data Sources, Output Format into `references/reasoning-modes.md`, `references/cc-data-sources.md`, `references/output-template.md` (#108)
- **mas-design**: `securing-mas` SKILL.md 252 → 68 lines; `designing-mas-plugins` 219 → 83 lines — extracted 8 reference files total (MAESTRO checklist, plugin security checklist, common vulnerabilities, threat matrix template, security testing patterns, core principles with examples, plugin implementation template, plugin testing strategy). Plugin version 1.0.1 → 1.1.0 (#107)
- **codebase-tools**: Plugin version 1.2.0 → 1.3.0 — added agents/ subdir, description broadened to include build error resolution (#110)
- **Makefile**: `statusline.sh` added to sync targets (#60)
- **cc-voice**: Version synced to 0.4.0 in marketplace (#90)
- **`.claude/rules/skill-authoring.md`**: Agents convention section added — documents `plugins/<name>/agents/<agent-name>.md` layout, host-plugin selection, README `## Agents` section requirement, cherry-pick attribution template (#112)
- **`.claude/rules/core-principles.md`**: Tightened 73 → 55 lines — kept acronym expansions (KISS, DRY, AHA, YAGNI) and added failure-mode glosses where the name alone wasn't self-evident; folded "User-Centric Principles" into the intro; merged "Reuse and Extend" + "Resolve Ambiguity" into "Match existing patterns; ask before diverging"; preserved Consistency-and-Coherence, Rigor-and-Sufficiency, High-Impact-Quick-Wins, Clarity, Actionable-and-Concrete, Root-Cause-and-First-Principles, and Touch-only-task-related-code as named bullets. workspace-setup 1.3.11 → 1.3.12, workspace-sandbox 1.3.10 → 1.3.11.
- **`.claude/rules/skill-authoring.md`**: Resolved internal contradiction on `references/` requirement — adopted conditional reading (mandatory only when extraction is triggered by the 150-line cap), consistent with the SKILL.md body-size section.
- **market-research**: Front-loaded all 8 skill descriptions with action verbs (Assess/Map/Integrate/Score/Develop/Detect/Synthesize/Generate) per skill-authoring convention; phase labels moved to suffix so ordering info is preserved. Plugin version 1.0.1 → 1.0.2.
- **ralph**: Front-loaded `generating-interactive-userstory-md` description (verb-led "Build UserStory.md interactively..."). Plugin version 1.0.2 → 1.0.3.

### Fixed

<!-- Pre-#37 entries (preserved) -->

- **cc-meta**: CC Data Sources tree — removed non-existent `sessions-index.json`, `session-memory/`, `todos/`; fixed teams structure (`config.json` + `inboxes/` not flat `.json`); added `activeForm`/`owner` task fields
- **cc-meta**: Workflow steps use real data sources (`history.jsonl`, `stats-cache.json`, team inboxes, project docs) instead of non-existent ones
- **cc-meta**: `cc-entry-types.md` reference rewritten with accurate schemas and examples
- **cc-meta**: Frontmatter aligned to agentskills.io conventions (`argument-hint` kebab-case, `Target` not `Query`)
- **cc-meta**: Project filter now applies to global sources (plans, tasks, teams) — plans filtered by content grep, tasks/teams by session allowlist correlation. Previously these leaked unfiltered data from all projects.
- Removed duplicate hooks manifest references from 4 plugins (#16)
- **check-skill-integrity.yaml**: Add `permissions: contents: read` (CodeQL alert fix)
- **embedded-dev**: `find -print0 | xargs -0` for safe filenames in scaffold adapter

#### Fixes (#38-#112)

- **marketplace**: Use github source for `cc-voice` plugin (installable from external repo, not local path) (#80)
- **python-dev**: `testing-python/SKILL.md` content-hash drift from #94 merge — CI `verify-skill-hashes` would have blocked next PR; regenerated via `.github/scripts/compute-skill-hashes.sh --update` as part of #107

### Removed

- Stale analysis docs and compact plugin-dev reference (#62)
- `TODO.md` — completed 2026-03 phase plan (embedded-dev hooks + ralph `generating-prd-md-from-userstory-md` skill), `status: done` since 2026-03-13. Archived from repo root.

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
