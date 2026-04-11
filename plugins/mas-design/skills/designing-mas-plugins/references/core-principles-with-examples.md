---
title: MAS Plugin Core Principles — Code Examples
description: Vulnerable/secure code patterns for each of the six core MAS plugin design principles (stateless reducer, own context, structured outputs, own control flow, compact errors, single responsibility).
created: 2026-04-11
category: patterns
version: 1.0.0
see-also: mas-design-principles.md
---

Each plugin follows six principles. This file expands each with a worked code example.

## Stateless Reducer Pattern

Each plugin is a pure function: `evaluate(context: BaseModel) -> BaseModel`.

```python
def evaluate(self, context: TierContext) -> TierResult:
    # Pure function - no side effects, no shared state
    # All inputs from context parameter
    # All outputs in return value
    return TierResult(...)
```

## Own Context Window

Plugin manages its own context — no global state access.

```python
def get_context_for_next_tier(
    self, result: TierResult
) -> NextTierContext:
    # Explicit context passing
    # Next tier only sees what this method returns
    return NextTierContext(
        relevant_data=result.extract_relevant(),
    )
```

## Structured Outputs

All data uses validated models — no raw dicts.

```python
class TierResult(BaseModel):
    score: float = Field(ge=0.0, le=1.0)
    reasoning: str
    metrics: dict[str, float]
```

## Own Control Flow

Plugin handles its own errors and timeouts.

```python
def evaluate(self, context: TierContext) -> TierResult:
    try:
        result = self._compute(context)
        return TierResult(score=result, error=None)
    except Exception as e:
        # Return structured error, don't raise
        return TierResult(score=0.0, error=str(e))
```

## Compact Errors

Errors produce structured partial results, not exceptions. No code example — this is an architectural choice enforced by the return type signature (`PluginResult` with optional `error: str | None`).

## Single Responsibility

One metric or tier per plugin. No code example — this is a scoping rule: if a plugin would own two tiers or compute three unrelated metrics, split it into multiple plugins.
