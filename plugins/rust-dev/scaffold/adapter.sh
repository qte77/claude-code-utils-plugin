#!/bin/bash
#
# Rust scaffold adapter for Ralph Loop
# Deployed to .scaffolds/rust.sh by rust-dev plugin hook.
# Provides Rust-specific implementations of adapter_* interface.
#
# Tools: cargo, rustfmt, clippy, cargo-nextest (optional), cargo-llvm-cov (optional)
#

# Run tests. Prefers cargo-nextest for speed; falls back to cargo test.
_scaffold_test() {
    if command -v cargo-nextest >/dev/null 2>&1; then
        cargo nextest run "$@"
    else
        cargo test "$@"
    fi
}

# Format check + lint with clippy (deny warnings).
_scaffold_lint() {
    cargo fmt --check
    cargo clippy --all-targets -- -D warnings
}

# Static type checking via cargo check (Rust enforces types at compile time).
_scaffold_typecheck() {
    cargo check --all-targets
}

# Cognitive complexity analysis via clippy restriction lint.
_scaffold_complexity() {
    cargo clippy --all-targets -- -W clippy::cognitive_complexity
}

# Run tests with coverage. Prefers cargo-llvm-cov; falls back to cargo test.
_scaffold_coverage() {
    if command -v cargo-llvm-cov >/dev/null 2>&1; then
        cargo llvm-cov --summary-only
    else
        cargo test 2>&1 | tail -5
    fi
}

# Full validation sequence.
_scaffold_validate() {
    if [ -f Makefile ] && make -n validate >/dev/null 2>&1; then
        make validate
    else
        _scaffold_lint && _scaffold_typecheck && _scaffold_test
    fi
}

# Extract pub function/struct/enum/trait/impl signatures from a Rust file.
_scaffold_signatures() {
    local filepath="$1"
    grep -nE "^(pub (async )?fn |pub struct |pub enum |pub trait |impl )" "$filepath" 2>/dev/null || true
}

# Glob pattern for Rust source files.
_scaffold_file_pattern() {
    echo "*.rs"
}

# Set up Rust environment.
_scaffold_env_setup() {
    export RUST_BACKTRACE=1
}

# Generate Rust-specific application docs (minimal main.rs example).
_scaffold_app_docs() {
    local src_dir="$1"
    local app_name
    app_name=$(basename "$src_dir")
    local example_path="$src_dir/main.rs"

    [ -f "$example_path" ] && return 0

    cat > "$example_path" <<RSEOF
//! Minimal viable example demonstrating how to use this application.

use anyhow::Result;

fn main() -> Result<()> {
    // TODO: Add your example usage here
    println!("Example: Running $app_name");
    Ok(())
}
RSEOF
}
