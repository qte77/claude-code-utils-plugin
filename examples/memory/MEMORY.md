# Claude Code Memory

Cross-repo working patterns for AI coding agent workflows.

## Git Conventions

- **Protected mains** — always feature branches + PRs
- **Squash merge**: `PR <conventional-commit-title> (#NUM)`, branch commits in body
- **Push**: `git push origin <branch-name>` (never `HEAD` or bare)
- **`gh pr edit` broken** (Projects Classic deprecation) — use GraphQL `updatePullRequest` mutation
- **Squash merge via API**:
  ```bash
  gh api repos/OWNER/REPO/pulls/NUM/merge -X PUT \
    -f merge_method=squash \
    -f commit_title="PR <title> (#NUM)" \
    -f commit_message="$(git log origin/main..HEAD --format='* %s')"
  ```

## Codespaces Auth

- `GH_PAT` secret (fine-grained) — lacks `createRepository` scope (use classic PAT for that)
- External repo push: `git remote set-url origin "https://USER:${GH_PAT}@github.com/..."` → push → clean URL
- Override Codespaces token: `GITHUB_TOKEN="" GH_TOKEN="${GH_PAT}" gh pr create/gh api`

## Claude Code Sandbox

- Network sandbox ON, filesystem relaxed (container isolation)
- SOT: `~/.claude/settings.json` — `additionalDirectories` + `allowWrite`
- `.claude/skills/` is write-denied (`denyWithinAllow`) — use Edit/Write tools, not git
- Settings require session restart (no hot-reload)

## Ralph

- Template submodule (`.ralph-template/`) is SOT for scripts; local `ralph/` is project-specific
- Frontmatter files (agent-consumed): TODO.md, CONTRIBUTING.md, docs/LEARNINGS.md, docs/FAILURE_MODES.md
- Signature extraction: `lib/extract_signatures.py` (Python `ast`), `SNAPSHOT_SIG_LIMIT` env var
- GitHub auto-deletes remote branches on squash merge

## References

- [claude-cowork-api.md](claude-cowork-api.md) — Skills API, Workspaces Admin API, plugin architecture
