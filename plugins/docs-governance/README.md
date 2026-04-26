# docs-governance

Audit and maintain documentation hierarchy and agent governance files.

## Skills

- **enforcing-doc-hierarchy** — Audit docs against authority chains, detect broken refs, duplicates, scope creep, and chain breaks
- **maintaining-agents-md** — Keep AGENTS.md, CONTRIBUTING.md, AGENT_LEARNINGS.md, and AGENT_REQUESTS.md in sync with codebase

## Templates

`templates/` ships skeleton governance docs for new projects:

- `AGENTS.md` — agent behavioral rules and decision framework
- `AGENT_LEARNINGS.md` — pattern discovery log (with promotion path)
- `AGENT_REQUESTS.md` — escalations to humans
- `CONTRIBUTING.md` — technical workflows and command reference

**Pattern: copy on init, diverge freely.** Templates provide a consistent
structural skeleton; project-specific content is filled in per repo. After
copying, the `maintaining-agents-md` skill keeps structure aligned without
forcing uniform content.

```bash
# Copy skeleton into a new project
cp ~/.claude/plugins/cache/qte77/claude-code-plugins/plugins/docs-governance/templates/*.md ./
```

## Install

```bash
claude plugin install docs-governance@qte77-claude-code-plugins
```
