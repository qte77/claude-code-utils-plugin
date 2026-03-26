---
name: testing-rust
description: Writes tests following TDD and property-based testing with proptest. Use when writing unit tests, integration tests, benchmarks, or property tests in Rust.
compatibility: Designed for Claude Code
metadata:
  allowed-tools: Read, Grep, Glob, Edit, Write, Bash
  argument-hint: [test-scope or component-name]
  stability: stable
---

# Rust Testing

**Target**: $ARGUMENTS

Writes **focused, behavior-driven tests** following project testing patterns.

## Quick Reference

**Full documentation**: `references/rust-testing-patterns.md`

## Quick Decision

**Unit tests**: In-module `#[cfg(test)]` for testing internal logic and private functions.

**Integration tests**: `tests/` directory for testing public API from the outside.

**Property tests**: `proptest` for parsers, serializers, math, domain constraints.

**Benchmarks**: `criterion` in `benches/` for performance regression detection.

## TDD Essentials

**Cycle**: RED (failing test) → GREEN (minimal pass) → REFACTOR (clean up)

**Structure**: Arrange-Act-Assert

```rust
#[test]
fn order_processor_calculates_total() {
    // ARRANGE
    let items = vec![Item::new(10.00, 2), Item::new(5.00, 1)];
    let processor = OrderProcessor::new();

    // ACT
    let total = processor.calculate_total(&items);

    // ASSERT
    assert_eq!(total, 25.00);
}
```

## proptest Priorities

| Priority | Area | Example |
|----------|------|---------|
| CRITICAL | Math formulas | Scores always in bounds |
| CRITICAL | Roundtrips | Encode → decode == identity |
| HIGH | Input validation | Handles arbitrary strings |
| HIGH | Serialization | Always valid JSON/TOML |

## What to Test

**High-Value**: Business logic, error paths, edge cases, public API contracts

**Avoid**: Compiler-enforced type safety, trivial getters, third-party crate behavior

## Execution

```bash
cargo test                     # All tests
cargo test -- --ignored        # Run ignored (slow) tests
cargo test parser              # Filter by name
cargo nextest run              # Faster parallel execution
cargo bench                    # Benchmarks
cargo test --doc               # Doctests only
```

## Quality Gates

- [ ] All tests pass (`cargo test --all-features`)
- [ ] TDD Red-Green-Refactor followed
- [ ] Arrange-Act-Assert structure used
- [ ] `test_{module}_{behavior}` naming convention
- [ ] Regression tests reference issue number
- [ ] `tempfile` used for filesystem isolation
- [ ] No `.unwrap()` in assertions — use `assert!(result.is_ok(), "{result:?}")`
