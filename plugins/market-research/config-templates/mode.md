# Mode Configuration

2x2 strategy matrix controlling output style and strategic approach across all phases.

## Style

Controls output verbosity and depth.

```
style: concise
```

Options:
- `concise` — Bullet points, executive summaries, key findings only. Faster execution.
- `detailed` — Full narrative analysis, supporting evidence, extended recommendations.

## Approach

Controls risk tolerance and ambition of recommendations.

```
approach: conservative
```

Options:
- `conservative` — Proven playbooks, de-risked recommendations, incremental moves.
- `ambitious` — First-mover positioning, aggressive expansion, contrarian bets.

## Matrix Summary

|              | concise               | detailed              |
|--------------|-----------------------|-----------------------|
| conservative | Fast triage output    | Deep due-diligence    |
| ambitious    | Rapid attack surface  | Full moonshot thesis  |

## Notes

All skills read this file at the start of execution and adjust their output accordingly.
To change mode mid-pipeline, update this file before running the next phase.
