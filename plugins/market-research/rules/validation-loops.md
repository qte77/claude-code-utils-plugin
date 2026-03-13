# Validation Loops

Configurable correction cycles for the GTM pipeline. Controls retry behavior,
quality gates, and escalation rules between phases.

## Retry Configuration

```
max_retries: 2
```

- Each phase may be retried up to `max_retries` times if it fails validation.
- On each retry, the agent receives the validation failures as feedback and regenerates output.
- If `max_retries` is exhausted without passing, the phase escalates (see below).

## Quality Gates

Before advancing to the next phase, the current phase output must pass all
mandatory criteria defined in `config/validation_criteria.md`.

Gate check sequence:
1. Read `config/validation_criteria.md` for the current phase.
2. Check each mandatory criterion (`[ ]`) against the phase output.
3. If all pass → proceed to next phase.
4. If any fail → enter retry loop with specific failure list as context.

## Escalation Rules

Escalate to human review when:
- A phase fails all `max_retries` attempts without passing mandatory criteria.
- A contradiction in Phase 4 has no resolvable recommendation (deadlock).
- Phase 5 synthesis confidence rating is Low for more than 50% of major claims.

Escalation output format:
```
ESCALATION: [phase-name]
Failed criteria:
- [criterion 1]
- [criterion 2]
Attempted retries: [N]
Recommendation: Human review required before proceeding to [next-phase].
```

## Partial Pass Policy

If a phase passes all mandatory criteria but fails optional enrichment checks,
it is considered passing. The agent should note the gaps in the phase output
summary but may proceed.

## Validation Skipping

To skip validation for a phase (e.g. for rapid prototyping), add the phase slug
to a `skip_validation` list in `config/mode.md`:

```
skip_validation:
  - phase-1a
```

Skipped phases emit a warning but do not block pipeline progression.
