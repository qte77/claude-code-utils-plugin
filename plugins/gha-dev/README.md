# gha-dev

Skills for creating and publishing GitHub Actions to the Marketplace.

## Skills

| Skill | Trigger |
|-------|---------|
| `creating-gha` | Scaffolding a new action, writing BATS tests, preparing a Marketplace release |

## What It Provides

- **TDD workflow**: BATS infra tests first (RED), then implement to pass (GREEN)
- **Marketplace requirements**: `action.yaml` fields, branding, README format
- **Signed commit pattern**: blob→tree→commit→branch→PR→squash via `gh api`
- **Release flow**: `bump-my-version` + floating major tag (`v0`, `v1`, ...)

## Settings

Grants Bash permissions for: `gh`, `bats`, `shellcheck`, `actionlint`.

## Install

```bash
claude plugin install gha-dev@qte77-claude-code-plugins
```
