# workspace-sandbox

Deploys workspace rules, statusline script, sandbox settings, and .gitignore via SessionStart hook.

## Deployed files

- **rules/*.md** → `.claude/rules/` — core principles, context management
- **scripts/statusline.sh** → `.claude/scripts/` — status line display
- **settings/.gitignore** → `.gitignore` — hides bwrap phantom files from git status
- **settings/settings-sandbox.json** → `.claude/settings.json` — hardened permissions, env vars, filesystem restrictions

All files use copy-if-not-exists (won't overwrite).

## Install

```bash
claude plugin install workspace-sandbox@qte77-claude-code-utils
```

For lightweight defaults without sandbox, use `workspace-setup` instead.
