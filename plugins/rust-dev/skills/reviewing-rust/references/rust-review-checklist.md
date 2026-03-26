---
title: Rust Code Review Checklist
version: 1.0
applies-to: Agents and humans
purpose: Structured review checklist for Rust code — safety, correctness, idiomatic style
sources:
  - https://rust-lang.github.io/api-guidelines/checklist.html
  - https://rust-lang.github.io/rust-clippy/stable/index.html
  - https://doc.rust-lang.org/reference/unsafety.html
  - https://rustsec.org/
---

## Safety Review

- [ ] Every `unsafe` block has a `// SAFETY:` comment explaining invariants
- [ ] `unsafe` scope is minimized — wrapped in safe abstraction
- [ ] No `unsafe` that could be replaced with safe alternatives
- [ ] FFI calls use `CStr`/`CString`, not raw pointer arithmetic
- [ ] `#![forbid(unsafe_code)]` or `#![deny(unsafe_code)]` at crate level

## Error Handling

- [ ] Library code uses `thiserror` for error types — no `anyhow` in public API
- [ ] No `.unwrap()` or `.expect()` in non-test code paths
- [ ] `?` operator used for propagation, not manual `match` on `Result`
- [ ] `.context()` / `.with_context()` on fallible operations (binary crates)
- [ ] Error messages describe what failed and include relevant data
- [ ] `Drop` implementations never panic

## Clippy & Linting

- [ ] `cargo clippy --all-targets -- -D warnings` passes
- [ ] `cargo fmt --check` passes
- [ ] `[lints.clippy]` configured in `Cargo.toml` (not `#![deny(...)]` in source)
- [ ] `clippy::pedantic` enabled project-wide
- [ ] `clippy::unwrap_used` and `clippy::expect_used` enabled as warnings
- [ ] Any `#[allow(clippy::...)]` has a justifying comment

## Documentation (rustdoc)

- [ ] Every `pub` function/struct/enum/trait has a `///` doc comment
- [ ] `# Errors` section on functions returning `Result`
- [ ] `# Panics` section on functions that can panic
- [ ] `# Safety` section on every `unsafe fn`
- [ ] `# Examples` with runnable doctests using `?` (not `.unwrap()`)
- [ ] Module-level `//!` docs in `lib.rs`

## Type Safety & API Design

- [ ] Newtypes used for domain distinctions (not bare primitives)
- [ ] No `bool` parameters — use enums for named options
- [ ] Numeric conversions use `.try_into()`, not `as` casts
- [ ] `From`/`Into` for conversions, not ad-hoc methods
- [ ] `Clone, Debug, PartialEq, Eq` implemented where appropriate

## Security

- [ ] `cargo audit` clean (no known vulnerabilities in dependencies)
- [ ] No secrets hardcoded in source — environment variables only
- [ ] Untrusted deserialization uses type constraints (no unrestricted `#[serde(flatten)]`)
- [ ] Size limits on deserialized collections from external input
- [ ] Checked arithmetic for user-controlled numeric values

## Dependencies

- [ ] `Cargo.lock` committed (binary crates) or gitignored (library crates)
- [ ] No unnecessary dependencies — prefer `std` when available
- [ ] Optional dependencies gated behind `[features]` with `dep:` prefix
- [ ] `deny.toml` configured for license and advisory enforcement (if applicable)

## Testing

- [ ] New functionality has corresponding tests
- [ ] Regression tests reference the issue number in a comment
- [ ] `tempfile` used for filesystem operations (no writes to project dirs)
- [ ] Property tests (`proptest`) for parsers/serializers/math
- [ ] Tests compile and pass: `cargo test --all-features`

## Performance (when relevant)

- [ ] No `.clone()` used to work around borrow checker — restructure ownership
- [ ] `String::with_capacity()` for known-size string building
- [ ] No `Box<Vec<T>>` or `Box<String>` (double indirection)
- [ ] Hot paths pre-allocate rather than grow incrementally
- [ ] `criterion` benchmarks for performance-critical code
