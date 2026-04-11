# cc-meta

Claude Code meta-skills for cross-project synthesis and session intelligence.

## Skills

- **synthesizing-cc-bigpicture** — Synthesizes a living meta-plan across Claude Code sessions, plans, tasks, and team communications. Surfaces reasoning modes (diverge/converge, inductive/deductive, top-down/bottom-up) per work stream and project-arching TODOs/DONEs.
- **distilling-plan-learnings** — Extracts decisions, rejected alternatives, and patterns from recent plans into a persistent learnings document. Use after completing a plan or sprint.
- **compacting-context** — Distills verbose outputs into structured summaries following ACE-FCA principles. Use after pollution sources (searches, logs, JSON) or at phase milestones.
- **summarizing-session-end** — Auto-generates a session summary on SessionEnd hook. Writes structured notes to `~/.claude/session-summaries/` for bigpicture synthesis.

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
claude plugin install cc-meta@qte77-claude-code-utils
```
