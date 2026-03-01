---
title: Requirement Tagging and Reconciliation
description: >-
  C docstring tag specification for @requirement, @parent,
  @test and the reconciliation algorithm for DB-vs-code validation
created: 2026-03-01
category: reference
version: 1.0.0
---

# Requirement Tagging Specification

## Tag Set

| Tag | Format | Example | Purpose |
|-----|--------|---------|---------|
| `@requirement` | `SW-REQ-NNN` | `@requirement SW-REQ-015` | Links function to software requirement |
| `@parent` | `PRD-REQ-NNN` | `@parent PRD-REQ-004` | Links to parent product requirement |
| `@test` | `TEST-NNN` | `@test TEST-015` | Links to test case ID |
| `@status` | enum | `@status implemented` | Implementation status |
| `@version` | semver | `@version 1.2.0` | Implementation version |

## Grep Patterns for Tag Extraction

```bash
# Extract all @requirement tags with file:line
grep -rn '@requirement\s\+SW-REQ-[0-9]\{3\}' --include='*.c' --include='*.h' src/ components/

# Extract all @parent tags
grep -rn '@parent\s\+PRD-REQ-[0-9]\{3\}' --include='*.c' --include='*.h' src/ components/

# Extract all @test tags from test files
grep -rn '@test\s\+TEST-[0-9]\{3\}' --include='*.c' test/

# Extract functions without any requirement tag (dead code candidates)
# Two-pass: find function definitions, then exclude those with @requirement
grep -rn '^\w.*\s\+\w\+(.*)\s*{' --include='*.c' src/ | grep -v 'static\s\+inline'
```

## Reconciliation Algorithm

### Input

1. **Requirements source** — `docs/requirements.md` or SQL database export
2. **Code tags** — Extracted from C source files via grep
3. **Test tags** — Extracted from test files via grep

### Process

```
FUNCTION reconcile(requirements_file, source_dirs, test_dirs):

    # Step 1: Parse requirements
    sys_reqs  ← parse_table(requirements_file, "SYS-REQ")
    prd_reqs  ← parse_table(requirements_file, "PRD-REQ")
    sw_reqs   ← parse_table(requirements_file, "SW-REQ")

    # Step 2: Extract code tags
    code_req_tags   ← grep("@requirement SW-REQ-", source_dirs)
    code_parent_tags ← grep("@parent PRD-REQ-", source_dirs)
    test_tags       ← grep("@test TEST-", test_dirs)

    # Step 3: Validate hierarchy (requirements file internal)
    FOR EACH prd IN prd_reqs:
        IF prd.parent NOT IN sys_reqs:
            REPORT "Broken link: {prd.id} → {prd.parent} (SYS-REQ not found)"

    FOR EACH sw IN sw_reqs:
        IF sw.parent NOT IN prd_reqs:
            REPORT "Broken link: {sw.id} → {sw.parent} (PRD-REQ not found)"

    # Step 4: Validate code coverage
    implemented_ids ← extract_ids(code_req_tags)

    FOR EACH sw IN sw_reqs WHERE sw.status != "rejected":
        IF sw.id NOT IN implemented_ids:
            REPORT "Unimplemented: {sw.id} — {sw.description}"

    # Step 5: Find orphaned code
    FOR EACH tag IN code_req_tags:
        IF tag.value NOT IN sw_reqs:
            REPORT "Orphaned code: {tag.file}:{tag.line} references {tag.value}"

    # Step 6: Validate parent links in code
    FOR EACH tag IN code_parent_tags:
        IF tag.value NOT IN prd_reqs:
            REPORT "Broken @parent: {tag.file}:{tag.line} references {tag.value}"

    # Step 7: Check test coverage
    tested_ids ← extract_requirement_refs(test_tags)

    FOR EACH sw IN sw_reqs WHERE sw.status != "rejected":
        IF sw.id NOT IN tested_ids:
            REPORT "Untested: {sw.id}"

    # Step 8: Generate coverage matrix
    RETURN build_matrix(sw_reqs, code_req_tags, test_tags)
```

### Output Categories

| Category | Severity | Meaning |
|----------|----------|---------|
| **Unimplemented** | High | SW-REQ exists in DB but no `@requirement` tag in code |
| **Orphaned code** | High | `@requirement` tag in code but no matching DB entry |
| **Broken parent** | High | `@parent` references non-existent PRD-REQ |
| **Untested** | Medium | SW-REQ implemented but no `@test` match |
| **Dead code** | Low | Function without any requirement tag |

## Coverage Matrix Format

```
| Requirement | Description (truncated) | Code Location | Test ID | Status |
|-------------|------------------------|---------------|---------|--------|
| SW-REQ-001  | EMV filter init...     | src/emv.c:42  | TEST-001| ✓ OK   |
| SW-REQ-002  | Power monitor...       | —             | —       | ✗ MISS |
| SW-REQ-003  | WiFi credential...     | src/wifi.c:87 | —       | ~ TEST |
```

Legend: `✓ OK` = implemented + tested, `✗ MISS` = not implemented, `~ TEST` = implemented but untested

## References

- IEEE 830-1998 — Recommended Practice for Software Requirements Specifications
- ISO/IEC/IEEE 29148:2018 — Systems and software engineering — Life cycle processes — Requirements engineering
