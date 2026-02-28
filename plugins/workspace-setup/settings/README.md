# Settings

Two settings templates are provided:

- **settings-base.json** — Lightweight defaults: statusline, context7 plugin, attribution. Deployed automatically by the SessionStart hook when `.claude/settings.json` is missing.
- **settings-sandbox.json** — Full sandbox config with permissions, env vars, and filesystem restrictions. Copy manually for hardened workspaces.

## Usage

The hook deploys `settings-base.json` as `.claude/settings.json` only if no settings file exists (copy-if-not-exists). To use the sandbox template instead:

```bash
cp plugins/workspace-setup/settings/settings-sandbox.json .claude/settings.json
```
