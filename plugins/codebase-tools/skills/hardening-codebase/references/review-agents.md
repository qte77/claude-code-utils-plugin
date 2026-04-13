# Review Agent Prompts

Launch all four in parallel via the Agent tool. Pass the diff or file
list as context to each.

## Agent 1: Code Reuse

```
Review changed files for CODE REUSE issues.

For each change:
1. Search for existing utilities/helpers that could replace new code
2. Flag duplicate functionality across files
3. Flag inline logic that could use shared utilities

Focus on: repeated patterns, copy-pasted functions with slight
variation, fragile path computations that should be centralized.

Report: file, issue, suggested fix. No false positives.
```

## Agent 2: Code Quality

```
Review changed files for CODE QUALITY and ARCHITECTURE issues.

Look for:
1. Boundary violations — module reaching into another's internals
2. Circular dependencies — A → B → A import cycles
3. Misplaced logic — business rules in infrastructure, I/O in domain
4. Redundant state — duplicates existing state, could be derived
5. Parameter sprawl — adding params instead of restructuring
6. Leaky abstractions — exposing internals, breaking boundaries
7. Stringly-typed code — raw strings where constants/enums exist
8. Logic bugs — off-by-one, unguarded None, silent fallthrough

Report: file, issue, suggested fix. Skip false positives.
```

## Agent 3: Efficiency

```
Review changed files for EFFICIENCY issues.

Look for:
1. Unnecessary work — redundant computations, repeated reads
2. Missed caching — same expensive result computed multiple times
3. Missed concurrency — independent ops run sequentially
4. N+1 patterns — loop of individual calls instead of batch
5. Overly broad operations — reading all when filtering for one
6. TOCTOU — pre-checking existence before operating

Report: file, issue, estimated savings. Skip false positives.
```

## Agent 4: KISS / DRY / YAGNI

```
Review changed files for KISS, DRY, and YAGNI violations.
Also flag deletion candidates.

KISS — over-engineering:
1. Unnecessary abstractions — interfaces/factories for one implementation
2. Over-nested logic — deep conditionals that guard clauses could flatten
3. Clever code — complex one-liners that a simple loop would clarify
4. Premature generalization — configurable where hardcoded suffices

DRY — duplication:
1. Repeated logic that should be a shared function
2. Copy-pasted config/constants across files
3. Near-identical patterns begging for a single abstraction

YAGNI — speculative and dead code:
1. Features built for hypothetical future requirements
2. Unused parameters accepted but never read
3. Dead branches — unreachable code, impossible conditions
4. Feature flags or config for non-existent features
5. Stale TODOs — TODO/FIXME for work that will never happen
6. Commented-out blocks that should be deleted
7. Unused imports/dependencies no longer referenced

Report: file, issue, principle violated, suggested action.
Skip false positives.
```

## Aggregation

After all four complete, deduplicate findings (agents often flag the
same issue from different angles). Rank by severity:

- **HIGH**: bugs, security, boundary violations, >50 lines of duplication
- **MEDIUM**: caching, DRY violations, magic strings, circular deps
- **LOW**: minor inefficiency, style preferences

Present to user before fixing. Fix HIGHs and MEDIUMs only.
