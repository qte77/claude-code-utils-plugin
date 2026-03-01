---
name: testing-python
description: Writes tests following TDD (using pytest and Hypothesis) and BDD best practices. Use when writing unit tests, integration tests, or BDD scenarios.
compatibility: Designed for Claude Code
metadata:
  allowed-tools: Read, Grep, Glob, Edit, Write, Bash
  argument-hint: [test-scope or component-name]
---

# Python Testing

**Target**: $ARGUMENTS

Writes **focused, behavior-driven tests** following project testing strategy.

## Quick Reference

**Full documentation**: `references/`

- `references/testing-strategy.md` - Strategy, what to test, patterns to remove
- `references/tdd-best-practices.md` - TDD methodology
- `references/bdd-best-practices.md` - BDD methodology

## Quick Decision

**TDD (default)**: Use pytest for known cases, Hypothesis for edge cases. Works at unit/integration/acceptance levels.

**BDD (optional)**: Use Given-When-Then for stakeholder collaboration on acceptance criteria.

See `references/testing-strategy.md` for full methodology comparison.

## TDD Essentials (Quick Reference)

**Cycle**: RED (failing test) → GREEN (minimal pass) → REFACTOR (clean up)

**Structure**: Arrange-Act-Assert (AAA)

```python
def test_order_processor_calculates_total():
    # ARRANGE
    items = [Item(price=10.00, qty=2), Item(price=5.00, qty=1)]
    processor = OrderProcessor()

    # ACT
    total = processor.calculate_total(items)

    # ASSERT
    assert total == 25.00
```

## Hypothesis Priorities (Edge Cases within TDD)

| Priority | Area | Example |
| ---------- | ------ | --------- |
| CRITICAL | Math formulas | Scores always in bounds |
| CRITICAL | Loop termination | Never hangs |
| HIGH | Input validation | Handles any text |
| HIGH | Serialization | Always valid JSON |

## What to Test (KISS/DRY/YAGNI)

**High-Value**: Business logic, integration points, edge cases, contracts

**Avoid**: Library behavior, trivial assertions, implementation details, default constants, stale fixture patches (see `references/testing-strategy.md` → "Patterns to Remove")

See `references/testing-strategy.md` → "Patterns to Remove" for full list.

## Naming Convention

**Format**: `test_{module}_{component}_{behavior}`

```python
test_user_service_creates_new_user()
test_order_processor_validates_items()
```

## Execution

```bash
make test              # All tests
make test_rerun        # Rerun failed tests (fast iteration)
make validate          # Full pre-commit validation
pytest tests/ -v       # Verbose
pytest -k test_user_   # Filter by name
```

## Quality Gates

- [ ] All tests pass (`make test`)
- [ ] TDD Red-Green-Refactor followed
- [ ] Arrange-Act-Assert structure used
- [ ] Naming convention followed
- [ ] Behavior-focused (not implementation)
- [ ] No library behavior tested
- [ ] Mocks for third-party types use spec=RealClass
