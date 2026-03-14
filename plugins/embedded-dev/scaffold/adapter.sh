#!/bin/bash
#
# Embedded C scaffold adapter for Ralph Loop
# Deployed to .scaffolds/embedded.sh by embedded-dev plugin hook.
# Provides embedded C implementations of adapter_* interface.
#
# Tools: gcc, cppcheck, clang-tidy, cmake
# Signature extraction: ctags-based
#

# Run tests. Output includes "FAILED <test_name>" lines for baseline comparison.
_scaffold_test() {
    if [ $# -gt 0 ]; then
        # Run specific test files
        for test_file in "$@"; do
            echo "Running: $test_file"
            if ! ./"$test_file" 2>&1; then
                echo "FAILED $test_file"
            fi
        done
    else
        # Build and run test suite
        if [ -f "build/test_runner" ]; then
            ./build/test_runner 2>&1
        elif command -v ctest &>/dev/null && [ -d "build" ]; then
            cd build && ctest --output-on-failure 2>&1 && cd ..
        else
            echo "No test runner found — build first with 'make build'"
            return 0
        fi
    fi
}

# Static analysis with cppcheck and clang-tidy.
_scaffold_lint() {
    if [ $# -gt 0 ]; then
        cppcheck --enable=all --suppress=missingInclude "$@" 2>&1
        clang-tidy "$@" 2>&1 || true
    else
        cppcheck --enable=all --suppress=missingInclude src/ 2>&1
        find src/ \( -name '*.c' -o -name '*.h' \) -print0 | xargs -0 clang-tidy 2>&1 || true
    fi
}

# No separate type checking for C (handled by compiler + static analysis).
_scaffold_typecheck() {
    # Compile with all warnings as errors
    if [ -d "build" ]; then
        cmake --build build --parallel 2>&1
    else
        cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="-Wall -Wextra -Werror" 2>&1
        cmake --build build --parallel 2>&1
    fi
}

# Complexity analysis using cppcheck metrics.
_scaffold_complexity() {
    if [ $# -gt 0 ]; then
        cppcheck --enable=style "$@" 2>&1
    else
        cppcheck --enable=style src/ 2>&1
    fi
}

# No coverage tool configured by default.
_scaffold_coverage() {
    _scaffold_test "$@"
}

# Full validation sequence: build + lint + test.
_scaffold_validate() {
    make validate
}

# Extract function signatures using ctags or grep fallback.
_scaffold_signatures() {
    local filepath="$1"
    if command -v ctags &>/dev/null; then
        ctags -x --c-kinds=fp "$filepath" 2>/dev/null | awk '{print NR":"$0}'
    else
        # Fallback: grep for function definitions and struct/typedef
        grep -nE "^(typedef |struct |enum |[a-zA-Z_].*\()" "$filepath" 2>/dev/null || true
    fi
}

# Glob pattern for C/C++ source files.
_scaffold_file_pattern() {
    echo "*.c *.h"
}

# No special environment setup needed for C.
_scaffold_env_setup() {
    :
}

# Generate C-specific application docs.
_scaffold_app_docs() {
    local src_dir="$1"
    local app_name
    app_name=$(basename "$src_dir")
    local example_path="$src_dir/main.c"

    if [ -f "$example_path" ]; then
        return 0  # Don't overwrite existing main.c
    fi

    cat > "$example_path" <<CEOF
/**
 * @file main.c
 * @brief Minimal example for $app_name
 */

#include <stdio.h>

int main(void) {
    printf("Example: Running $app_name\\n");
    return 0;
}
CEOF
}
