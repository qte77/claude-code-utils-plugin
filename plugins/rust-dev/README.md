# rust-dev

Rust implementation, testing, and code review skills with scaffold adapter for Ralph loop.

## Skills

| Skill | Trigger |
|-------|---------|
| `implementing-rust` | Writing Rust code, creating crates, implementing features |
| `testing-rust` | Writing tests, TDD, property tests, benchmarks |
| `reviewing-rust` | Code review for safety, correctness, idiomatic style |

## Scaffold Adapter

| Function | Command |
|----------|---------|
| `_scaffold_test` | `cargo nextest run` (fallback: `cargo test`) |
| `_scaffold_lint` | `cargo fmt --check && cargo clippy -- -D warnings` |
| `_scaffold_typecheck` | `cargo check --all-targets` |
| `_scaffold_complexity` | `cargo clippy -- -W clippy::cognitive_complexity` |
| `_scaffold_coverage` | `cargo llvm-cov --summary-only` (fallback: `cargo test`) |
| `_scaffold_validate` | `make validate` or lint+typecheck+test sequence |
| `_scaffold_signatures` | Extract `pub fn/struct/enum/trait/impl` signatures |
| `_scaffold_file_pattern` | `*.rs` |

## CI Workflow Templates

Deployed to `.github/workflows/` when `.scaffold == "rust"`:

- `cargo-test.yaml` — format check + clippy + tests
- `cargo-audit.yaml` — RustSec vulnerability scanning
- `dependabot.yaml` — automated Cargo + GHA dependency updates

## Settings

Grants Bash permissions for: `cargo build`, `cargo test`, `cargo check`,
`cargo clippy`, `cargo fmt`, `cargo audit`, `cargo deny`, `cargo doc`,
`cargo nextest`, `rustup`.

## Authoritative References

All skills reference first-party Rust documentation:

- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/checklist.html) (Rust Library Team)
- [Clippy Lint Index](https://rust-lang.github.io/rust-clippy/stable/index.html) (Rust Clippy Team)
- [Rust Reference: Unsafety](https://doc.rust-lang.org/reference/unsafety.html) (Rust Language Team)
- [Cargo Manifest](https://doc.rust-lang.org/cargo/reference/manifest.html) (Cargo Team)
- [Rustdoc Conventions](https://doc.rust-lang.org/rustdoc/how-to-write-documentation.html) (Rust Docs Team)
- [RustSec Advisories](https://rustsec.org/) (Rust Secure Code WG)
- [ANSSI Security Guide](https://anssi-fr.github.io/rust-guide/) (French National Cybersecurity Agency)
- [Rust Performance Book](https://nnethercote.github.io/perf-book/) (N. Nethercote, Rust compiler team)
