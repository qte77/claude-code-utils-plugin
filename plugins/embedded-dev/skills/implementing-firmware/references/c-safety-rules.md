---
title: C Safety Rules and MISRA-C Configuration
description: >-
  MISRA-C cppcheck flags, clang-tidy configuration,
  and requirement tagging rules for safety-critical C code
created: 2026-03-01
category: reference
version: 1.0.0
---

# C Safety Rules

## MISRA-C:2023 Overview

MISRA-C:2023 (Ed. 4) classifies rules as:

| Category | Meaning | Action |
|----------|---------|--------|
| **Mandatory** | Must always be followed | No deviations permitted |
| **Required** | Must be followed unless formally deviated | Deviation requires documented rationale |
| **Advisory** | Recommended practice | Follow unless impractical |

## cppcheck with MISRA Addon

### Basic Invocation

```bash
cppcheck \
    --addon=misra.py \
    --std=c11 \
    --enable=all \
    --suppress=missingIncludeSystem \
    --suppress=unmatchedSuppression \
    --xml \
    --output-file=reports/misra-report.xml \
    src/
```

### ESP-IDF Specific Flags

```bash
cppcheck \
    --addon=misra.py \
    --std=c11 \
    --enable=all \
    -I components/*/include \
    -I $IDF_PATH/components/esp_common/include \
    -I $IDF_PATH/components/freertos/FreeRTOS-Kernel/include \
    --suppress=missingIncludeSystem \
    --suppress=unmatchedSuppression \
    -DESP_PLATFORM \
    --xml \
    --output-file=reports/misra-report.xml \
    components/*/src/ main/
```

### PlatformIO Integration

In `platformio.ini`:

```ini
check_tool = cppcheck
check_flags =
    cppcheck: --addon=misra.py --std=c11 --enable=all
check_severity = high, medium
```

## clang-tidy Configuration

### .clang-tidy

```yaml
Checks: >
  clang-analyzer-*,
  bugprone-*,
  cert-*,
  misc-*,
  -bugprone-easily-swappable-parameters
WarningsAsErrors: ''
HeaderFilterRegex: '.*'
```

### Invocation

```bash
clang-tidy \
    -checks='clang-analyzer-*,bugprone-*,cert-*,misc-*' \
    -p build/ \
    src/**/*.c
```

## Deviation Documentation

When a MISRA rule must be deviated, document using this format:

```
Deviation ID:   DEV-NNN
MISRA Rule:     Rule X.Y (Mandatory/Required/Advisory)
File:           path/file.c:line
Rationale:      Technical justification for why the rule
                does not apply or risk is acceptable
Risk:           Low / Medium / High
Approved by:    Name, Role
Date:           YYYY-MM-DD
```

In code, mark with inline comment:

```c
/* MISRA Rule 11.3 deviation DEV-001: cast required for hardware register access */
volatile uint32_t *reg = (volatile uint32_t *)0x3FF44000;  // cppcheck-suppress misra-c2012-11.3
```

## Requirement Docstring Tags

Every function implementing a requirement must include:

```c
/**
 * @brief Short description of function purpose
 *
 * @requirement SW-REQ-NNN
 * @parent      PRD-REQ-NNN
 * @test        TEST-NNN
 * @status      draft | implemented | verified
 * @version     M.m.p
 *
 * @param name  Parameter description
 * @return      Return value description
 */
```

**Rules:**

- `@requirement`, `@parent`, `@test` are mandatory for every tagged function
- `@status` and `@version` are optional but recommended
- One function may implement multiple requirements (multiple `@requirement` tags)
- The `@test` ID must match a test function in `test/`

## Common MISRA-C Violations in Embedded

| Rule | Description | Typical cause |
|------|------------|---------------|
| 11.3 | Cast between pointer and integer | Hardware register access |
| 11.5 | Cast from void pointer | FreeRTOS task parameters |
| 8.7 | Objects with block scope | Globals needed for ISR access |
| 2.7 | Unused parameters | Callback signatures |
| 10.4 | Arithmetic type mismatch | SDK API return values |

## References

- [MISRA C:2023 Guidelines](https://misra.org.uk/misra-c/)
- [cppcheck MISRA addon](https://cppcheck.sourceforge.io/misra.php)
