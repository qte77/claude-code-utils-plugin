---
title: Requirement Hierarchy and ID Conventions
description: >-
  Three-level requirement structure (SYS→PRD→SW) with
  ID naming conventions and parent-child relationships
created: 2026-03-01
category: reference
version: 1.0.0
see-also: compliance-standards.md
---

# Requirement Hierarchy

## Three-Level Structure

```
SYS-REQ (System Requirements)
  └── PRD-REQ (Product Requirements)
        └── SW-REQ (Software Requirements)
```

### Level 1: System Requirements (SYS-REQ)

Top-level requirements derived from:

- Regulatory standards (from `checking-compliance` output)
- Customer/product requirements
- Safety and environmental constraints

**ID format:** `SYS-REQ-NNN` (three-digit, sequential)

**Example:**

```
SYS-REQ-001: Device shall meet EN 55032 Class B conducted emission limits
SYS-REQ-002: Device shall comply with IEC 62368-1 clause 5.4 fire safety
SYS-REQ-003: Device shall support Wi-Fi 802.11b/g/n (2.4 GHz)
```

### Level 2: Product Requirements (PRD-REQ)

Refinement of SYS-REQ into implementation domains (HW/SW/communication).

**ID format:** `PRD-REQ-NNN` with mandatory `parent: SYS-REQ-NNN`

**Example:**

```
PRD-REQ-001: EMI filter on power input shall attenuate >60dB at 150kHz
  parent: SYS-REQ-001
PRD-REQ-004: Software EMV filter shall limit PWM switching noise
  parent: SYS-REQ-001
```

### Level 3: Software Requirements (SW-REQ)

Module-level requirements assigned to specific software components.

**ID format:** `SW-REQ-NNN` with mandatory `parent: PRD-REQ-NNN`

**Example:**

```
SW-REQ-015: EMV filter module shall implement configurable low-pass filter
  parent: PRD-REQ-004
  module: components/emv_filter
```

## Requirements File Format

The standard format for `docs/requirements.md`:

```markdown
# Requirements: <Device Name>

## System Requirements (SYS-REQ)

| ID | Description | Source | Status |
|----|-------------|--------|--------|
| SYS-REQ-001 | ... | EN 55032:2015+A1:2020 | open |

## Product Requirements (PRD-REQ)

| ID | Description | Parent | Domain | Status |
|----|-------------|--------|--------|--------|
| PRD-REQ-001 | ... | SYS-REQ-001 | HW | open |

## Software Requirements (SW-REQ)

| ID | Description | Parent | Module | Status |
|----|-------------|--------|--------|--------|
| SW-REQ-015 | ... | PRD-REQ-004 | emv_filter | open |
```

## Status Values

| Status | Meaning |
|--------|---------|
| `open` | Defined but not yet implemented |
| `in_progress` | Implementation underway |
| `implemented` | Code exists with docstring tag |
| `verified` | Test passes |
| `rejected` | Requirement withdrawn (keep for audit trail) |

## Traceability Rules

1. Every SYS-REQ must have at least one PRD-REQ child
2. Every PRD-REQ must have at least one SW-REQ child (for software-domain requirements)
3. Every SW-REQ must have a `@requirement` tag in code when implemented
4. Every SW-REQ must have a `@test` tag when verified
5. No orphan requirements (every PRD/SW must trace to a parent)

## References

- IEEE 830-1998 — Software Requirements Specifications
- DO-178C §5.1 — Requirements traceability (aerospace reference model)
