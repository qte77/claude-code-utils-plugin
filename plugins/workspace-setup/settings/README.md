# Settings

Two settings templates are provided:

- **settings-base.json** — Lightweight defaults: statusline, context7 plugin, attribution. Deployed automatically by the SessionStart hook when `.claude/settings.json` is missing.
- **settings-sandbox.json** — Full sandbox config with permissions, env vars, and filesystem restrictions. Deployed automatically by `workspace-sandbox`.

## Usage

The hook deploys `settings-base.json` (or `settings-sandbox.json` if using `workspace-sandbox`) as `.claude/settings.json` only if no settings file exists (copy-if-not-exists).

Install **one** of the two workspace plugins — they are mutually exclusive:

```bash
# Base settings (lightweight defaults)
claude plugin install workspace-setup@qte77-claude-code-utils

# Sandbox settings (hardened permissions)
claude plugin install workspace-sandbox@qte77-claude-code-utils
```
