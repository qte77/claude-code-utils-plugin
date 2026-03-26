---
title: Rust Best Practices Reference
version: 1.0
applies-to: Agents and humans
purpose: Security-first Rust coding standards with type safety, error handling, and toolchain patterns
sources:
  - https://rust-lang.github.io/api-guidelines/checklist.html
  - https://rust-lang.github.io/rust-clippy/stable/index.html
  - https://doc.rust-lang.org/reference/unsafety.html
  - https://doc.rust-lang.org/rustdoc/how-to-write-documentation.html
  - https://doc.rust-lang.org/cargo/reference/manifest.html
  - https://rustsec.org/
  - https://anssi-fr.github.io/rust-guide/
  - https://nnethercote.github.io/perf-book/
---

## Error Handling (Non-Negotiable)

### Decision Tree

| Context | Crate | Pattern |
|---------|-------|---------|
| Library crate (public API) | `thiserror` | Derive `Error` on enum, callers match variants |
| Binary crate / `main()` | `anyhow` | `Result<()>` + `.context()` chaining |
| Tests | — | `.unwrap()` / `.expect("test context")` acceptable |
| Never in library APIs | — | `unwrap()`, `expect()`, `panic!()` |

**Library error type** ([thiserror](https://docs.rs/thiserror)):

```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("parse error at position {position}: {message}")]
    Parse { position: usize, message: String },

    #[error("invalid configuration: {0}")]
    Config(String),
}
```

**Application error propagation** ([anyhow](https://docs.rs/anyhow)):

```rust
use anyhow::{Context, Result};

fn read_config(path: &Path) -> Result<Config> {
    let contents = fs::read_to_string(path)
        .with_context(|| format!("Failed to read config from {path:?}"))?;
    serde_json::from_str(&contents)
        .context("Config file is not valid JSON")
}
```

**Rule**: Never mix `thiserror` and `anyhow` in the same crate's public API. `thiserror` for what callers see, `anyhow` for internal propagation in binaries.

### Panic Policy

- `panic!()` only for programmer errors (violated invariants), never for user input
- Destructors (`Drop`) must never panic — log and absorb errors
- Prefer `?` operator over `.unwrap()` / `.expect()` in all non-test code

Ref: [Rust API Guidelines — C-VALIDATE](https://rust-lang.github.io/api-guidelines/checklist.html)

## Unsafe Code Policy

Ref: [Rust Reference — Unsafety](https://doc.rust-lang.org/reference/unsafety.html), [ANSSI Secure Coding Guide](https://anssi-fr.github.io/rust-guide/)

### The 8 Unsafe Operations (Rust 2024)

1. Dereference raw pointers (`*const T` / `*mut T`)
2. Read/write mutable or unsafe static variables
3. Access fields of a `union`
4. Call `unsafe fn` functions
5. Call safe functions marked `#[target_feature]` without matching attributes
6. Implement `unsafe trait`
7. Declare `unsafe extern { ... }` blocks (Rust 2024 edition requires `unsafe` keyword)
8. Apply unsafe attributes

### Rules

- **Every `unsafe` block requires a `// SAFETY:` comment** explaining the invariants
- Minimize scope: smallest possible `unsafe` block, wrap in a safe abstraction immediately
- Use `#![forbid(unsafe_code)]` in library crates; `#![deny(unsafe_code)]` in binaries with audited exceptions
- FFI: use `CStr`/`CString`, never raw pointer arithmetic without bounds proof
- Run `cargo-geiger` to quantify unsafe surface in dependency tree

```rust
// SAFETY: `ptr` is guaranteed non-null and aligned by the allocator contract
// in `Buffer::new()`. The lifetime is bounded by `&self`.
let value = unsafe { &*self.ptr };
```

## Type Safety

Ref: [Rust API Guidelines — Type Safety](https://rust-lang.github.io/api-guidelines/checklist.html)

- **Newtypes for static distinctions**: `struct Meters(f64)` vs `struct Seconds(f64)` — prevents argument confusion
- **Prefer enum/newtype arguments over `bool`**: `fn connect(mode: TlsMode)` not `fn connect(use_tls: bool)`
- **Builder pattern** for structs with 4+ fields or complex validation
- **`as` casts are dangerous**: use `.try_into()` or `TryFrom` for numeric conversions to catch truncation/sign loss
- Use checked arithmetic for user-controlled values: `.checked_add()`, `.saturating_add()`
- Eagerly implement `Clone, Debug, PartialEq, Eq, Hash` on public types ([C-COMMON-TRAITS](https://rust-lang.github.io/api-guidelines/checklist.html))

## Clippy Lint Configuration

Ref: [Clippy Lint Index](https://rust-lang.github.io/rust-clippy/stable/index.html)

Configure in `Cargo.toml` (modern, workspace-aware — replaces `#![deny(...)]` in source):

```toml
[lints.rust]
unsafe_code = "forbid"

[lints.clippy]
pedantic = { level = "warn", priority = -1 }
# High-value restriction lints
unwrap_used = "warn"
expect_used = "warn"
panic = "warn"
dbg_macro = "warn"
todo = "warn"
# High-value pedantic lints (already included in pedantic group)
missing_errors_doc = "deny"
missing_panics_doc = "deny"
cast_possible_truncation = "warn"
# Commonly suppressed pedantic lints (with reason)
module_name_repetitions = "allow"  # unavoidable in idiomatic module layout
must_use_candidate = "allow"       # noisy for non-critical functions
```

**Never** put `#![deny(warnings)]` in source code — breaks downstream builds when new warnings are added. Use `RUSTFLAGS="-D warnings"` in CI only.

### Lint Groups

| Group | Level | Purpose |
|-------|-------|---------|
| `correctness` | deny (default) | Actual bugs — always fix |
| `suspicious` | warn (default) | Patterns that seem unintended |
| `style` | warn (default) | Idiomatic Rust style |
| `pedantic` | allow (opt-in) | Stricter guidelines — enable project-wide |
| `restriction` | allow (opt-in) | Enable per-lint only, not as group |

## Cargo.toml Best Practices

Ref: [Cargo Manifest Format](https://doc.rust-lang.org/cargo/reference/manifest.html)

```toml
[package]
name = "my-crate"
version = "0.1.0"
edition = "2021"
rust-version = "1.75"              # MSRV — always set explicitly
description = "One-line summary"
license = "MIT OR Apache-2.0"      # Dual-license is Rust ecosystem convention
repository = "https://github.com/..."
keywords = ["max", "five", "words"]
categories = ["development-tools"]

[features]
default = []                       # Keep defaults minimal
serde = ["dep:serde"]              # Gate optional deps behind features

[profile.release]
opt-level = 3
lto = true
codegen-units = 1
strip = true
```

### Workspace Layout

```toml
[workspace]
members = ["crates/*"]
resolver = "2"

[workspace.package]
edition = "2021"
license = "MIT OR Apache-2.0"

[workspace.dependencies]
serde = { version = "1", features = ["derive"] }
```

### Cargo.lock Policy

- **Commit** `Cargo.lock` for binaries and applications
- **Gitignore** `Cargo.lock` for library crates

## Documentation (rustdoc)

Ref: [Rustdoc: How to Write Documentation](https://doc.rust-lang.org/rustdoc/how-to-write-documentation.html)

Every `pub` item needs a doc comment. Required sections:

```rust
/// Brief one-line description (shown in module overview).
///
/// Longer description with context and edge cases.
///
/// # Errors
///
/// Returns [`AppError::Parse`] if `input` contains invalid UTF-8.
///
/// # Panics
///
/// Panics if `limit` is zero.
///
/// # Safety (unsafe fn only)
///
/// Caller must ensure `ptr` is non-null and points to valid memory.
///
/// # Examples
///
/// ```rust
/// use my_crate::parse;
/// let result = parse("hello")?;
/// assert_eq!(result.len(), 5);
/// # Ok::<(), Box<dyn std::error::Error>>(())
/// ```
pub fn parse(input: &str) -> Result<Ast, AppError> { ... }
```

- Use `?` in examples, not `.unwrap()` — per [API Guidelines](https://rust-lang.github.io/api-guidelines/checklist.html)
- Hide boilerplate with `# ` prefix lines (visible in source, hidden in rendered docs)
- Module-level `//!` docs in `lib.rs` with overview + quickstart example
- Type signatures are auto-linked — do not duplicate in prose

## Security

Ref: [RustSec Advisory Database](https://rustsec.org/), [ANSSI Rust Guide](https://anssi-fr.github.io/rust-guide/)

### Supply Chain

- `cargo audit` — scan `Cargo.lock` against RustSec advisories (run in CI)
- `cargo deny` — enforce license policy + ban specific crates + advisory scanning

```toml
# deny.toml
[advisories]
vulnerability = "deny"
unmaintained = "warn"

[licenses]
allow = ["MIT", "Apache-2.0", "Apache-2.0 WITH LLVM-exception"]

[bans]
multiple-versions = "warn"
```

### Secrets

- Environment variables only, never hardcoded in source
- Use `secrecy::Secret<String>` to prevent accidental logging of sensitive values

### Deserialization

- Validate untrusted data with `serde` + Rust type constraints
- Avoid `#[serde(flatten)]` on untrusted input (can bypass validation)
- Set size limits on deserialized collections

### Integer Safety

- Debug builds trap overflow (panic), release builds wrap silently
- Use `.checked_add()` / `.saturating_add()` for user-controlled values
- Enable `clippy::arithmetic_side_effects` for security-critical code

## Ownership & Lifetimes

### Parameter Guidelines

| Situation | Use |
|-----------|-----|
| Read-only, no ownership needed | `&str`, `&[T]`, `&Path` |
| Need to store/return owned data | `String`, `Vec<T>`, `PathBuf` |
| Sometimes owned, sometimes borrowed | `Cow<'_, str>` (only when genuinely needed) |
| Accept anything string-like | `impl AsRef<str>` or `&str` |

- Prefer `&str` over `String` for function parameters that don't need ownership
- Name lifetimes explicitly when two or more references appear in the same signature
- Avoid `.clone()` to fix borrow errors — restructure ownership instead

## Naming Conventions

Ref: [Rust API Guidelines — Naming](https://rust-lang.github.io/api-guidelines/checklist.html)

| Item | Convention | Example |
|------|-----------|---------|
| Types, traits | `UpperCamelCase` | `HttpClient`, `IntoIterator` |
| Functions, methods, modules | `snake_case` | `read_config`, `into_inner` |
| Constants, statics | `SCREAMING_SNAKE_CASE` | `MAX_RETRIES` |
| Conversions | `as_`/`to_`/`into_` | `as_bytes()` (cheap), `to_string()` (alloc), `into_inner()` (consuming) |
| Iterators | `iter()`/`iter_mut()`/`into_iter()` | On collections |
| Getters | `fn field(&self) -> T` | No `get_` prefix (idiomatic Rust) |

## Common Anti-Patterns

| Anti-Pattern | Impact | Fix |
|-------------|--------|-----|
| `.unwrap()` in library code | Panics propagate to callers | Return `Result<T, E>` |
| `anyhow` in lib crate public API | Opaque errors for callers | Use `thiserror` |
| `clone()` to fix borrow errors | Hidden performance cost | Restructure ownership |
| `#![deny(warnings)]` in lib.rs | Breaks downstream on nightly | Use `[lints]` in Cargo.toml |
| `lazy_static!` for new code | Outdated | Use `std::sync::OnceLock` (stable since 1.70) |
| `as` for numeric casts | Silent truncation/sign loss | Use `.try_into()` |
| Missing `// SAFETY:` on unsafe | Code review rejection | Always document invariants |
| `String` params that should be `&str` | Unnecessary allocation | Accept `&str` or `impl AsRef<str>` |
| Global mutable state (`static mut`) | Data races, UB | Use `Mutex<T>` or `OnceLock<T>` |
| Panic in `Drop` | Double panic → abort | Log and absorb errors |
| `Box<Vec<T>>` | Double indirection | Use `Vec<T>` directly |

## Performance

Ref: [Rust Performance Book](https://nnethercote.github.io/perf-book/)

- Profile before optimizing: `cargo flamegraph`, `criterion` benchmarks
- `String::with_capacity(n)` for known-size string building
- `cargo build --timings` for compile-time analysis
- Avoid monomorphization bloat: extract non-generic logic from generic functions
- `cargo llvm-lines` to find functions generating excessive LLVM IR
