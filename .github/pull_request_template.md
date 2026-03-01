# Summary

<!-- Brief description of what this PR does and why -->

Closes <!-- #issue-number or N/A -->

## Type of Change

<!-- Check all that apply. Commit type must match .gitmessage: feat|fix|build|chore|ci|docs|style|refactor|perf|revert|test -->

- [ ] `feat` — new feature (plugin, skill, hook, command)
- [ ] `fix` — bug fix
- [ ] `docs` — documentation only
- [ ] `refactor` — no functional change
- [ ] `ci` — CI/CD changes
- [ ] `chore` — tooling, config, maintenance
- [ ] `style` — formatting, whitespace (no logic change)
- [ ] `revert` — reverts a previous commit
- [ ] **Breaking change** — add `!` after commit type, e.g. `feat!:` or `feat(scope)!:`

## Self-Review

- [ ] I have reviewed my own diff and removed debug/dead code
- [ ] Commit messages follow [`.gitmessage`](../.gitmessage) format: `type[(scope)][!]: description`

## Testing

- [ ] `make validate` passes (plugin structure + JSON syntax)
- [ ] `make test_install` passes (all plugins install standalone, no broken symlinks)
- [ ] `make check_sync` passes (shared references in sync with SoT)

## Documentation

- [ ] [`CHANGELOG.md`](../CHANGELOG.md) updated under `## [Unreleased]` using correct section type:
  `Added` · `Changed` · `Deprecated` · `Removed` · `Fixed` · `Security`
- [ ] [`LEARNINGS.md`](../LEARNINGS.md) updated if a new pattern or gotcha was discovered
- [ ] Plugin README updated if skills, hooks, or deployed files changed
