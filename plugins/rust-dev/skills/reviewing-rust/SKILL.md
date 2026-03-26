---
name: reviewing-rust
description: Provides focused Rust code reviews for safety, correctness, and idiomatic style. Use when reviewing Rust code quality, security, or pull requests.
compatibility: Designed for Claude Code
metadata:
  allowed-tools: Read, Grep, Glob, Bash
  argument-hint: [file-or-pr-scope]
  stability: stable
---

# Rust Code Review

**Target**: $ARGUMENTS

Provides **concise, focused** Rust code reviews checking safety, correctness,
and idiomatic style.

## Rust Review Standards

See `references/rust-review-checklist.md` for the full checklist.

## Workflow

1. **Identify changed files** — `git diff --name-only main...HEAD -- '*.rs' 'Cargo.toml'`
2. **Read changed code** and understand the intent
3. **Apply checklist** from `references/rust-review-checklist.md`
4. **Report findings** grouped by severity (critical → suggestion)
5. **Verify fixes** if changes are made

## Review Scope

**Always check**: Safety (`unsafe`), error handling, clippy compliance, documentation

**Check if relevant**: Performance, dependency changes, API design

## Critical Findings (Must Fix)

- `unsafe` without `// SAFETY:` comment
- `.unwrap()` / `.expect()` in non-test library code
- `anyhow` in library public API (should be `thiserror`)
- Missing `# Errors` / `# Panics` on public functions
- Hardcoded secrets or credentials
- Known vulnerable dependencies (`cargo audit`)

## Output Format

```markdown
## Review: [scope]

### Critical
- **file:line** — description and fix

### Warnings
- **file:line** — description and suggestion

### Suggestions
- **file:line** — improvement opportunity
```
