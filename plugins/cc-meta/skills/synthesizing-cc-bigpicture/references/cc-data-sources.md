# Claude Code Data Sources for Big-Picture Synthesis

Full layout of the `~/.claude/` directory as consumed by `synthesizing-cc-bigpicture`. For the JSONL entry type taxonomy (fields inside each file), see `cc-entry-types.md`.

```text
~/.claude/
├── history.jsonl                    # Global prompt log (display, timestamp, project, sessionId)
├── stats-cache.json                 # Daily aggregates (messageCount, sessionCount, toolCallCount)
├── projects/<encoded-path>/
│   ├── memory/MEMORY.md             # Per-project persistent knowledge
│   ├── <session-uuid>.jsonl         # Full transcripts (metadata-scan only)
│   ├── <session-uuid>/subagents/    # Subagent transcripts
│   └── subagents/*.jsonl            # Subagent session transcripts
├── session-summaries/*.md           # Per-session distilled summaries
├── plans/*.md                       # Plan mode files
├── tasks/<session-or-team-name>/    # Tasks (*.json, skip .lock/.highwatermark)
└── teams/<team-name>/               # config.json + inboxes/<member>.json
```

**Critical:** Never bulk-read full `.jsonl` transcripts. Use `history.jsonl` for discovery and first+last 5 lines of each session transcript for metadata only.
