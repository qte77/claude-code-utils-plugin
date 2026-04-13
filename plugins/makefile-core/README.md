# makefile-core

Skills and linting for consistent, rigorous Makefiles across projects.

## Skills

- `creating-makefile` — Scaffold or review Makefiles following org conventions. Auto-detects project type from the working directory and reads the matching `scaffold-*.md` reference for language-specific recipes.

## References

- `makefile-conventions.md` — Required structure, naming, and patterns
- `lint-makefile.sh` — Bash linter for CI enforcement
- `scaffold-*.md` — Language-specific recipe templates (shipped examples; not exhaustive — the skill works for any project type by applying conventions from first principles)

## Usage

```bash
# In Claude Code
/creating-makefile              # auto-detects project type from cwd
/creating-makefile python       # override detection with explicit type
/creating-makefile ~/my-project # target a specific directory

# Standalone lint
bash plugins/makefile-core/skills/creating-makefile/references/lint-makefile.sh
```

## Extending

To add a new project type, drop a `scaffold-<type>.md` file into `references/`. No changes to SKILL.md needed. The scaffold should provide:

1. Config variables (quiet flags, tool paths)
2. Recipes grouped under `# MARK:` sections (SETUP, DEV, at minimum)
3. A notes section with tool-specific caveats

See existing `scaffold-*.md` files for the pattern.

## Install

```bash
claude plugin install makefile-core@qte77-claude-code-plugins
```
