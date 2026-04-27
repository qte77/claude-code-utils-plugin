---
title: Agent Learning Documentation
description: Non-obvious patterns that prevent repeated mistakes across sprints
---

## Template

- **Context**: When/where this applies
- **Problem**: What issue this solves
- **Solution**: Implementation approach
- **Example**: Working code
- **References**: Related files

## Learned Patterns

### Workflows pushing to a shared branch need `concurrency:`

- **Context**: GHA workflows that push to a long-lived shared branch (`gh-pages`, deployment, release) from multiple jobs or via repeated `workflow_dispatch`.
- **Problem**: Parallel runs each fetch the branch, do work, then push — second pusher hits non-fast-forward rejection. Wasted compute scales with run length (we lost 48 min of commit generation).
- **Solution**: Declare a workflow-level concurrency group keyed by the shared branch.
- **Example**:

  ```yaml
  concurrency:
    group: gh-pages-paint
    cancel-in-progress: false
  ```

- **References**: qte77/gha-contribution-ascii PR #77; failed run 23672476504.
