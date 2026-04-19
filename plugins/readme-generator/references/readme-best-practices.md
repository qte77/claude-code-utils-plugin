# README Best Practices Reference

## Organization Profile READMEs

**File location:** `.github/profile/README.md`

**Structure (150-400 words):**
1. H1 + single-sentence mission
2. Brief elaboration (2-3 sentences)
3. Projects grouped by domain with inline links
4. Get involved section with CTAs

## GitHub User Profile READMEs

**File location:** `<username>/<username>/README.md`

**Structure (under 300 words):**
1. Name/tagline
2. Current focus (2-3 bullets)
3. Featured projects (3-5 linked)
4. Tech stack
5. Links/contact

## Repository READMEs — GitHub Actions

**Standard badge set (in order, below H1):**
1. Version — `![Version](https://img.shields.io/badge/version-X.Y.Z-8A2BE2)`
2. License — `![License](https://img.shields.io/badge/license-Apache--2.0-blue)`
3. GHA status — test-action workflow badge
4. CodeFactor — `![CodeFactor](https://www.codefactor.io/repository/github/owner/repo/badge)`
5. CodeQL — CodeQL workflow status badge
6. Dependabot — `![Dependabot](https://img.shields.io/badge/dependabot-enabled-025e8c)`
7. Ruff / Pytest — linter + test badges (Python actions)
8. BATS — test framework badge (shell-based actions)

**Required sections (in order):**
1. `# repo-name` + badges
2. One-line description
3. `## Inputs` — table: Name | Required | Default | Description
4. `## Outputs` — table (or "This action has no outputs.")
5. `## Usage` — complete workflow YAML
6. `## What it does` — numbered steps
7. `## License` — `[License-Type](LICENSE)`

**Conventions:**
- License file is always `LICENSE` (never `LICENSE.md`)
- Input table column order: Name | Required | Default | Description
- Pinned action SHAs in usage examples: `@<sha> # vX.Y.Z`

## Repository READMEs — Libraries

**Required:** Title, description, install/quick start, `[License-Type](LICENSE)`

## Cross-Repo Consistency

- Input/output table column order must be consistent
- Badge set and placement must be consistent
- Section naming: "What it does" (preferred) or "How it works"
- License always `LICENSE` (never `LICENSE.md`)
