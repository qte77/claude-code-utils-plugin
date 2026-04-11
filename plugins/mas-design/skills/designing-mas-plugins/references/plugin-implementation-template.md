---
title: MAS Plugin Implementation Template
description: Full EvaluatorPlugin abstract base class and a worked MyPlugin example with typed context/result models, error handling, and next-tier context filtering.
created: 2026-04-11
category: template
version: 1.0.0
see-also: core-principles-with-examples.md
---

Complete implementation template for a MAS evaluator plugin. Copy and adapt. Follows the six core principles documented in `core-principles-with-examples.md`.

```python
from abc import ABC, abstractmethod
from pydantic import BaseModel, Field


class PluginContext(BaseModel):
    """Input context from previous tier."""
    data: str
    metadata: dict[str, str]


class PluginResult(BaseModel):
    """Structured output."""
    score: float = Field(ge=0.0, le=1.0)
    reasoning: str
    error: str | None = None


class EvaluatorPlugin(ABC):
    @property
    @abstractmethod
    def name(self) -> str: ...

    @property
    @abstractmethod
    def tier(self) -> int: ...

    @abstractmethod
    def evaluate(
        self, context: PluginContext
    ) -> PluginResult: ...

    @abstractmethod
    def get_context_for_next_tier(
        self, result: PluginResult
    ) -> BaseModel: ...


class MyPlugin(EvaluatorPlugin):
    def __init__(self, settings):
        self.settings = settings

    @property
    def name(self) -> str:
        return "my_evaluator"

    @property
    def tier(self) -> int:
        return 1

    def evaluate(
        self, context: PluginContext
    ) -> PluginResult:
        try:
            score = self._compute(context)
            return PluginResult(
                score=score, reasoning="...",
            )
        except Exception as e:
            return PluginResult(
                score=0.0, reasoning="", error=str(e),
            )

    def get_context_for_next_tier(
        self, result: PluginResult
    ) -> BaseModel:
        return NextTierContext(score=result.score)

    def _compute(self, context: PluginContext) -> float:
        ...
```
