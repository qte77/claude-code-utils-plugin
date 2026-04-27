# workspace-sandbox

Deploys workspace rules, statusline script, and eased sandbox settings via SessionStart hook.

Uses the **hybrid approach**: network sandbox ON, filesystem relaxed for multi-repo
Codespace workflows. The container provides filesystem isolation; CC provides
network exfiltration protection.

## Deployed files

- **rules/*.md** → `.claude/rules/` — core principles, context management
- **scripts/statusline.sh** → `.claude/scripts/` — status line display. World clock off by default. Two ways to opt in: (1) **persistent** — set `CC_WORLD_CLOCK="Asia/Tokyo,Europe/Paris,Europe/London,UTC,America/New_York,America/Los_Angeles"` in your shell rc (needs CC restart to change); (2) **live toggle** — write the same comma-separated zone list to `~/.claude/world-clock` (next prompt render picks it up; `rm` the file to turn off). Env var wins over file. Use east-to-west / sunrise order or any IANA zones you prefer. Zones render on a dedicated line below the main statusline; invalid zones show as `?<name>`. See the comment block at the top of `.claude/scripts/statusline.sh` for the curated shortlist and usage notes.
- **settings/.gitignore** → `.gitignore` — hides bwrap phantom files from git status
- **settings/settings-sandbox.json** → `.claude/settings.json` — eased sandbox, permissions, env vars
- **governance/*.md** → `AGENTS.md`, `AGENT_LEARNINGS.md`, `AGENT_REQUESTS.md` — agent governance

All files use copy-if-not-exists (won't overwrite).

## read-once hook

PreToolUse hook that prevents redundant file re-reads within a session.
Saves ~2K tokens per blocked re-read (~40% reduction in typical workflows).

- **Mode**: warn (default) — allows read with advisory; set `READ_ONCE_MODE=deny` to block
- **TTL**: 1200s (20 min) — cache expires after this; set `READ_ONCE_TTL` to override
- **Diff mode**: set `READ_ONCE_DIFF=1` to show diffs instead of full re-reads for changed files
- **PostCompact**: cache clears automatically when CC compacts context
- **Partial reads**: offset/limit reads always pass through (never cached)
- **Disable**: set `READ_ONCE_DISABLED=1`

Based on [Bande-a-Bonnot/Boucle-framework](https://github.com/Bande-a-Bonnot/Boucle-framework) (MIT).

## Sandbox configuration

- `enableWeakerNestedSandbox: true` — works inside unprivileged Docker (Codespaces)
- `autoAllowBashIfSandboxed: true` — auto-approve sandboxed bash commands
- `allowUnsandboxedCommands: false` — no escape hatch
- `excludedCommands: ["docker *"]` — docker runs outside sandbox
- **Filesystem**: `/workspaces` (cross-repo writes), `.git`, `/tmp/claude-1000`
- **Network**: GitHub, npm, PyPI registries

## Install

```bash
claude plugin install workspace-sandbox@qte77-claude-code-plugins
```

For defaults without sandbox, use `workspace-setup` instead.
