<!-- markdownlint-disable MD033 -->

# qte77-claude-code-utils

Claude Code plugin marketplace — 25 plugins, 60 skills, 2 agents from production workflows.

[![License](https://img.shields.io/badge/license-Apache--2.0-58f4c2.svg)](LICENSE)
![Version](https://img.shields.io/badge/version-3.3.0-58f4c2.svg)
[![CodeQL](https://github.com/qte77/claude-code-utils-plugin/actions/workflows/codeql.yaml/badge.svg)](https://github.com/qte77/claude-code-utils-plugin/actions/workflows/codeql.yaml)
[![CodeFactor](https://www.codefactor.io/repository/github/qte77/claude-code-utils-plugin/badge/main)](https://www.codefactor.io/repository/github/qte77/claude-code-utils-plugin/overview/main)

## Install

```bash
claude plugin marketplace add qte77/claude-code-utils
claude plugin install workspace-setup@qte77-claude-code-utils
claude plugin install python-dev@qte77-claude-code-utils
```

<details>

<summary><strong>
  Full Setup
</strong></summary>

```bash
# 1. Add the marketplace
claude plugin marketplace add qte77/claude-code-utils-plugin

# 2. Install all plugins (pick ONE workspace plugin)
claude plugin install python-dev@qte77-claude-code-utils
claude plugin install rust-dev@qte77-claude-code-utils
claude plugin install go-dev@qte77-claude-code-utils
claude plugin install typescript-dev@qte77-claude-code-utils
claude plugin install cpp-desktop@qte77-claude-code-utils
claude plugin install tdd-core@qte77-claude-code-utils
claude plugin install commit-helper@qte77-claude-code-utils
claude plugin install codebase-tools@qte77-claude-code-utils
claude plugin install planning@qte77-claude-code-utils
claude plugin install backend-design@qte77-claude-code-utils
claude plugin install mas-design@qte77-claude-code-utils
claude plugin install security-audit@qte77-claude-code-utils
claude plugin install cc-meta@qte77-claude-code-utils
claude plugin install market-research@qte77-claude-code-utils
claude plugin install docs-generator@qte77-claude-code-utils
claude plugin install docs-governance@qte77-claude-code-utils
claude plugin install ralph@qte77-claude-code-utils
claude plugin install embedded-dev@qte77-claude-code-utils
claude plugin install gha-dev@qte77-claude-code-utils
claude plugin install makefile-core@qte77-claude-code-utils
claude plugin install rag-core@qte77-claude-code-utils
claude plugin install workspace-setup@qte77-claude-code-utils    # OR workspace-sandbox

# 3. Verify
claude plugin list
```

</details>

## Plugins

| Plugin | Skills / Agents | Purpose |
| -------- | -------- | --------- |
| **python-dev** | `implementing-python` `testing-python` `reviewing-code` | Python TDD, implementation, code review + uv permissions hook |
| **rust-dev** | `implementing-rust` `testing-rust` `reviewing-rust` | Rust implementation, testing, code review + cargo permissions hook |
| **go-dev** | `implementing-go` `testing-go` `reviewing-go` | Go implementation, testing, code review + go tool permissions hook |
| **typescript-dev** | `implementing-typescript` `testing-typescript` `reviewing-typescript` | TypeScript implementation, testing, code review + npm/vitest permissions hook |
| **cpp-desktop** | `implementing-cpp` `reviewing-cpp` `analyzing-cpp-codebase` | C++ desktop GUI development (wxWidgets, GTK, Qt) |
| **tdd-core** | `testing-tdd` | Language-agnostic TDD methodology (Red-Green-Refactor, AAA) |
| **commit-helper** | `committing-staged-with-message` `creating-pr-from-branch` | Conventional commits + PR creation with approval workflow |
| **codebase-tools** | `researching-codebase` `hardening-codebase` `build-error-resolver` (agent) | Codebase research, 9-phase quality hardening (architecture, docs, 4-agent review), build error resolution |
| **planning** | `planner` (agent) | Feature/refactor planning with phased steps, dependencies, risks |
| **backend-design** | `designing-backend` | System architecture and API design |
| **mas-design** | `designing-mas-plugins` `securing-mas` | Multi-agent plugin design + OWASP MAESTRO security |
| **security-audit** | `auditing-code-security` `detecting-secrets` `scanning-dependencies` | OWASP Top 10, secrets detection, dependency scanning |
| **cc-meta** | `synthesizing-cc-bigpicture` `compacting-context` `summarizing-session-end` `distilling-plan-learnings` `handing-off-session` `orchestrating-parallel-workers` `persisting-bigpicture-learnings` `mining-session-patterns` | Cross-project synthesis, context compaction, session intelligence |
| **market-research** | `analyzing-source-project` `researching-industry-landscape` `researching-market` `validating-product-market-fit` `developing-gtm-strategy` `analyzing-contradictions` `synthesizing-research` `generating-slide-deck` | GTM pipeline with teams mode, 2x2 strategy matrix |
| **docs-generator** | `generating-writeup` `generating-tech-spec` `generating-report` | Writeups, tech specs (ADR/RFC), reports with pandoc PDF |
| **docs-governance** | `enforcing-doc-hierarchy` `maintaining-agents-md` | Documentation hierarchy audit + agent governance |
| **ralph** | `generating-prd-json-from-prd-md` `generating-interactive-userstory-md` `generating-prd-md-from-userstory-md` | PRD pipeline for the Ralph loop |
| **embedded-dev** | `checking-compliance` `implementing-firmware` `tracing-requirements` `auditing-pcb-design` | CE/FCC compliance, ESP-IDF/PlatformIO, KiCad PCB audit |
| **gha-dev** | `creating-gha` | GitHub Actions creation and Marketplace publishing |
| **makefile-core** | `creating-makefile` | Makefile scaffolding, linting, and conventions |
| **rag-core** | `implementing-document-indexing` | Heading-boundary chunking, FAISS, PageIndex hybrid retrieval |
| **workspace-setup** | — | Deploys rules, statusline, governance, base settings via SessionStart |
| **workspace-sandbox** | — | Deploys rules, statusline, sandbox settings via SessionStart |
| **cc-voice** (external) | — | E2E voice — TTS via PTY proxy, STT planned ([prototype](https://github.com/qte77/cc-voice-plugin-prototype)) |

Skills activate automatically based on task context.

> **Workspace plugins are mutually exclusive** — install `workspace-setup` (lightweight defaults) **or** `workspace-sandbox` (hardened permissions + bwrap .gitignore), not both. Both use copy-if-not-exists so the first installed wins.

## Team Setup

Add to `.claude/settings.json` so teammates get marketplace access:

```json
{
  "extraKnownMarketplaces": {
    "qte77-claude-code-utils": {
      "source": { "source": "github", "repo": "qte77/claude-code-utils" }
    }
  }
}
```

Each member installs plugins individually with `claude plugin install`.

## Manage

```bash
claude plugin list                                          # List installed
claude plugin install python-dev@qte77-claude-code-utils    # Install
claude plugin update --all                                  # Update all
claude plugin remove python-dev@qte77-claude-code-utils     # Remove
```

## Development

```bash
make setup      # Install Claude Code + npm tools
make validate   # Validate plugin structure + JSON syntax
make sync       # Sync .claude/ SoT into plugin dirs
make check_sync # Verify all copies match SoT
make lint_md    # Lint markdown files
```

### Standalone install and DRY

Every plugin must work when installed individually via `claude plugin install`. No symlinks or references to files outside the plugin directory — `claude plugin install` may not preserve symlinks across platforms.

Shared references (e.g., `python-best-practices.md` in two skills, `workspace-sandbox` duplicating `workspace-setup`'s rules) use real copies. Use `make sync` and `make check_sync` to keep copies in sync.

## Resources

- [Claude Code Plugins](https://code.claude.com/docs/en/plugins) — Creating plugins
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference) — Plugin spec and components
- [Claude Code Memory](https://code.claude.com/docs/en/memory) — Rules and memory management
- [agentskills.io](https://agentskills.io/specification) — SKILL.md frontmatter spec

## License

Apache-2.0 — see [LICENSE](LICENSE).
