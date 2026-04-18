# Companion Plugins

Plugins from `qte77-claude-code-utils` that complement GHA development.
Install with `claude plugin install <name>@qte77-claude-code-utils`.

## By workflow phase

### Implementation

| Plugin | Skill | When to use |
|--------|-------|-------------|
| **python-dev** | `implementing-python` | Python-based actions (`src/app.py`) |
| **python-dev** | `reviewing-code` | Code review before PR |
| **makefile-core** | `creating-makefile` | Adding a Makefile for local dev tasks (lint, test, bump) |

### Testing

| Plugin | Skill | When to use |
|--------|-------|-------------|
| **tdd-core** | `testing-tdd` | Red-Green-Refactor methodology — applies to both BATS and pytest |
| **python-dev** | `testing-python` | pytest for Python-based actions |

### Quality & Security

| Plugin | Skill | When to use |
|--------|-------|-------------|
| **simplify** | `simplifying-code` | Post-implementation KISS/DRY/YAGNI review |
| **security-audit** | `auditing-code-security` | OWASP Top 10 checks on action code |
| **security-audit** | `scanning-dependencies` | Audit dependencies in pyproject.toml / uv.lock |
| **security-audit** | `detecting-secrets` | Ensure no tokens or credentials in action source |

### Commit & Release

| Plugin | Skill | When to use |
|--------|-------|-------------|
| **commit-helper** | `committing-staged-with-message` | Conventional commit messages |
| **commit-helper** | `creating-pr-from-branch` | PR creation with approval gate |

## Typical install set

**Shell-based action** (minimal):

```bash
claude plugin install tdd-core@qte77-claude-code-utils
claude plugin install commit-helper@qte77-claude-code-utils
claude plugin install simplify@qte77-claude-code-utils
```

**Python-based action** (full):

```bash
claude plugin install python-dev@qte77-claude-code-utils
claude plugin install tdd-core@qte77-claude-code-utils
claude plugin install commit-helper@qte77-claude-code-utils
claude plugin install simplify@qte77-claude-code-utils
claude plugin install security-audit@qte77-claude-code-utils
```

## Global rules

These `.claude/rules/` files (from workspace-setup plugin) apply across all GHA work:

- **`core-principles.md`** — KISS, DRY, YAGNI decision framework
- **`compound-learning.md`** — Promotion path for recurring patterns (inline → AGENT_LEARNINGS → rules → skills)
- **`context-management.md`** — Context window utilization targets and compaction triggers
