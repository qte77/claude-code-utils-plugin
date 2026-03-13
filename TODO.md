---
title: "Plugin repo updates for scaffold architecture"
created: 2026-03-09
updated: 2026-03-09
status: draft
target_repo: qte77/claude-code-utils-plugin
tracking: plugin#15
phases: 4
---

**Target repo:** `qte77/claude-code-utils-plugin`
**Tracking issue:** plugin#15
**Depends on:** Nothing — this is the prerequisite for template#7

---

## Context

The `ralph-loop-cc-tdd-wt-vibe-kanban-template` is being refactored to a plugin-based
scaffold architecture (see companion plan: `plan-ralph-plugin-scaffold-refactor.md`).
The template will have zero checked-in skills and no `settings.json` — everything
comes from plugins.

This plan covers the changes needed in the plugin repo to support that.

### Current plugin inventory

| Plugin | Skills | Hooks | Settings |
|--------|--------|-------|----------|
| `workspace-setup` | — | SessionStart → deploy rules, scripts, settings-base.json | `settings-base.json` → `.claude/settings.json` |
| `ralph` | `generating-prd-json-from-prd-md`, `generating-interactive-userstory-md` | — | — |
| `commit-helper` | `committing-staged-with-message` | — | — |
| `codebase-tools` | `compacting-context`, `researching-codebase` | — | — |
| `docs-generator` | `generating-writeup`, `generating-report`, `generating-tech-spec` | SessionStart → prerequisite warnings | Makefile with pandoc recipes |
| `python-dev` | `implementing-python`, `testing-python`, `reviewing-code` | SessionStart → deploy settings.local.json (if uv detected) | `settings.local.json` (uv permissions) |
| `embedded-dev` | `auditing-pcb-design`, `checking-compliance`, `implementing-firmware`, `tracing-requirements` | **NONE** | **NONE** |
| `backend-design` | (designing-backend) | — | — |
| `mas-design` | (designing-mas-plugins, securing-mas) | — | — |
| `website-audit` | (auditing-website-accessibility, auditing-website-usability, researching-website-design) | — | — |
| `workspace-sandbox` | — | (stricter permissions variant) | — |

### What the template currently checks in that must come from plugins

| Template skill | Target plugin | Already in plugin? |
|---------------|---------------|-------------------|
| `committing-staged-with-message` | `commit-helper` | YES |
| `compacting-context` | `codebase-tools` | YES |
| `researching-codebase` | `codebase-tools` | YES |
| `generating-writeup` | `docs-generator` | YES |
| `generating-interactive-userstory-md` | `ralph` | YES |
| `generating-prd-json-from-prd-md` | `ralph` | YES |
| `generating-prd-md-from-userstory-md` | `ralph` | **NO** |
| `implementing-python` | `python-dev` | YES |
| `testing-python` | `python-dev` | YES |
| `reviewing-code` | `python-dev` | YES |
| `designing-backend` | `backend-design` | YES |
| `designing-mas-plugins` | `mas-design` | YES |
| `auditing-website-accessibility` | `website-audit` | YES |
| `auditing-website-usability` | `website-audit` | YES |
| `securing-mas` | `mas-design` | YES |
| `researching-website-design` | `website-audit` | YES |

**Gap:** Only `generating-prd-md-from-userstory-md` is missing from its target plugin.

---

## Execution order

Complete these phases sequentially. Each phase must be fully done before the next.

### Phase 0: Preparation

**0.1** Clone or fork the plugin repo to a working branch.

**0.2** Read the existing plugin structure. Key directories:

```
plugins/
├── embedded-dev/       # Needs hooks + settings (issue #15)
├── ralph/              # Needs 1 missing skill
└── workspace-setup/    # Reference for hook/settings pattern
```

**0.3** Read the reference implementations for hook + settings deployment:

- `plugins/python-dev/hooks/hooks.json` — SessionStart hook config
- `plugins/python-dev/hooks/scripts/setup-python-dev.sh` — copy-if-not-exists script
- `plugins/python-dev/settings/settings.local.json` — language-specific permissions
- `plugins/workspace-setup/hooks/hooks.json` — same pattern for base settings
- `plugins/workspace-setup/hooks/scripts/setup-workspace.sh` — deploys rules, scripts, settings

---

### Phase 1: Add hooks and settings to embedded-dev plugin

This is issue #15.

**1.1** Create `plugins/embedded-dev/settings/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(gcc:*)",
      "Bash(cppcheck:*)",
      "Bash(clang-tidy:*)",
      "Bash(clang-format:*)",
      "Bash(sqlite3:*)",
      "Bash(doxygen:*)",
      "Edit(test/**)",
      "Edit(schema/**)",
      "Edit(hw/**)"
    ]
  }
}
```

NOTE: `Edit(src/**)` is intentionally omitted — already in `workspace-setup`'s
`settings-base.json`. `Edit(test/**)` IS needed because the base only covers
`Edit(tests/)` (Python convention with `s`), while embedded C uses `test/` (no `s`).

**1.2** Create `plugins/embedded-dev/hooks/hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash $CLAUDE_PLUGIN_ROOT/hooks/scripts/setup-embedded-dev.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

**1.3** Create `plugins/embedded-dev/hooks/scripts/setup-embedded-dev.sh`:

```bash
#!/bin/bash
set -euo pipefail

PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
DEPLOYED=()

# Deploy embedded permissions to .claude/settings.local.json (copy-if-not-exists)
if command -v gcc >/dev/null 2>&1; then
  TARGET=".claude/settings.local.json"
  if [ ! -f "$TARGET" ]; then
    mkdir -p .claude
    cp "$PLUGIN_DIR/settings/settings.local.json" "$TARGET"
    DEPLOYED+=("settings: settings.local.json (embedded C permissions)")
  fi
fi

# Report
if [ ${#DEPLOYED[@]} -gt 0 ]; then
  echo "# Embedded Dev Setup"
  echo ""
  echo "Deployed ${#DEPLOYED[@]} file(s):"
  for item in "${DEPLOYED[@]}"; do
    echo "  - $item"
  done
fi
```

**1.4** Verify the final structure:

```
plugins/embedded-dev/
├── .claude-plugin/
├── hooks/
│   ├── hooks.json
│   └── scripts/
│       └── setup-embedded-dev.sh
├── settings/
│   └── settings.local.json
├── skills/
│   ├── auditing-pcb-design/
│   ├── checking-compliance/
│   ├── implementing-firmware/
│   └── tracing-requirements/
└── README.md
```

---

### Phase 2: Add missing skill to ralph plugin

**2.1** Copy the `generating-prd-md-from-userstory-md` skill from the template repo
into the ralph plugin.

Source: template repo `.claude/skills/generating-prd-md-from-userstory-md/`
Target: `plugins/ralph/skills/generating-prd-md-from-userstory-md/`

The skill directory should contain a `SKILL.md` file with YAML frontmatter.

**2.2** Read the existing skills in `plugins/ralph/skills/` to confirm naming and
structure conventions. The new skill must follow the same pattern:

- `SKILL.md` with `name`, `description`, `compatibility`, `metadata` frontmatter
- Consistent model and allowed-tools declarations

**2.3** Verify the final structure:

```
plugins/ralph/skills/
├── generating-interactive-userstory-md/
│   └── SKILL.md
├── generating-prd-json-from-prd-md/
│   └── SKILL.md
└── generating-prd-md-from-userstory-md/
    └── SKILL.md
```

---

### Phase 3: Update READMEs

**3.1** Update `plugins/embedded-dev/README.md`:

Add a "Deployed files" section documenting:

- `settings.local.json` → `.claude/settings.local.json` (copy-if-not-exists, gcc guard)
- SessionStart hook behavior
- Permission list

Follow the format used in `plugins/python-dev/README.md`.

**3.2** Update `plugins/ralph/README.md`:

Add `generating-prd-md-from-userstory-md` to the skills list. Update the description
to reflect the full UserStory → PRD → JSON pipeline.

---

### Phase 4: Validation

**4.1** Install and test embedded-dev plugin in a clean workspace with gcc present:

```bash
# In a workspace with gcc installed
claude plugin install embedded-dev@qte77-claude-code-utils
# Start new session
# Verify: .claude/settings.local.json was deployed with embedded permissions
```

**4.2** Install and test embedded-dev plugin in a workspace WITHOUT gcc:

```bash
# In a workspace without gcc
claude plugin install embedded-dev@qte77-claude-code-utils
# Start new session
# Verify: .claude/settings.local.json was NOT deployed (gcc guard)
```

**4.3** Verify copy-if-not-exists:

```bash
# Create a custom settings.local.json first
echo '{"custom": true}' > .claude/settings.local.json
# Start new session with embedded-dev installed
# Verify: .claude/settings.local.json still contains {"custom": true}
```

**4.4** Test ralph plugin skill:

```bash
claude plugin install ralph@qte77-claude-code-utils
# Verify: /generating-prd-md-from-userstory-md skill is available
```

**4.5** Verify no conflicts between python-dev and embedded-dev:

```bash
# Install both plugins
claude plugin install python-dev@qte77-claude-code-utils
claude plugin install embedded-dev@qte77-claude-code-utils
# Start session with uv present but not gcc
# Verify: only python settings deployed
# Start session with gcc present but not uv
# Verify: only embedded settings deployed
```

---

## File change summary

| Action | File | Notes |
|--------|------|-------|
| CREATE | `plugins/embedded-dev/hooks/hooks.json` | SessionStart hook config |
| CREATE | `plugins/embedded-dev/hooks/scripts/setup-embedded-dev.sh` | Copy-if-not-exists deploy script |
| CREATE | `plugins/embedded-dev/settings/settings.local.json` | Embedded C permission allow-list |
| CREATE | `plugins/ralph/skills/generating-prd-md-from-userstory-md/SKILL.md` | Missing skill — completes the Ralph pipeline |
| MODIFY | `plugins/embedded-dev/README.md` | Document deployed files and hook behavior |
| MODIFY | `plugins/ralph/README.md` | Add new skill to documentation |

---

## Design notes

### settings.local.json single-target conflict

Both `python-dev` and `embedded-dev` deploy to `.claude/settings.local.json`.
The copy-if-not-exists pattern means whichever plugin's hook runs first in a session
where both tools are detected wins. This is acceptable because:

1. Only one scaffold is active at a time in practice
2. The template's `make setup_scaffold` cleans `settings.local.json` on switch
3. A future `settings.d/` directory pattern could support merging if Claude Code
   adds support

### Scope boundary

This plan covers ONLY the plugin repo changes. It does NOT cover:

- Template repo refactor (see `plan-ralph-plugin-scaffold-refactor.md`)
- New plugins (no new plugins are created)
- Changes to `workspace-setup`, `python-dev`, `codebase-tools`, `commit-helper`,
  or `docs-generator` — all required skills already exist in these plugins
