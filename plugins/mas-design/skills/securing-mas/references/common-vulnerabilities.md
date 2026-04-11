---
title: Common MAS Vulnerabilities with Code Examples
description: Vulnerable vs secure patterns for prompt injection, type confusion, resource exhaustion, and secret leakage. Mapped to MAESTRO layers.
created: 2026-04-11
category: patterns
version: 1.0.0
see-also: maestro-7-layer-checklist.md
---

Vulnerable vs secure code patterns for each MAESTRO layer's highest-impact vulnerability class.

## Prompt Injection (Layer 1 — Model)

**Vulnerable**:

```python
prompt = f"Evaluate: {user_input}"
```

**Secure**:

```python
result = agent.run(EvalContext(text=user_input))
```

## Type Confusion (Layer 2 — Agent Logic)

**Vulnerable**:

```python
def evaluate(self, context: dict) -> dict:
    return {"score": context["data"]}
```

**Secure**:

```python
def evaluate(
    self, context: EvalContext
) -> EvalResult:
    return EvalResult(score=context.compute())
```

## Resource Exhaustion (Layer 5 — Execution)

**Vulnerable**:

```python
def evaluate(self, context):
    while True:  # Infinite loop
        process(context)
```

**Secure**:

```python
def evaluate(self, context):
    with timeout_context(self.settings.timeout):
        return process(context)
```

## Secret Leakage (Layer 6 — Environment)

**Vulnerable**:

```python
api_key = "sk-1234..."  # Hardcoded
```

**Secure**:

```python
api_key = os.environ["API_KEY"]  # From env
```
