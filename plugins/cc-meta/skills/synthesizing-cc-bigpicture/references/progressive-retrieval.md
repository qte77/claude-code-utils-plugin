# Progressive Retrieval Tiers

Escalate through tiers — stop as soon as the current tier's data answers every
output template section with concrete evidence (not guesses). Otherwise escalate
to the next tier.

## Tier 1 — Fast metadata (always, <5s)

- `stats-cache.json`: token counts, session durations, tool usage
- `history.jsonl`: recent command history (last 50 entries)
- `.claude/memory/MEMORY.md`: memory index
- **Cost**: ~500 tokens
- **Sufficient for**: activity summaries, tool usage stats

## Tier 2 — Structured summaries (if Tier 1 insufficient)

- `session-summaries/*.md`: distilled session notes
- `plans/*.md`: active/recent plans (filter by mtime)
- `AGENT_LEARNINGS.md`, `AGENTS.md`: governance state
- **Cost**: ~2-5K tokens
- **Sufficient for**: focus areas, trajectory, active work streams

## Tier 3 — Targeted deep reads (if Tier 2 insufficient)

- Session JSONL: first 5 + last 5 lines per file (max 10 files by mtime)
- Subagent transcripts: first 5 + last 5 lines (max 10 files)
- Git log: recent commits for changed-file context
- **Cost**: ~5-15K tokens
- **Sufficient for**: detailed synthesis, cross-project patterns

## Tier 4 — Full scan (never in normal flow)

- Complete JSONL transcript reads
- Only if explicitly requested by user with `--deep` flag
- **Cost**: unbounded — guard with context budget check

## Escalation Rule

After collecting a tier's data, check the output template (Reasoning Mode Summary,
Active Work Streams, Cross-Project Connections, Active Plans, TODOs & DONEs,
Blockers & Stale Items, Mode Transitions Needed). If every section can be filled
with concrete evidence from the current tier, stop. Otherwise escalate to the
next tier.
