# GTM Pipeline Rules

Defines the phase dependency graph, execution order, and teams mode dispatch
for the market-research pipeline.

## Phase Dependency Graph

```
Phase 0  (analyzing-source-project)      ─┐
Phase 1A (researching-industry-landscape) ─┤→ Phase 1B (researching-market)
                                            │      │
                                            │      ↓
                                            │  Phase 2 (validating-product-market-fit)
                                            │      │
                                            │      ↓
                                            │  Phase 3 (developing-gtm-strategy)
                                            │      │
                                            │      ↓
                                            │  Phase 4 (analyzing-contradictions)
                                            │      │
                                            └──────┤
                                                   ↓
                                               Phase 5 (synthesizing-research)
                                                   │
                                                   ↓
                                               Phase 6 (generating-slide-deck)
```

## Execution Rules

- **Phase 0 and Phase 1A run in parallel.** They have no dependency on each other.
- **Phase 1B requires both Phase 0 and Phase 1A outputs** before starting.
- Each subsequent phase requires the immediately preceding phase to pass validation.
- **Phase 5 requires all prior phases (0-4)** to be complete and validated.
- **Phase 6 requires Phase 5** output only.

## Teams Mode Dispatch (Phase 0 + 1A Parallel)

When teams mode is available (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), dispatch
Phase 0 and Phase 1A as parallel subagents:

```
Task 1: /analyzing-source-project    → results/phase-0/
Task 2: /researching-industry-landscape → results/phase-1a/
Task 3: /researching-market          → blockedBy: [Task 1, Task 2] → results/phase-1b/
```

Without teams mode, run Phase 0 first, then Phase 1A, then continue sequentially.

## Input/Output Convention

Each phase reads from:
- `config/` — User configuration (sources, targets, mode, comments)
- `results/<prior-phase>/` — Outputs from dependency phases

Each phase writes to:
- `results/<phase-slug>/` — Phase-specific output files

## Skill Reference

| Phase | Skill |
|-------|-------|
| 0     | `analyzing-source-project` |
| 1A    | `researching-industry-landscape` |
| 1B    | `researching-market` |
| 2     | `validating-product-market-fit` |
| 3     | `developing-gtm-strategy` |
| 4     | `analyzing-contradictions` |
| 5     | `synthesizing-research` |
| 6     | `generating-slide-deck` |

## Mode Awareness

All phases read `config/mode.md` and adjust output verbosity (`concise`/`detailed`)
and strategic posture (`conservative`/`ambitious`) accordingly.
