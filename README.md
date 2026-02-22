# claude-code-utils

A Claude Code plugin marketplace providing skills, rules, and scripts extracted from a production development workflow.

## Plugins

| Plugin | Skills | Description |
|--------|--------|-------------|
| **python-dev** | implementing-python, testing-python, reviewing-code | Python implementation, TDD/BDD testing, and structured code review |
| **commit-helper** | committing-staged-with-message | Conventional commit messages with GPG signing and approval workflow |
| **codebase-tools** | researching-codebase, compacting-context | Isolated codebase exploration and context window management (ACE-FCA) |
| **backend-design** | designing-backend | Backend system architecture and API design |
| **mas-design** | designing-mas-plugins, securing-mas | Multi-agent system plugin design and OWASP MAESTRO security |
| **website-audit** | researching-website-design, auditing-website-usability, auditing-website-accessibility | Design research, UX audit, and WCAG 2.1 AA accessibility audit |
| **docs-generator** | generating-writeup, generating-prd-json-from-prd-md, generating-interactive-userstory-md | Academic writeups with pandoc/citations, PRD conversion, user story builder |

## Installation

### Add the marketplace

```bash
# From GitHub
/plugin marketplace add your-org/claude-code-utils

# From a local clone
/plugin marketplace add ./path/to/claude-code-utils
```

### Install plugins

```bash
/plugin install python-dev@claude-code-utils
/plugin install commit-helper@claude-code-utils
/plugin install codebase-tools@claude-code-utils
/plugin install backend-design@claude-code-utils
/plugin install mas-design@claude-code-utils
/plugin install website-audit@claude-code-utils
/plugin install docs-generator@claude-code-utils
```

### Manage plugins

```bash
/plugin list                                    # List installed
/plugin update --all                            # Update all
/plugin remove python-dev@claude-code-utils     # Remove one
/plugin validate .                              # Validate structure
```

## Repository Structure

```
.claude-plugin/
  marketplace.json              # Marketplace catalog
.devcontainer/
  devcontainer.json             # Dev environment for plugin editing
plugins/
  python-dev/                   # Python implementation + testing + review
    .claude-plugin/plugin.json
    skills/
      implementing-python/SKILL.md
      testing-python/SKILL.md
      reviewing-code/SKILL.md
  commit-helper/                # Conventional commits with GPG
    .claude-plugin/plugin.json
    skills/
      committing-staged-with-message/SKILL.md
  codebase-tools/               # Research + context compaction
    .claude-plugin/plugin.json
    skills/
      researching-codebase/
        SKILL.md
        references/
          context-management.md
          core-principles.md
      compacting-context/
        SKILL.md
        references/
          context-management.md
  backend-design/               # Backend system architecture
    .claude-plugin/plugin.json
    skills/
      designing-backend/SKILL.md
  mas-design/                   # Multi-agent system design + MAESTRO security
    .claude-plugin/plugin.json
    skills/
      designing-mas-plugins/SKILL.md
      securing-mas/SKILL.md
  website-audit/                # Design research + UX + accessibility
    .claude-plugin/plugin.json
    skills/
      researching-website-design/SKILL.md
      auditing-website-usability/SKILL.md
      auditing-website-accessibility/SKILL.md
  docs-generator/               # Writeups + PRD + user stories
    .claude-plugin/plugin.json
    skills/
      generating-writeup/SKILL.md
      generating-writeup/template.md
      generating-prd-json-from-prd-md/SKILL.md
      generating-interactive-userstory-md/SKILL.md
_examples/                      # Reference plugins and non-plugin components
  commit-helper/
  code-review/
  test-runner/
  docs-helper/
```

## Team Distribution

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-utils": {
      "source": {
        "source": "github",
        "repo": "your-org/claude-code-utils"
      }
    }
  }
}
```

## Development

Open in the devcontainer for a ready-made plugin editing environment:

```bash
code --folder-uri vscode-remote://dev-container+$(echo -n "$PWD/.claude-plugins-repo" | xxd -p)
```

Or open `.claude-plugins-repo/` as a folder in VS Code and reopen in container.

See `_examples/` for simple plugin templates to use as starting points.

## License

MIT -- see [LICENSE](LICENSE).
