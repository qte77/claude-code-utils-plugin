---
title: Plugin Security Checklist
description: Pre-ship security checklist for plugin implementations. Input validation, output safety, resource management, observability, dependencies.
created: 2026-04-11
category: checklist
version: 1.0.0
see-also: maestro-7-layer-checklist.md
---

Before marking a plugin implementation as complete, verify every category:

## Input Validation

- [ ] All inputs validated via typed model schema
- [ ] String inputs sanitized (no code injection)
- [ ] Numeric inputs range-checked
- [ ] File paths validated (no directory traversal)

## Output Safety

- [ ] Outputs use typed validated models
- [ ] No sensitive data in outputs (PII, API keys)
- [ ] Error messages don't leak internal state
- [ ] Structured errors for graceful degradation

## Resource Management

- [ ] Timeouts configured per component
- [ ] Memory usage bounded (no unbounded loops)
- [ ] File descriptors properly closed
- [ ] Network connections have timeouts

## Observability

- [ ] Structured logging with context
- [ ] Trace events emitted for debugging
- [ ] No sensitive data in logs
- [ ] Error paths logged for audit

## External Dependencies

- [ ] API keys from environment variables
- [ ] External service failures handled gracefully
- [ ] Retry logic with exponential backoff
- [ ] Circuit breaker for cascading failures
