# workspace-setup

Deploys workspace rules, statusline script, and base settings via SessionStart hook.

## Deployed files

- **rules/*.md** → `.claude/rules/` — core principles, context management
- **scripts/statusline.sh** → `.claude/scripts/` — status line display
- **settings/settings-base.json** → `.claude/settings.json` — lightweight defaults (statusline, context7, attribution)

All files use copy-if-not-exists (won't overwrite).

## Install

```bash
claude plugin install workspace-setup@qte77-claude-code-utils
```

For sandbox settings (hardened permissions), use `workspace-sandbox` instead.
