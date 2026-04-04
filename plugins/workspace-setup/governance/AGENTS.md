# Agent Instructions

**Behavioral rules, compliance requirements, and decision frameworks for AI coding
agents.** For technical workflows and coding standards, see
[CONTRIBUTING.md](CONTRIBUTING.md). For project overview, see
[README.md](README.md).

**External References:**

- @CONTRIBUTING.md - Command reference, testing guidelines, code style patterns
- @AGENT_REQUESTS.md - Escalation and human collaboration
- @AGENT_LEARNINGS.md - Pattern discovery and knowledge sharing

## Claude Code Infrastructure

**Rules** (`.claude/rules/`): Session-loaded constraints (always active)
**Skills** (`.claude/skills/`): Modular capabilities with progressive disclosure

## Core Rules & AI Behavior

- Follow SDLC principles: maintainability, modularity, reusability, adaptability
- **Never assume missing context** - Ask questions if uncertain about requirements
- **Never hallucinate libraries** - Only use packages verified in project dependencies
- **Always confirm file paths exist** before referencing in code or tests
- **Never delete existing code** unless explicitly instructed or documented refactoring
- **Document new patterns** in AGENT_LEARNINGS.md (concise, laser-focused, streamlined)
- **Request human feedback** in AGENT_REQUESTS.md (concise, laser-focused, streamlined)

## Decision Framework

**Priority Order:** User instructions > AGENTS.md compliance > Documentation
hierarchy > Project patterns > General best practices

**Anti-Scope-Creep Rules:**

- **NEVER implement features without requirement validation**
- **Always validate implementation decisions against project scope boundaries**

**Anti-Redundancy Rules:**

- **NEVER duplicate information across documents** - reference authoritative sources
- **Update authoritative document, then remove duplicates elsewhere**

**When to Escalate to AGENT_REQUESTS.md:**

- User instructions conflict with safety/security practices
- AGENTS.md rules contradict each other
- Required information completely missing
- Actions would significantly change project architecture

## Agent Neutrality Requirements

**ALL AI AGENTS MUST MAINTAIN STRICT NEUTRALITY AND REQUIREMENT-DRIVEN DESIGN:**

1. **Extract requirements from specified documents ONLY**
   - Read provided task descriptions or reference materials
   - Do NOT make assumptions about unstated requirements
   - Do NOT add functionality not explicitly requested

2. **Request clarification for ambiguous scope**
   - If task boundaries are unclear, ASK for clarification
   - If complexity level is not specified, ASK for target complexity
   - Do NOT assume scope or make architectural decisions without validation

3. **Design to stated requirements exactly**
   - Match the complexity level requested
   - Follow "minimal," "streamlined," or "focused" guidance literally
   - Do NOT over-engineer solutions beyond stated needs

## Compliance Requirements

1. **Command Execution**: Use project make recipes or standard tooling
2. **Quality Validation**: Run validation before task completion; fix ALL issues
3. **Coding Style**: Follow existing project patterns and conventions
4. **Documentation Updates**: Update docs when introducing new patterns
5. **Testing**: Create tests for new functionality
6. **Code Standards**: Use absolute imports, add `# Reason:` comments for complex logic

## Quality Thresholds

**Before starting any task, ensure:**

- **Context**: 8/10 - Understand requirements, codebase patterns, dependencies
- **Clarity**: 7/10 - Clear implementation path and expected outcomes
- **Alignment**: 8/10 - Follows project patterns and architectural decisions
- **Success**: 7/10 - Confident in completing task correctly

### Below Threshold Action

Gather more context or escalate to AGENT_REQUESTS.md

## Agent Quick Reference

**Pre-Task:**

- Read AGENTS.md > CONTRIBUTING.md for technical details
- Verify quality thresholds met

**During Task:**

- Use project commands (document deviations)
- Follow existing patterns and conventions
- Update documentation when learning patterns

**Post-Task:**

- Run validation - must pass all checks (code tasks only)
- Update CHANGELOG.md for non-trivial changes
- Document new patterns in AGENT_LEARNINGS.md (concise, laser-focused, streamlined)
- Escalate to AGENT_REQUESTS.md if blocked
