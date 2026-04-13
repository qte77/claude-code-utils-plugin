# planning

Planning agents for feature implementation and refactoring. Forward-looking, per-feature plans — distinct from the retrospective and cross-project synthesis skills in `cc-meta`.

## Agents

- **planner** — Expert feature/refactor planning specialist. Produces detailed implementation plans with phased steps, file-level specificity, dependency tracking, risk analysis, and testing strategy. Cherry-picked from [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) (MIT).

## When to use each

| Task | Use |
|---|---|
| "Help me plan how to add feature X" | `planner` (this plugin) |
| "What am I working on across all my projects?" | `synthesizing-cc-bigpicture` (cc-meta) |
| "What did I learn from my recent plans?" | `distilling-plan-learnings` (cc-meta) |
| "Log what happened in this session" | `summarizing-session-end` (cc-meta) |

The `planner` agent is **prospective** (plans a specific thing); the cc-meta skills are **retrospective or cross-project** (orient, extract, log).

## Install

```bash
claude plugin install planning@qte77-claude-code-plugins
```
