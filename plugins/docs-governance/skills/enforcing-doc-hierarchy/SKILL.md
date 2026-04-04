---
name: enforcing-doc-hierarchy
description: Audits and aligns project documentation against its own declared hierarchy. Discovers authority chains from CONTRIBUTING.md (or equivalent), then detects broken links, duplicates, and misplaced content. Use when reviewing doc health, fixing stale references, or enforcing single-source-of-truth.
compatibility: Designed for Claude Code
metadata:
  argument-hint: [file-directory-or-full]
  allowed-tools: Read, Grep, Glob, Edit
---

# Enforce Documentation Hierarchy

**Scope**: $ARGUMENTS

Audits documentation against the project's declared hierarchy, then aligns
violations with user approval.

## Phase 1: Discover

Read the project's hierarchy declaration. Look for (in order):

1. `CONTRIBUTING.md` — "Documentation Hierarchy" section (table or list)
2. `AGENTS.md` — "Key references" or "Information sources" section
3. `README.md` — "Documentation" section (links to authoritative docs)

Extract:

- **Entry points**: which docs are human vs agent entry points
- **Authority map**: which doc owns which content type
- **Anti-redundancy rule**: stated or implied (default: no duplication across docs)

If no hierarchy is declared, report that as the first finding and stop.

## Phase 2: Audit

Detect violations across the scope. For each finding, record:

| Source File | Line | Type | Description |
|-------------|------|------|-------------|
| path | Lnn | type | what's wrong |

### Violation Types

- **broken-link**: Reference target does not exist (moved, renamed, deleted, wrong case)
- **duplicate**: Same content (3+ lines) appears in both an authority doc and a dependent doc
- **misplaced**: Content is in the wrong doc per the discovered authority map, OR a doc in the hierarchy is not referenced by its parent
- **lint-compat**: HTML comments before frontmatter or inline markdownlint disable/enable pairs

### Audit Procedure

1. **Determine scope** from `$ARGUMENTS`:
   - File: audit that file's outbound references and content placement
   - Directory: audit all `.md` files in that directory
   - `full` or empty: audit every `.md` file in the repo

2. **Check links**: For each `[text](path)` and `@file` reference, verify the
   target exists. Check case sensitivity.

3. **Check duplicates**: For each authority doc, search dependent docs for
   substantial repeated content (3+ lines or identical tables).

4. **Check placement**: For each doc, verify its content matches its declared
   authority. Flag content that belongs in a different doc per the authority map.

5. **Check chain**: Verify each doc in the hierarchy is referenced by at least
   one parent doc. Flag orphaned docs.

6. **Check markdownlint compatibility**: Flag files where:
   - HTML comments appear before frontmatter on line 1
   - Inline `<!-- markdownlint-disable/enable -->` pairs exist (should use `.markdownlint.json`)

7. **Output findings table** sorted by type, then file.

## Phase 3: Align

Resolve findings with user confirmation. Propose each fix and wait for approval.

| Violation | Fix |
|-----------|-----|
| **broken-link** | Update path. If target deleted, remove reference. |
| **duplicate** | Keep in authority doc, replace in dependent doc with reference link. |
| **misplaced** | Move content to authority doc, replace original with reference link. |
| **lint-compat** | Remove HTML comments before frontmatter. Remove inline disable/enable pairs; configure `.markdownlint.json` instead. |

### Rules

- Fix the **authority doc first**, then fix dependents
- Never duplicate — replace with a reference
- Confirm each fix before applying
- Keep edits minimal
