---
title: MAS Security Testing Patterns
description: Explicit test patterns for security controls, keyed to MAESTRO layers. Input validation, timeout enforcement, error message safety.
created: 2026-04-11
category: patterns
version: 1.0.0
see-also: maestro-7-layer-checklist.md
---

Test security controls explicitly — don't assume they work. Each test names the MAESTRO layer it covers.

```python
def test_input_validation():
    """Layer 2: Reject invalid inputs."""
    plugin = MyPlugin(settings)
    with pytest.raises(ValidationError):
        plugin.evaluate(EvalContext(score=999))


def test_timeout_enforcement():
    """Layer 5: Prevent infinite execution."""
    plugin = MyPlugin(settings)
    with pytest.raises(TimeoutError):
        plugin.evaluate(EvalContext(data="loop"))


def test_error_message_safety():
    """Layer 2: Don't leak internal state."""
    plugin = MyPlugin(settings)
    result = plugin.evaluate(
        EvalContext(data="trigger_error")
    )
    assert "secret" not in result.error.lower()
```
