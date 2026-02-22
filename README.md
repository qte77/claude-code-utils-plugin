# claude-code-utils

Claude Code plugin marketplace — 7 plugins, 15 skills extracted from production workflows.

## Quick Start

```bash
# Add marketplace
/plugin marketplace add qte77/claude-code-utils

# Install what you need
/plugin install python-dev@claude-code-utils
/plugin install codebase-tools@claude-code-utils
```

## Plugins

| Plugin | Skills | What it does |
|--------|--------|--------------|
| **python-dev** | `implementing-python` `testing-python` `reviewing-code` | Write, test (TDD/BDD), and review Python code |
| **commit-helper** | `committing-staged-with-message` | Conventional commits with GPG signing |
| **codebase-tools** | `researching-codebase` `compacting-context` | Explore code in isolation, compress context (ACE-FCA) |
| **backend-design** | `designing-backend` | System architecture and API design |
| **mas-design** | `designing-mas-plugins` `securing-mas` | Multi-agent plugin design + OWASP MAESTRO security |
| **website-audit** | `researching-website-design` `auditing-website-usability` `auditing-website-accessibility` | Design analysis, UX audit, WCAG 2.1 AA audit |
| **docs-generator** | `generating-writeup` `generating-prd-json-from-prd-md` `generating-interactive-userstory-md` | Academic writeups, PRD-to-JSON, interactive user stories |

## Install / Manage

```bash
/plugin list                                # List installed
/plugin install python-dev@claude-code-utils # Install one
/plugin update --all                        # Update all
/plugin remove python-dev@claude-code-utils # Remove one
```

## Team Setup

Add to `.claude/settings.json` so all team members get access:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-utils": {
      "source": { "source": "github", "repo": "qte77/claude-code-utils" }
    }
  }
}
```

## TODO

- [ ] **Plugin rules support**: `rules/` is not a recognized plugin component. Once supported, convert `codebase-tools/skills/*/references/` (core-principles, context-management) into always-active rules. Current workaround: agent system prompt (`agents/` + `settings.json`) or `SessionStart` hook.

## Development

Open in the devcontainer for a ready-made editing environment, or run:

```bash
make setup     # Install Claude Code + npm tools
make validate  # Validate plugin structure + JSON syntax
make lint_md   # Lint markdown files
```

## Resources

- [Claude Code Plugins](https://code.claude.com/docs/en/plugins) — Creating plugins
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference) — Plugin spec and component types
- [Claude Code Memory](https://code.claude.com/docs/en/memory) — Rules, CLAUDE.md, and memory management
- [agentskills.io Specification](https://agentskills.io/specification) — SKILL.md frontmatter spec

## License

MIT — see [LICENSE](LICENSE).
