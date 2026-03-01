---
topic: claude-code-plugin-schemas
updated: 2026-03-01
---

# Plugin Schema Learnings

## marketplace.json

- `source` must be a relative path (`"./plugins/python-dev"`), not a bare name (`"python-dev"`)
- `metadata.pluginRoot` is not a valid field — remove it
- Marketplace name is used in install commands: `plugin-name@marketplace-name`

## hooks.json

- Must wrap events under a top-level `"hooks"` key: `{"hooks": {"SessionStart": [...]}}`
- Without wrapper: `"expected record, received undefined"` at path `["hooks"]`

## Plugin cache

- Installed plugins are cached at `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/`
- Cache is NOT auto-refreshed on source changes — must uninstall + reinstall
- `claude plugin update` may not refresh hooks; nuclear option: `rm -rf ~/.claude/plugins/cache/<marketplace>`
