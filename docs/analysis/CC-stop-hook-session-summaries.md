---
title: Stop Hook Session Summaries
purpose: Design doc for automated session summary generation using Claude Code hook events
created: 2026-03-01
---

## Problem

Session context is lost between Claude Code conversations. Developers restart sessions without a record of what was accomplished, what files were touched, or what decisions were made. A hook-triggered summary would preserve this knowledge automatically.

## Hook Events: Stop vs SessionEnd

| Event | Fires | Frequency | Use Case |
| ----- | ----- | --------- | -------- |
| **Stop** | After each Claude response | Many times per session | Iteration loops, per-response learning |
| **SessionEnd** | When the session closes | Once per session | Cleanup, final summaries |

**Stop** fires after every assistant turn — in a typical session that's dozens of invocations. Using Stop for session summaries means the hook runs on every response, generating incremental noise, consuming tokens, and risking timeout kills on longer summaries.

**SessionEnd** fires exactly once when the user exits. This is the natural point to generate a single, consolidated session summary.

## Prior Art: everything-claude-code

The [everything-claude-code](https://github.com/affaan-m/everything-claude-code) repository implements a continuous-learning pattern using Stop hooks for session learning. As of March 2026, this is classified as **experimental** — limited production validation, no established best practices for timeout tuning or output management.

Their approach: append learnings to a file on every Stop event. The risk is unbounded file growth and redundant entries when the same insight surfaces across multiple responses in one session.

## Proposed Design

### Hook Configuration

Use **SessionEnd** with a **prompt** hook that invokes the existing `compacting-context` skill:

```json
{
  "hooks": {
    "SessionEnd": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Run the compacting-context skill with name 'session-summary'. Append the output as a new ## Session block (with ISO-8601 timestamp) to .claude/session-summaries.md. Create the file if it doesn't exist. Do not overwrite existing content.",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

A `prompt`-type hook leverages the model's full context window — it has visibility into everything that happened during the session. This is critical because a shell script has no access to conversation history, only filesystem state. The compacting-context skill already knows how to distill verbose context into structured summaries; the SessionEnd hook simply triggers it at the right moment.

### Why compacting-context?

The skill already exists in the `codebase-tools` plugin with:

- **Proven template** — Trajectory, Key Files, Completed, Blockers, Findings
- **ACE-FCA principles** — Correct > Complete > Minimal noise
- **Quality checks** — no raw dumps, structured summaries only
- **Model awareness** — runs as a forked Explore agent with Sonnet, keeping cost low

Reusing it avoids duplicating summary logic and ensures session summaries follow the same structure developers already encounter during context compaction.

### Output Format

Append-only output to `.claude/session-summaries.md`:

```markdown
## Session: 2026-03-01T14:30:00Z

### Trajectory
<!-- Research status → Planning status → Implementation status -->

### Key Files
<!-- files touched with purpose -->

### Completed
<!-- done items -->

### Blockers
<!-- blocking issues (empty if none) -->

### Findings
<!-- key discoveries, distilled outputs from logs/JSON/tests -->
```

Each session appends a new `## Session:` block. The file grows monotonically — no overwrites, no deduplication logic.

## Trade-offs

| Concern | Stop | SessionEnd (recommended) |
| ------- | ---- | ------------------------ |
| **Frequency** | Every response (noisy) | Once per session (clean) |
| **Timeout risk** | High — competes with response latency | Moderate — 60s at shutdown |
| **Cost** | Tokens on every turn | One Sonnet call at exit |
| **Idempotency** | Must handle partial/duplicate writes | Single write, append-only |
| **Completeness** | Partial view (only sees current turn) | Full session context |
| **Latency impact** | Adds to every response cycle | Only at exit |

### Why prompt-type (not command)?

A `command`-type hook runs a shell script — it can see filesystem changes (`git diff`) but has **zero visibility into conversation history**. It cannot know what was discussed, decided, or planned. The compacting-context skill needs the model's context window to distill the session into a meaningful summary.

The cost is one Sonnet-tier call per session exit. This is acceptable given it fires once, not per-response.

### Timeout Considerations

The prompt-type hook needs enough time for the model to generate and write the summary. A 60-second timeout provides margin for Sonnet to produce the compaction output and append it to the file. If timeouts occur in practice, the summary is simply skipped — no data corruption risk since the write is append-only.

## Recommendation

1. **SessionEnd over Stop** — one clean summary per session, no per-response noise
2. **Prompt type with compacting-context** — reuses existing skill, has full session visibility
3. **Append-only output** — simple, no deduplication complexity, file can be periodically archived
4. **Sonnet model** — matches compacting-context's existing model config, balances cost and quality
