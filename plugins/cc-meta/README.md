# cc-meta

Claude Code meta-skills for cross-project synthesis and session intelligence.

## Skills

- **synthesizing-cc-bigpicture** — Synthesizes a living meta-plan across Claude Code sessions, plans, tasks, and team communications. Surfaces reasoning modes (diverge/converge, inductive/deductive, top-down/bottom-up) per work stream and project-arching TODOs/DONEs.
- **distilling-plan-learnings** — Extracts decisions, rejected alternatives, and patterns from recent plans into a persistent learnings document. Use after completing a plan or sprint.
- **compacting-context** — Distills verbose outputs into structured summaries following ACE-FCA principles. Use after pollution sources (searches, logs, JSON) or at phase milestones.
- **summarizing-session-end** — Auto-generates a session summary on SessionEnd hook. Writes structured notes to `~/.claude/session-summaries/` for bigpicture synthesis.
- **handing-off-session** — Generates structured session handoff notes for cross-session continuity. Stateless markdown files in `.claude/handoffs/`.
- **persisting-bigpicture-learnings** — Persists bigpicture synthesis as dated snapshots in a learnings hub. Maintains latest pointer + append-only archive for cross-session compound learning.
- **mining-session-patterns** — Extracts actionable patterns from session JSONL files: error-fix sequences, tool failure rates, and cost signals for compound learning.
- **orchestrating-parallel-workers** — Fan out tasks to parallel background agents with independent context windows. Decomposes work into independent units, dispatches via Agent tool, tracks progress, and collects results.

## Usage

```bash
/summarizing-session-end  # Triggered automatically by SessionEnd hook
```

## SessionEnd Hook Configuration

Add to your `.claude/settings.json` to auto-trigger session summaries:

```json
{
  "hooks": {
    "SessionEnd": [
      {
        "type": "prompt",
        "prompt": "/summarizing-session-end"
      }
    ]
  }
}
```

## BigPicture Usage

```bash
/synthesizing-cc-bigpicture                          # All projects, all time
/synthesizing-cc-bigpicture Agents-eval              # Single project
/synthesizing-cc-bigpicture Agents-eval 7d           # Single project, last 7 days
/synthesizing-cc-bigpicture all 30d ./bigpicture.md  # All projects, 30 days, custom output
```

## Install

```bash
claude plugin install cc-meta@qte77-claude-code-plugins
```
