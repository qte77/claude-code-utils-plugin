---
name: creating-gha
description: Creates GitHub Actions for the Marketplace. Use when scaffolding a new action, implementing composite steps, writing BATS tests, or preparing a Marketplace release.
compatibility: Designed for Claude Code
metadata:
  allowed-tools: Read, Grep, Glob, Edit, Write, Bash, WebSearch, WebFetch
  argument-hint: [action-name]
  stability: stable
---

# Creating GitHub Actions

**Target**: $ARGUMENTS

Creates a **Marketplace-ready** composite GitHub Action with TDD, signed commits,
and proper release flow.

## Marketplace Requirements

See `references/marketplace-checklist.md` for full reference.

**Required `action.yaml` fields:**
- `name` — unique on Marketplace (check before using)
- `description` — shown in search results
- `branding` — `icon` (Feather icon name) + `color` (white/yellow/blue/green/orange/red/purple/gray-dark)

## Scaffold

```
action.yaml           # composite action definition + branding
scripts/              # shell scripts called by action steps
tests/unit/           # BATS test files
.github/workflows/    # ci.yaml (bats + actionlint + shellcheck), release.yaml
README.md             # usage example with @v1, inputs table, version badge
```

## TDD Workflow

**RED — infra tests first:**

```bash
# tests/unit/test_action.bats
@test "action.yaml exists" { [ -f action.yaml ]; }
@test "action.yaml has name field" { grep -q "^name:" action.yaml; }
@test "action.yaml has description field" { grep -q "^description:" action.yaml; }
@test "action.yaml has branding" { grep -q "^branding:" action.yaml; }
@test "action.yaml has runs.using composite" { grep -q "using: composite" action.yaml; }
```

Run: `bats tests/unit/` — all must fail first.

**GREEN — implement to pass:**

Write `action.yaml` with required fields. Add `scripts/` and steps. Run `bats tests/unit/` — all pass.

**VALIDATE:**

```bash
actionlint
shellcheck scripts/*.sh
```

## Commit Flow (protected main — no direct push)

Use signed commit via GitHub API (blob→tree→commit→branch→PR→squash).
See `references/marketplace-checklist.md` for the full bash pattern.

Never `git push` directly to main.

## Release Flow

1. Merge PR to main
2. Trigger `release.yaml` workflow (uses `bump-my-version` with `commit=false tag=false`)
3. Workflow creates `v0.1.0` tag + GitHub Release + floating `v0` tag
4. On GitHub Release page: check "Publish this Action to the GitHub Marketplace"

## Quality Checks

```bash
actionlint
shellcheck scripts/*.sh
bats tests/unit/
```

All must pass before PR creation.

## Repository Security Settings

- **Actions permissions**: allow owner + selected non-owner actions only
- **Commit SHA pinning**: require for all third-party actions
- **Workflow permissions**: read-only default (workflows declare writes explicitly)
- **Artifact/log retention**: 30 days (not default 90)
- **Cache retention**: 7 days, 1 GB limit
- **Fork PR approval**: require for all external contributors
- **Allow Actions to create PRs**: enabled (for bump + data workflows)

## Python GHA Pattern (uv)

```yaml
- uses: astral-sh/setup-uv@v6
  with:
    enable-cache: true
- run: |
    uv sync --frozen --no-dev --project "${{ github.action_path }}"
    uv run --project "${{ github.action_path }}" python "${{ github.action_path }}/src/app.py"
```
