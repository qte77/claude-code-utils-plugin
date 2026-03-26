---
name: implementing-rust
description: Implements idiomatic Rust code matching architect specifications. Use when writing Rust code, creating crates, or when the user asks to implement features in Rust.
compatibility: Designed for Claude Code
metadata:
  allowed-tools: Read, Grep, Glob, Edit, Write, Bash, WebSearch, WebFetch
  argument-hint: [feature-name]
  stability: stable
---

# Rust Implementation

**Target**: $ARGUMENTS

Creates **focused, idiomatic** Rust implementations following architect
specifications exactly. No over-engineering.

## Rust Standards

See `references/rust-best-practices.md` for comprehensive Rust guidelines.

## Workflow

1. **Read architect specifications** from provided documents
2. **Validate scope** — Simple (single module) vs Complex (workspace/multi-crate)
3. **Study existing patterns** in `src/` structure
4. **Implement minimal solution** matching stated functionality
5. **Create focused tests** matching task complexity
6. **Run validation** and fix all issues

## Implementation Strategy

**Simple Tasks**: Single module, `Result<T, E>` returns, in-module `#[cfg(test)]`
unit tests, `anyhow` for error propagation

**Complex Tasks**: Multi-module with `thiserror` error types, trait-based design,
`proptest` for edge cases, integration tests in `tests/`

**Always**: Use existing project patterns, match `Cargo.toml` lint config

## Output Standards

**Simple Tasks**: Focused functions with doc comments and unit tests
**Complex Tasks**: Complete modules with `# Errors`/`# Panics` docs and full test coverage
**All outputs**: Idiomatic, no `.unwrap()` in non-test code, `// SAFETY:` on any `unsafe`

## Quality Checks

Before completing any task:

```bash
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cargo test --all-features
```

All formatting, lints, and tests must pass.
