---
name: simplifying-code
description: Review recent changes for simplification opportunities. Enforces KISS, DRY, YAGNI. Use after code review, before commit.
compatibility: Designed for Claude Code
metadata:
  allowed-tools: Read, Grep, Glob
  argument-hint: [file-or-diff]
  context: inline
  stability: development
---

# Simplify Context

- Staged changes: !`git diff --cached --stat`
- Changed files: !`git diff --cached --name-only`

## Simplification Review

**Scope**: $ARGUMENTS (defaults to staged changes if empty)

Reviews changed code for simplification opportunities. Runs after code
review, before commit.

```
implement → test → review → **simplify** → commit
```

## Input Resolution

1. If `$ARGUMENTS` specifies files, review those files
2. Otherwise review staged changes via `git diff --cached`
3. If nothing staged, review `git diff HEAD~1`

## Simplification Checklist

### KISS — Keep It Simple

- [ ] Can any function/class be simplified without losing clarity?
- [ ] Is there a clearer way to express the same logic?
- [ ] Are there unnecessary abstractions or indirection layers?
- [ ] Are conditionals overly nested? Can guard clauses flatten them?

### DRY — Don't Repeat Yourself

- [ ] Is anything duplicated that could be extracted into a shared function?
- [ ] Are there existing project utilities that already do the same thing?
- [ ] Are similar patterns repeated across files that suggest a missing abstraction?

### YAGNI — You Aren't Gonna Need It

- [ ] Is anything speculative or built for a future that may never come?
- [ ] Are there unused parameters, dead branches, or unreachable code?
- [ ] Are there feature flags or config for non-existent features?
- [ ] Are there TODO/FIXME comments for work that will never happen?

### Reuse Opportunities

- [ ] Does the codebase already have a similar pattern elsewhere?
- [ ] Can a standard library function replace custom code?
- [ ] Are there third-party utilities already in dependencies that apply?

### Deletion Candidates

- [ ] Can anything be removed without losing functionality?
- [ ] Are there commented-out blocks that should be deleted?
- [ ] Are there imports/dependencies no longer used?

## Output Format

Present findings as a markdown table:

| File | Line | Category | Suggestion | Severity |
|------|------|----------|------------|----------|
| `src/foo.py` | 42 | DRY | Extract shared validation into `utils.validate()` | refactor |
| `src/bar.py` | 17 | YAGNI | Remove unused `debug_mode` parameter | remove |
| `src/baz.py` | 88 | KISS | Replace nested ternary with early return | simplify |

### Severity Levels

- **simplify** — nice to have, improves readability
- **refactor** — should do, reduces maintenance burden
- **remove** — dead code, delete without losing functionality

## Completion

After the table, provide a one-line summary:

> **N findings**: X simplify, Y refactor, Z remove

If no findings: confirm the code is already clean.

**Do NOT auto-fix.** Present findings for the developer to decide.
