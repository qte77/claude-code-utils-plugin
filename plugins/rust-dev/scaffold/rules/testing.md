---
paths:
  - "tests/**/*.rs"
  - "src/**/*_test.rs"
  - "benches/**/*.rs"
---

# Testing Rules (Rust)

- Use in-module `#[cfg(test)]` for unit tests, `tests/` for integration tests
- Use `#[should_panic(expected = "...")]` for panic tests, not bare `#[should_panic]`
- Use `tempfile` crate for filesystem isolation, never write to project dirs
- Prefer `proptest` for property-based tests on parsing/validation/serialization logic
- Use `criterion` for benchmarks in `benches/`, never time operations in `#[test]` functions
- Use `assert_eq!(actual, expected)` not `assert!(actual == expected)` for better error messages
- Test names: `test_{module}_{behavior}` (e.g., `test_parser_rejects_empty_input`)
- Reference issues in regression tests: `// Reproduces #123: ...`
