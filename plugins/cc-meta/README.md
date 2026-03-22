# cc-meta

Claude Code meta-skills for cross-project synthesis and session intelligence.

## Skills

- **synthesizing-cc-bigpicture** — Synthesizes a living meta-plan across Claude Code sessions, plans, tasks, and team communications. Surfaces reasoning modes (diverge/converge, inductive/deductive, top-down/bottom-up) per work stream and project-arching TODOs/DONEs.

## Usage

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
