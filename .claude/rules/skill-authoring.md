# Skill and Agent Authoring

Constraints for every `plugins/<name>/skills/<skill-name>/SKILL.md` and
`plugins/<name>/agents/<agent-name>.md` file in this repository. Enforced by
issue #103 audit; see `plugins/codebase-tools/skills/hardening-codebase/`
as the canonical skill exemplar and `plugins/codebase-tools/agents/build-error-resolver.md`
as the canonical agent exemplar.

## Tooling pointer

Anthropic publishes [`skill-creator`](https://claude.com/plugins/skill-creator)
(source: [anthropics/skills](https://github.com/anthropics/skills)) as an
**installable plugin** (not bundled by default with Claude Code). It scaffolds
`SKILL.md` + `references/scripts/assets/` subdirs and runs an automated
description-optimization eval loop. Contributors are encouraged to use it for
new skills; this rule **tightens its defaults** for this repo:

- `skill-creator` uses the upstream 500-line soft cap; **this repo caps at 150**.
- `skill-creator` has no `content-hash` or `stability` concept; **this repo
  requires hash regeneration for `stability: stable` skills** (CI-enforced).
- `skill-creator` scaffolds `references/` as canonical pattern; **this repo
  makes it mandatory** (not just default).

## SKILL.md body size

SKILL.md body (everything after the closing frontmatter `---`) MUST stay under
**150 lines**. Upstream Anthropic cap is 500 lines; this repo's tighter target
reflects the large number of skills shipped (shared auto-compaction budget is
~25k tokens across recently-invoked skills, ~5k per skill).

If a skill naturally grows past 150 lines, extract reference material into
`references/*.md` files and replace inline blocks with short pointers:

```markdown
See `references/<file>.md` for <one-line purpose>.
```

Keep in SKILL.md: frontmatter, arguments, when/don't-use, core workflow steps,
quality check. Move to `references/`: lookup tables, code examples, output
templates, detailed checklists, architectural diagrams.

## Descriptions

The `description:` field in frontmatter MUST be:

1. **≤ 250 characters** (Claude Code description budget cap per skill)
2. **Front-loaded with trigger keywords** — start with the verb and domain
   (e.g., "Audit documentation...", "Refactor Python...", "Design MAS plugins..."),
   NOT with generic framing like "Use this skill when..." or "A skill for..."
3. **Concrete and specific** — name the artifacts acted on, not abstract intent

Short descriptions save the shared description budget (~1% of context window,
always loaded for every skill) and improve skill auto-activation matching.

## References subdirectory

Reference files MUST live in `plugins/<name>/skills/<skill-name>/references/`
(plural, lowercase). Inside each file:

- No YAML frontmatter required (existing `mas-design` references use it by
  convention, but `hardening-codebase` and `cc-meta` references do not —
  match the convention of the other reference files already in the same skill
  dir)
- Start with an H1 matching the file's purpose
- Use H2 for sub-sections, H3 for detail
- Include tables and code blocks freely; these files load on demand

## Content-hash regeneration

Skills marked `stability: stable` carry a `content-hash` field in their metadata.
After modifying any stable SKILL.md body, regenerate hashes:

```bash
bash .github/scripts/compute-skill-hashes.sh --update
```

The `verify-skill-hashes` CI workflow blocks PRs with stale hashes.

## Agents convention

Plugin-scoped agents live at `plugins/<name>/agents/<agent-name>.md`. There is
**no** repo-root `.claude/agents/` directory — every agent is plugin-scoped,
parallel to how skills are plugin-scoped.

- **Host plugin selection:** pick an existing plugin whose description
  semantically includes the agent's domain. If none fits, create a new minimal
  plugin. See `plugins/planning/` as the minimum scaffold: `plugin.json`,
  `README.md`, `agents/<name>.md` (no skills required).
- **Frontmatter:** standard Claude Code agent schema (`name`, `description`,
  `tools` array, `model`). Descriptions follow the same ≤ 250 char +
  front-loaded trigger keywords rule as skill descriptions.
- **README `## Agents` section:** every plugin hosting an agent MUST list it in
  its `README.md` under an `## Agents` heading parallel to `## Skills`.
- **Version bump:** adding or modifying an agent bumps the host plugin's
  version in both `plugin.json` and `marketplace.json` (plugin-versioning rule).
- **Cherry-picks from upstream:** include an attribution footer with source URL,
  license, and adaptations. See `plugins/codebase-tools/agents/build-error-resolver.md`
  and `plugins/planning/agents/planner.md` for the template.

The canonical agent exemplar is `plugins/codebase-tools/agents/build-error-resolver.md`.

## Exemplar

`plugins/codebase-tools/skills/hardening-codebase/SKILL.md` (100 lines) is the
canonical skill example: 7-phase workflow inlined, reference material split into
`references/lint-tightening-checklist.md` and `references/review-agents.md`.
Copy its structural layout when creating or refactoring skills.
