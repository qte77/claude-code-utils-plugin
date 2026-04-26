# Agent Instructions

**Behavioral rules, compliance requirements, and decision frameworks for AI
coding agents.** For technical workflows and coding standards, see
[CONTRIBUTING.md](CONTRIBUTING.md). For project overview, see
[README.md](README.md).

**External References:**

- @CONTRIBUTING.md — Command reference, testing guidelines, code style patterns
- @AGENT_REQUESTS.md — Escalation and human collaboration
- @AGENT_LEARNINGS.md — Pattern discovery and knowledge sharing

## Claude Code Infrastructure

**Rules** (`.claude/rules/`): Session-loaded constraints (always active)
**Skills** (`.claude/skills/`): Modular capabilities with progressive disclosure

## Core Rules & AI Behavior

<!-- Project-specific rules. Common starting points:
- Follow SDLC principles: maintainability, modularity, reusability, adaptability
- Never assume missing context — ask if uncertain
- Never hallucinate libraries — only use packages verified in dependencies
- Always confirm file paths exist before referencing
- Never delete existing code unless explicitly instructed
- Document new patterns in AGENT_LEARNINGS.md
- Request human feedback in AGENT_REQUESTS.md
-->

## Task Tracking Authority

<!-- Define your task tracking hierarchy. Example chain:
GitHub Issues → per-repo TODO.md → cross-project state → session plans
-->

## Decision Framework

**Priority Order:** User instructions > AGENTS.md compliance > Documentation
hierarchy > Project patterns > General best practices

**When to Escalate to AGENT_REQUESTS.md:**

- User instructions conflict with safety/security practices
- AGENTS.md rules contradict each other
- Required information completely missing
- Actions would significantly change project architecture

## Compliance Requirements

<!-- Project-specific quality gates. Common ones:
1. Command Execution: use project make recipes or standard tooling
2. Quality Validation: run validation before task completion
3. Coding Style: follow existing project patterns
4. Documentation Updates: update docs when introducing patterns
5. Testing: create tests for new functionality
-->

## Quality Thresholds

**Before starting any task, ensure:**

- **Context**: 8/10 — Understand requirements, codebase, dependencies
- **Clarity**: 7/10 — Clear implementation path
- **Alignment**: 8/10 — Follows project patterns
- **Success**: 7/10 — Confident in completing correctly

Below threshold: gather more context or escalate.

## Agent Quick Reference

**Pre-task:** Read AGENTS.md → CONTRIBUTING.md, verify thresholds
**During:** Use project commands, follow patterns, document new ones
**Post-task:** Run validation, update CHANGELOG.md, document learnings,
escalate blockers
