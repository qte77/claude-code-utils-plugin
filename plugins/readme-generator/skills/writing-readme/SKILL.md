---
name: writing-readme
description: Generate or update README.md files for repositories, GitHub user profiles, or GitHub organizations. Use when creating a new README, updating an existing one, or converting a repo README to follow org conventions. Supports repo, account (user profile), and org (organization profile) scopes.
compatibility: Designed for Claude Code
metadata:
  argument-hint: <scope> [target]
  allowed-tools: Read, Grep, Glob, Edit, Write, Bash, WebFetch, Agent
---

# Write README

**Scope**: $ARGUMENTS

Generate or update a README.md following scope-specific best practices.

## Phase 1: Detect Scope

Parse `$ARGUMENTS` to determine scope:

- `repo` (default) — README.md for a code repository in the current directory
- `repo <owner/repo>` — README.md for a specific remote repository
- `account <username>` — profile README for a GitHub user (`<username>/<username>/README.md`)
- `org <orgname>` — organization profile README (`.github/profile/README.md`)

If no scope is given, default to `repo` for the current working directory.

## Phase 2: Gather Context

### For `repo`

1. Read existing README.md (if any)
2. Detect project type:
   - `action.yml` / `action.yaml` exists → GitHub Action
   - `pyproject.toml` / `setup.py` → Python library
   - `package.json` → Node.js/TypeScript
   - `Cargo.toml` → Rust
   - `go.mod` → Go
3. Read project manifest for name, version, description, license
4. Scan source tree: `src/`, `lib/`, main entry points
5. Read LICENSE file
6. Check for existing docs: CONTRIBUTING.md, AGENTS.md, docs/

### For `account`

1. `gh api users/<username>` — bio, company, location, blog
2. `gh repo list <username> --limit 30 --json name,description,stargazerCount,primaryLanguage` — repos sorted by stars
3. Read existing `<username>/<username>/README.md` if it exists
4. Identify top 3-5 repos by stars or recent activity

### For `org`

1. `gh api orgs/<orgname>` — description, blog, location
2. `gh repo list <orgname> --limit 50 --json name,description,isPrivate,stargazerCount,primaryLanguage` — public repos
3. Read existing `.github/profile/README.md` or `.github/readme.md`
4. Group repos by domain/purpose
5. Identify pinned repos if any

## Phase 3: Apply Template

### Repo README — GitHub Action

```markdown
# repo-name

![Version](https://img.shields.io/badge/version-X.Y.Z-8A2BE2)
![License](https://img.shields.io/badge/license-Apache--2.0-blue)
![Test Action](https://github.com/owner/repo/actions/workflows/test-action.yaml/badge.svg)
![CodeFactor](https://www.codefactor.io/repository/github/owner/repo/badge)
![CodeQL](https://github.com/owner/repo/actions/workflows/codeql.yaml/badge.svg)
![Dependabot](https://img.shields.io/badge/dependabot-enabled-025e8c)
<!-- Add ruff/pytest badges for Python actions, BATS badge for shell actions -->

One-line description.

## Inputs

| Name | Required | Default | Description |
|------|----------|---------|-------------|
| ... | ... | ... | ... |

## Outputs

| Name | Description |
|------|-------------|
| ... | ... |

## Usage

\`\`\`yaml
name: Example
on: [push]
jobs:
  example:
    runs-on: ubuntu-latest
    steps:
      - uses: owner/repo@vX
        with:
          input_name: value
\`\`\`

## What it does

1. Step one
2. Step two
3. Step three

## License

[License-Type](LICENSE)
```

**Conventions:**
- Input table columns: Name | Required | Default | Description (this order)
- Version badge immediately after H1
- Usage section has a complete, copy-pasteable workflow
- "What it does" uses numbered steps
- License links to `LICENSE` file (never `LICENSE.md`)

### Repo README — Library/Application

```markdown
# repo-name

One-line description.

## Installation

\`\`\`bash
install command
\`\`\`

## Quick Start

\`\`\`python
minimal usage example
\`\`\`

## License

[License-Type](LICENSE)
```

### Account Profile README

```markdown
# Display Name

Tagline or bio — who you are in one sentence.

### Current focus

- What you're working on now (2-3 bullets)

### Projects

- [**project-name**](url) — one-line description
- [**project-name**](url) — one-line description

### Tools & languages

Python · Rust · TypeScript · ...
```

### Organization Profile README

```markdown
# Org Name

Single-sentence mission.

Optional 2-3 sentence elaboration.

---

### What we build

**Domain 1** — brief description with inline links to
[key-repo-1](url) and [key-repo-2](url).

### Get involved

- CTA 1 → [link](url)
- Open an issue or PR on any repo.
```

**Conventions:**
- File MUST be at `.github/profile/README.md`
- 150-400 words total
- License always links to `LICENSE` (never `LICENSE.md`)

## Phase 4: Generate

1. Draft the README applying the appropriate template
2. Verify all links resolve
3. Present the draft to the user for review
4. Write the file after user approval

## Rules

- Never add content the project doesn't have
- Keep descriptions factual — pull from existing docs, manifests, and code
- Don't add emojis unless the user requests them
- Prefer brevity — every sentence should earn its place
- For org READMEs: omit private repos unless the user explicitly asks
- License file is always `LICENSE` (never `LICENSE.md`)
