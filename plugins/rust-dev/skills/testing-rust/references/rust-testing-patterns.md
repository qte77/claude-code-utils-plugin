---
title: Rust Testing Patterns Reference
version: 1.0
applies-to: Agents and humans
purpose: Testing patterns for Rust projects — unit, integration, property-based, benchmarks
sources:
  - https://doc.rust-lang.org/book/ch11-00-testing.html
  - https://docs.rs/proptest/latest/proptest/
  - https://docs.rs/criterion/latest/criterion/
  - https://nexte.st/
---

## Test Structure

### In-Module Unit Tests

```rust
// src/parser.rs
pub fn parse(input: &str) -> Result<Ast, ParseError> { ... }

fn internal_helper(s: &str) -> bool { ... }

#[cfg(test)]
mod tests {
    use super::*;  // Access private functions

    #[test]
    fn parse_valid_input() {
        let result = parse("valid").unwrap();
        assert_eq!(result.node_count(), 1);
    }

    #[test]
    fn parse_empty_returns_error() {
        let err = parse("").unwrap_err();
        assert!(matches!(err, ParseError::Empty));
    }

    #[test]
    #[should_panic(expected = "invariant violated")]
    fn panics_on_invariant_violation() {
        dangerous_internal_fn(0);
    }

    #[test]
    fn returns_result() -> Result<(), ParseError> {
        let _ = parse("valid")?;
        Ok(())
    }
}
```

### Integration Tests

```
my-crate/
├── src/lib.rs
├── tests/
│   ├── common/
│   │   └── mod.rs          # Shared fixtures (not run as test file)
│   ├── integration_test.rs
│   └── api_test.rs
└── benches/
    └── benchmark.rs
```

```rust
// tests/integration_test.rs
use my_crate::parse;

#[test]
fn end_to_end_parse_and_render() {
    let ast = parse("input").expect("parse should succeed");
    let output = ast.render();
    assert_eq!(output, "expected output");
}
```

### Shared Test Fixtures

```rust
// tests/common/mod.rs
pub fn sample_config() -> Config {
    Config { timeout: 30, retries: 3 }
}

// tests/integration_test.rs
mod common;

#[test]
fn test_with_fixture() {
    let config = common::sample_config();
    // ...
}
```

## Property-Based Testing (proptest)

Use for: parsers, serializers, math operations, any function with domain constraints.

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn parse_roundtrip(s in "[a-z]{1,100}") {
        let encoded = encode(&s);
        let decoded = decode(&encoded).unwrap();
        assert_eq!(decoded, s);
    }

    #[test]
    fn score_always_in_bounds(value in 0.0f64..=100.0) {
        let score = normalize(value);
        assert!((0.0..=1.0).contains(&score));
    }
}
```

### Strategy Patterns

| Data Type | Strategy |
|-----------|----------|
| Strings | `"[a-z]{1,100}"`, `any::<String>()` |
| Integers | `0..1000i32`, `any::<u64>()` |
| Vecs | `prop::collection::vec(0..100i32, 0..50)` |
| Enums | `prop_oneof![Just(A), Just(B), Just(C)]` |
| Structs | Derive `Arbitrary` or compose strategies |

## Benchmarking (criterion)

```rust
// benches/benchmark.rs
use criterion::{black_box, criterion_group, criterion_main, Criterion};
use my_crate::parse;

fn bench_parse(c: &mut Criterion) {
    let input = "test input data";
    c.bench_function("parse", |b| {
        b.iter(|| parse(black_box(input)))
    });
}

criterion_group!(benches, bench_parse);
criterion_main!(benches);
```

Add to `Cargo.toml`:

```toml
[[bench]]
name = "benchmark"
harness = false

[dev-dependencies]
criterion = { version = "0.5", features = ["html_reports"] }
```

Run: `cargo bench`

## Filesystem Isolation (tempfile)

```rust
use tempfile::TempDir;

#[test]
fn writes_output_file() {
    let dir = TempDir::new().unwrap();
    let path = dir.path().join("output.txt");

    write_output(&path).unwrap();

    let contents = std::fs::read_to_string(&path).unwrap();
    assert_eq!(contents, "expected");
    // dir is automatically cleaned up on drop
}
```

## Mocking (mockall)

```rust
use mockall::automock;

#[automock]
trait Database {
    fn get(&self, key: &str) -> Option<String>;
}

#[test]
fn service_uses_database() {
    let mut mock = MockDatabase::new();
    mock.expect_get()
        .with(eq("user:1"))
        .returning(|_| Some("Alice".to_string()));

    let service = Service::new(Box::new(mock));
    assert_eq!(service.get_user("1"), Some("Alice".to_string()));
}
```

## Test Runner: cargo-nextest

[nextest](https://nexte.st/) is faster than `cargo test` for large test suites:

```bash
cargo install cargo-nextest
cargo nextest run              # Run all tests
cargo nextest run -E 'test(parse)'  # Filter by name
cargo nextest run --retries 2  # Retry flaky tests
```

**Tradeoff**: nextest does not support doctests — run `cargo test --doc` separately.

## Naming Convention

**Format**: `test_{module}_{behavior}`

```rust
test_parser_rejects_empty_input()
test_config_loads_defaults_when_missing()
test_handler_returns_404_for_unknown_route()
```

## Regression Tests

Reference the issue in a comment:

```rust
#[test]
fn test_json_preserves_special_chars() {
    // Reproduces #464: package.json with "packages/*" was corrupted
    // because /* was treated as block comment start
    let input = r#"{"packages": ["packages/*"]}"#;
    let output = filter_json(input);
    assert!(output.contains("packages/*"));
}
```
