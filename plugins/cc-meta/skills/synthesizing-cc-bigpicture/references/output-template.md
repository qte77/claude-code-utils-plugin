# Big-Picture Output Template

The standard markdown template for `bigpicture.md` output. Every synthesis run should produce this structure. Individual sections may be empty if no data is present, but all seven top-level headings should always appear.

```markdown
# Big Picture — <date>

## Reasoning Mode Summary
| Project | Phase | D/C | S/T | Alert |
|---------|-------|-----|-----|-------|

## Active Work Streams
### <Project>
- **Status:** active/stalled — N sessions in last 7d
- **Focus:** <from memory, session summaries + latest sessions>
- **Mode:** <diverging+tactical = exploring> | <converging+strategic = building>
- **Key decisions / Open questions:** <from plans>
- **Tasks:** N open / N total — blockers: <list>
- **Subagent activity:** <if present, summarize recent agent runs: type, outcome>
- **Trajectory:** accelerating/steady/stalled

## Cross-Project Connections
## Active Plans
## TODOs & DONEs
## Blockers & Stale Items
## Mode Transitions Needed
```

## Notes

- **Reasoning Mode Summary** — one row per active project. `D/C` = Diverge/Converge axis, `S/T` = Strategic/Tactical axis. See `reasoning-modes.md` for classification signals.
- **Active Work Streams** — one H3 block per project. Skip projects with zero activity in the time range.
- **Cross-Project Connections** — this is the ONE section allowed to reference projects outside the filter scope when `project-name` is set (as outbound links).
- **Mode Transitions Needed** — populated only when Alerts fired in the Reasoning Mode Summary (e.g., "Diverging for N sessions without convergence").
