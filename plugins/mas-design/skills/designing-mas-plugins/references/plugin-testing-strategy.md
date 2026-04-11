---
title: MAS Plugin Testing Strategy
description: Isolation test patterns for MAS plugins. Happy path and structured-error-handling tests using mocked context.
created: 2026-04-11
category: patterns
version: 1.0.0
see-also: plugin-implementation-template.md
---

Test plugins in isolation with mocked context. Two minimum test classes: happy path and error handling. Both assert on the structured `PluginResult` — never expect exceptions to propagate.

```python
def test_plugin_happy_path():
    plugin = MyPlugin(settings)
    context = PluginContext(data="test", metadata={})
    result = plugin.evaluate(context)
    assert result.score >= 0.0
    assert result.error is None


def test_plugin_error_handling():
    plugin = MyPlugin(settings)
    context = PluginContext(data="bad", metadata={})
    result = plugin.evaluate(context)
    # Structured error, not exception
    assert result.error is not None
```
