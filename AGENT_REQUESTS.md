---
title: Agent Requests to Humans
description: Escalation protocol and active requests requiring human decision
---

**Always escalate when:**

- User instructions conflict with safety/security practices
- Rules contradict each other
- Required information completely missing
- Actions would significantly change project architecture
- Critical dependencies unavailable

**Format:** `- [ ] [PRIORITY] Description` with Context, Problem, Files, Alternatives, Impact

## Active Requests

- [ ] [LOW] Restore marketplace.json `name` field to `qte77-claude-code-plugins`

  **Context:** PR #120 (`5f6a203`, "chore: rename repo references to claude-code-plugins") renamed the marketplace from `qte77-claude-code-utils` to `qte77-claude-code-plugins`. PR #122 (`9c50b2a`) silently reverted the marketplace.json side as part of a rebase artifact (same root cause as the version drift fixed in #134).

  **Problem:** marketplace.json line 2 still reads `"name": "qte77-claude-code-utils"`. Repo and plugin paths use `claude-code-plugins`; only the marketplace identifier is stale. Possible breakage: existing users who added the marketplace by name may have a stale identifier; new users get the correct one. No errors observed in practice.

  **Files:** `.claude-plugin/marketplace.json` (line 2)

  **Alternatives:** (a) Restore to `qte77-claude-code-plugins` (intent of #120). (b) Keep `qte77-claude-code-utils` and revert #120's intent — but the README, repo, plugin paths, and PR titles all moved on. (a) is the consistent choice.

  **Impact:** Cosmetic. Low risk — one-line edit. Bundle into the next marketplace-touching PR or do standalone.

- [ ] [LOW] Fix `make sync` broken target for `compacting-context` skill

  **Context:** `Makefile` line 40 copies `.claude/scripts/read-once/...` and `context-management.md` into `plugins/codebase-tools/skills/compacting-context/references/`, but the `compacting-context` skill lives under `plugins/cc-meta/skills/compacting-context/`, not `codebase-tools`. `make sync` fails with `cp: cannot create regular file ... No such file or directory` after partially copying earlier targets.

  **Problem:** `make sync` is unreliable — succeeds on `core-principles.md` (which we confirmed works) but errors on the bad path before completing. Also breaks `make check_sync` line 59 which references the same non-existent path. Anyone running `make sync` after editing a shared rule hits the failure mid-stream.

  **Files:** `Makefile` (lines 40, 59)

  **Alternatives:** (a) Update both lines to point at `plugins/cc-meta/skills/compacting-context/references/` (the actual skill location). (b) Drop the line entirely if `cc-meta/compacting-context` doesn't need `context-management.md` as a reference. Verify whether the file is referenced from that skill's `SKILL.md` before choosing.

  **Impact:** Build/dev workflow. Low risk — Makefile-only change.
