---
title: Report Structure Templates
description: >-
  Templates for status, assessment, post-mortem, and
  executive report document types
created: 2026-03-01
category: templates
version: 1.0.0
---

# Report Structure Templates

## Status Report

```markdown
---
title: <Project Name> — Status Report
date: YYYY-MM-DD
type: status
author: <Name>
period: YYYY-MM-DD to YYYY-MM-DD
---

# Status Report: <Project Name>

**Period:** <Start date> to <End date>

## Summary

<2-3 sentence overview of current project state.>

## Completed This Period

- <Accomplishment 1>
- <Accomplishment 2>

## In Progress

| Item | Owner | ETA | Status |
|------|-------|-----|--------|
| <Item 1> | <Name> | <Date> | On track / At risk / Blocked |

## Blockers

- [ ] <Blocker 1> — <Who can unblock, what is needed>

## Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|------------|
| <Risk 1> | H/M/L | H/M/L | <Mitigation> |

## Next Steps

- [ ] <Action 1> — <Owner> — <Due date>

## Metrics

| Metric | Previous | Current | Target |
|--------|----------|---------|--------|
| <Metric 1> | <Value> | <Value> | <Value> |
```

## Assessment Report

```markdown
---
title: <Subject> — Assessment Report
date: YYYY-MM-DD
type: assessment
author: <Name>
scope: <What is being assessed>
---

# Assessment: <Subject>

## Executive Summary

<Brief overview of findings and recommendations.>

## Scope

<What was assessed, methodology used, timeframe.>

## Findings

### Finding 1: <Title>

**Severity:** Critical / High / Medium / Low
**Description:** <Detailed description>
**Evidence:** <Supporting data or observations>
**Recommendation:** <Proposed action>

### Finding 2: <Title>

...

## Summary of Findings

| # | Finding | Severity | Recommendation |
|---|---------|----------|---------------|
| 1 | <Finding 1> | High | <Action> |

## Recommendations

### Immediate (0-2 weeks)

- <Recommendation 1>

### Short-term (1-3 months)

- <Recommendation 1>

### Long-term (3-12 months)

- <Recommendation 1>

## Conclusion

<Summary of overall assessment and critical next steps.>
```

## Post-Mortem Report

```markdown
---
title: Post-Mortem — <Incident Title>
date: YYYY-MM-DD
type: post-mortem
author: <Name>
incident-date: YYYY-MM-DD
severity: SEV-1 | SEV-2 | SEV-3 | SEV-4
---

# Post-Mortem: <Incident Title>

**Date of incident:** <Date>
**Duration:** <Start time> to <End time> (<total duration>)
**Severity:** <SEV level>
**Status:** Draft / In review / Final

## Summary

<One paragraph describing what happened, impact, and resolution.>

## Impact

- **Users affected:** <Number or percentage>
- **Revenue impact:** <Estimate or "none">
- **Data loss:** <Yes/No, details>

## Timeline

| Time (UTC) | Event |
|------------|-------|
| HH:MM | <First indicator of issue> |
| HH:MM | <Alert fired / team paged> |
| HH:MM | <Root cause identified> |
| HH:MM | <Fix deployed> |
| HH:MM | <Full recovery confirmed> |

## Root Cause

<Detailed technical explanation of what went wrong and why.>

## Contributing Factors

- <Factor 1>
- <Factor 2>

## What Went Well

- <Positive 1>

## What Went Poorly

- <Negative 1>

## Action Items

| # | Action | Owner | Priority | Due Date | Status |
|---|--------|-------|----------|----------|--------|
| 1 | <Action> | <Name> | P1/P2/P3 | <Date> | Open |

## Lessons Learned

<Key takeaways for the team and organization.>
```

## Executive Summary

```markdown
---
title: Executive Summary — <Topic>
date: YYYY-MM-DD
type: executive
author: <Name>
audience: <Intended audience>
---

# Executive Summary: <Topic>

## Situation

<Current state, context, and why this matters. 2-3 sentences.>

## Key Findings

1. **<Finding 1>** — <One sentence explanation>
2. **<Finding 2>** — <One sentence explanation>
3. **<Finding 3>** — <One sentence explanation>

## Recommendation

<Clear, actionable recommendation. 2-3 sentences.>

## Expected Outcome

<What success looks like, timeline, measurable impact.>

## Next Steps

1. <Immediate action> — <Owner>
2. <Follow-up action> — <Owner>

---

*Detailed supporting documentation available in <link to full report>.*
```

## References

- [Atlassian Incident Management Handbook](https://www.atlassian.com/incident-management/handbook)
- [Google SRE Book — Postmortem Culture](https://sre.google/sre-book/postmortem-culture/)
