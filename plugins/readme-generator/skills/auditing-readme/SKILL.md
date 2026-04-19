---
name: auditing-readme
description: Audit README.md files against best practices for repos, accounts, or orgs. Detects missing sections, stale links, inconsistent formatting, and convention violations. Use when reviewing README quality across one or many repos.
compatibility: Designed for Claude Code
metadata:
  argument-hint: <scope> [target-or-glob]
  allowed-tools: Read, Grep, Glob, Bash, WebFetch, Agent
---

# Audit README

**Scope**: $ARGUMENTS

Audit README.md files against scope-specific best practices and report findings.

## Phase 1: Detect Scope and Targets

Parse `$ARGUMENTS`:

- `repo` — audit README.md in the current directory
- `repo <owner/repo>` — audit a specific remote repo's README
- `repos <owner/pattern>` — batch audit multiple repos (e.g., `repos qte77/gha-*`)
- `account <username>` — audit a GitHub user profile README
- `org <orgname>` — audit an organization profile README

## Phase 2: Fetch READMEs

- Local repos: read README.md directly
- Remote repos: `gh api repos/<owner>/<repo>/contents/README.md --jq '.content' | base64 -d`
- Account profiles: `gh api repos/<user>/<user>/contents/README.md --jq '.content' | base64 -d`
- Org profiles: try `profile/README.md` first, fall back to root `README.md` in `.github` repo

## Phase 3: Run Checklist

### Base Repo Checklist

| # | Check | Level | Pass Condition |
|---|-------|-------|----------------|
| R1 | Title | required | H1 heading exists, matches repo name |
| R2 | Description | required | Non-empty text within 3 lines of H1 |
| R3 | Version badge | recommended | `![Version]` badge present |
| R3b | Standard badge set | recommended | For GHA repos: version, license, CI status, CodeFactor, CodeQL, Dependabot, ruff/pytest or BATS (applicable subset) |
| R4 | Install/Usage | required | Section with heading containing "install", "usage", "quick start", or "getting started" |
| R5 | License | required | Section containing "license" with link to `LICENSE` (not `LICENSE.md`) |
| R6 | Internal links valid | required | All `[text](relative-path)` links resolve to existing files |
| R7 | LICENSE file name | required | License file must be named `LICENSE` (not `LICENSE.md`) |

### GHA Extension (if `action.yml`/`action.yaml` exists)

| # | Check | Level | Pass Condition |
|---|-------|-------|----------------|
| G1 | Inputs table | required | Markdown table under heading containing "input" |
| G2 | Outputs table | required | Markdown table or "no outputs" statement |
| G3 | Usage YAML | required | Fenced yaml block with `uses:` |
| G4 | What it does | required | Section with numbered steps |
| G5 | Input column order | recommended | Name, Required, Default, Description |

### Account Profile Checklist

| # | Check | Level | Pass Condition |
|---|-------|-------|----------------|
| A1 | Tagline | required | Non-empty text within 5 lines of first heading |
| A2 | Current focus | recommended | Section describing current work |
| A3 | Featured projects | recommended | 3+ repository links with descriptions |
| A4 | Not stale | required | Updated within 6 months |
| A5 | Scannability | recommended | Under 500 words |

### Organization Profile Checklist

| # | Check | Level | Pass Condition |
|---|-------|-------|----------------|
| O1 | File location | required | README at `.github/profile/README.md` |
| O2 | Mission | required | Single-sentence purpose within 3 lines of H1 |
| O3 | Activities | required | Description of what the org does |
| O4 | Projects | recommended | Links to key repos, grouped by domain |
| O5 | CTA | required | "Get involved" section with actionable links |
| O6 | Length | recommended | 150-400 words |

## Phase 4: Report

Output a findings table per target:

```
## <repo-name>

| # | Check | Level | Status | Notes |
|---|-------|-------|--------|-------|

Summary: X/Y required pass, Z/W recommended pass.
```

### Batch Summary

```
| Repo | Required | Recommended | Top Issue |
|------|----------|-------------|-----------|
```

### Consistency Checks (batch only)

- Input table column order consistent?
- Badge style/placement consistent?
- Section naming consistent?
- License format consistent (`LICENSE` not `LICENSE.md`)?

## Rules

- Never modify files during an audit — read-only
- Report facts, not opinions
- License file MUST be `LICENSE` (not `LICENSE.md`) — flag as FAIL if `.md` variant used
