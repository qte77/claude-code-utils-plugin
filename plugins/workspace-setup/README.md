# workspace-setup

Deploys workspace rules, statusline, governance files, and base settings via SessionStart hook.

Self-contained — all CC-specific files bundled in the plugin, no external dependencies.

## Deployed files

- **rules/*.md** → `.claude/rules/` — core principles, context management
- **scripts/statusline.sh** → `.claude/scripts/` — status line display. World clock off by default. Two ways to opt in: (1) **persistent** — set `CC_WORLD_CLOCK="Asia/Tokyo,Europe/Paris,Europe/London,UTC,America/New_York,America/Los_Angeles"` in your shell rc (needs CC restart to change); (2) **live toggle** — write the same comma-separated zone list to `~/.claude/world-clock` (next prompt render picks it up; `rm` the file to turn off). Env var wins over file. Use east-to-west / sunrise order or any IANA zones you prefer. Zones render on a dedicated line below the main statusline; invalid zones show as `?<name>`. See the comment block at the top of `.claude/scripts/statusline.sh` for the curated shortlist and usage notes.
- **settings/settings-base.json** → `.claude/settings.json` — lightweight defaults (statusline, context7, attribution)
- **governance/AGENTS.md** → `AGENTS.md` — agent behavioral rules and decision framework
- **governance/AGENT_LEARNINGS.md** → `AGENT_LEARNINGS.md` — pattern discovery template
- **governance/AGENT_REQUESTS.md** → `AGENT_REQUESTS.md` — human escalation protocol

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

## Install

```bash
claude plugin install workspace-setup@qte77-claude-code-plugins
```

For sandbox settings, use `workspace-sandbox` instead.
