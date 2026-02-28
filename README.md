# qte77-claude-code-utils

Claude Code plugin marketplace — 8 plugins, 15 skills from production workflows.

## Install

```bash
/plugin marketplace add qte77/claude-code-utils
/plugin install workspace-setup@qte77-claude-code-utils
/plugin install python-dev@qte77-claude-code-utils
```

<details>

<summary><strong>
  Full Setup
</strong></summary>

```bash
# 1. Add the marketplace
claude plugin marketplace add qte77/claude-code-utils-plugin

# 2. Install all 8 plugins
claude plugin install python-dev@qte77-claude-code-utils
claude plugin install commit-helper@qte77-claude-code-utils
claude plugin install codebase-tools@qte77-claude-code-utils
claude plugin install backend-design@qte77-claude-code-utils
claude plugin install mas-design@qte77-claude-code-utils
claude plugin install website-audit@qte77-claude-code-utils
claude plugin install docs-generator@qte77-claude-code-utils
claude plugin install workspace-setup@qte77-claude-code-utils

# 3. Verify
claude plugin list
```

</details>

## Plugins

| Plugin | Skills | Purpose |
| -------- | -------- | --------- |
| **python-dev** | `implementing-python` `testing-python` `reviewing-code` | Python TDD, implementation, code review + uv permissions hook |
| **commit-helper** | `committing-staged-with-message` | Conventional commits with GPG signing |
| **codebase-tools** | `researching-codebase` `compacting-context` | Isolated code exploration, context compression |
| **backend-design** | `designing-backend` | System architecture and API design |
| **mas-design** | `designing-mas-plugins` `securing-mas` | Multi-agent plugin design + OWASP MAESTRO |
| **website-audit** | `researching-website-design` `auditing-website-usability` `auditing-website-accessibility` | Design research, UX audit, WCAG 2.1 AA |
| **docs-generator** | `generating-writeup` `generating-prd-json-from-prd-md` `generating-interactive-userstory-md` | Academic writeups, PRD-to-JSON, user stories |
| **workspace-setup** | — | Deploys rules, statusline, and base settings via SessionStart hook |

Skills activate automatically based on task context.

> **Project-specific settings:** The `workspace-setup` hook deploys defaults only if files are missing — existing `.claude/settings.json` is never overwritten. Override or extend via `.claude/settings.json` or `.claude/settings.local.json`. A `settings-sandbox.json` template is included for hardened setups.

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

Each member installs plugins individually with `/plugin install`.

## Manage

```bash
/plugin list                                 # List installed
/plugin install python-dev@qte77-claude-code-utils # Install
/plugin update --all                         # Update all
/plugin remove python-dev@qte77-claude-code-utils  # Remove
```

## Development

```bash
make setup      # Install Claude Code + npm tools
make validate   # Validate plugin structure + JSON syntax
make sync       # Sync .claude/ SoT into plugin dirs
make check_sync # Verify all copies match SoT
make lint_md    # Lint markdown files
```

## Resources

- [Claude Code Plugins](https://code.claude.com/docs/en/plugins) — Creating plugins
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference) — Plugin spec and components
- [Claude Code Memory](https://code.claude.com/docs/en/memory) — Rules and memory management
- [agentskills.io](https://agentskills.io/specification) — SKILL.md frontmatter spec

## License

MIT — see [LICENSE](LICENSE).
