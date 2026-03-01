---
title: CC Plugin Development — What to Expect and Watch Out For
source: Official docs, ecosystem research, hands-on audit
purpose: General reference for building Claude Code plugins — structure, patterns, pitfalls, and ecosystem lessons learned.
created: 2026-03-01
references:
  - https://github.com/anthropics/claude-code/blob/main/plugins/README.md
  - https://github.com/anthropics/claude-plugins-official
  - https://code.claude.com/docs/en/plugins
  - https://github.com/yeachan-heo/oh-my-claudecode
  - https://github.com/affaan-m/everything-claude-code
  - https://github.com/hesreallyhim/awesome-claude-code
  - https://github.com/ChrisWiles/claude-code-showcase
---

## Plugin Directory Structure

Every plugin lives under a single root directory with a required manifest.

```text
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required — name, version, description
├── commands/                 # Slash commands (user-invoked, .md files)
├── agents/                   # Subagent definitions (.md files)
├── skills/                   # Agent skills (subdirs with SKILL.md)
│   └── skill-name/
│       ├── SKILL.md          # Required per skill
│       └── references/       # Optional supporting docs
├── hooks/
│   └── hooks.json            # Event handler config
├── scripts/                  # Helper scripts for hooks/commands
├── .mcp.json                 # MCP server definitions
└── README.md                 # Plugin documentation (expected)
```

All component directories sit at plugin root — not nested inside `.claude-plugin/`.

## The Five Component Types

### Commands — User-Invoked Entry Points

Single `.md` files in `commands/`. Show up in the `/` menu. Primary way users discover and trigger plugin functionality.

```yaml
---
description: Short description shown in menu
argument-hint: "[file-path]"
---
Instructions for Claude when this command is invoked.
```

Watch out for:

- Commands without skills behind them duplicate logic — prefer wrapping skills
- Missing `argument-hint` makes commands less discoverable
- `$1`, `$2` etc. reference positional arguments from the user

### Skills — Auto-Invoked Knowledge Modules

Each skill lives in `skills/skill-name/SKILL.md`. Claude activates them automatically when the task matches the skill description.

```yaml
---
name: skill-name
description: When to activate (this is the trigger — make it precise)
allowed-tools: Read Grep Glob Edit Write Bash
metadata:
  context: fork        # Isolate from main context window
  agent: Explore       # Run as specific agent type
  model: haiku         # Override model (haiku/sonnet)
  argument-hint: "[target]"
  disable-model-invocation: true  # Script-only, no AI reasoning
---
```

Watch out for:

- **Description is the trigger** — vague descriptions cause false activations or missed activations
- `context: fork` is critical for research skills to avoid polluting the main context
- Skills with `references/` subdirectories can bundle supporting docs (symlink for DRY)
- Skills are invisible to users — pair with a command for discoverability

### Agents — Specialized Subprocesses

Single `.md` files in `agents/`. Define system prompts for delegated work. Useful for parallel execution and isolated analysis.

```yaml
---
name: agent-name
description: When Claude should delegate to this agent
model: sonnet
tools: Read Grep Glob Bash WebSearch
color: blue
---
System prompt defining the agent's role and behavior.
```

Watch out for:

- Each agent gets its own context window — lead conversation history does NOT carry over
- Agents load project context (CLAUDE.md, MCP servers, skills) automatically
- Define narrow scope — agents that try to do everything are just worse versions of Claude
- Background agents (`run_in_background: true`) enable parallel work but need clear output contracts

### Hooks — Event-Driven Automation

Configured in `hooks/hooks.json`. Fire on lifecycle events.

```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "bash $CLAUDE_PLUGIN_ROOT/scripts/setup.sh",
        "timeout": 10
      }]
    }]
  }
}
```

Available events:

| Event | Fires When | Common Use |
| --- | --- | --- |
| SessionStart | Session begins | Deploy files, initialize environment |
| SessionEnd | Session ends | Cleanup, summaries |
| PreToolUse | Before any tool call | Safety guardrails, validation |
| PostToolUse | After any tool call | Verification, logging |
| Stop | Claude finishes response | Session learning, iteration loops |
| UserPromptSubmit | User sends a message | Prompt routing, skill suggestion |
| PreCompact | Before context compaction | Save important state |
| Notification | Notification triggered | External integrations |

Watch out for:

- Hook timeouts default low — long-running scripts get killed silently
- `$CLAUDE_PLUGIN_ROOT` resolves to the plugin directory at runtime
- `matcher` filters which tool/event patterns fire the hook (use `"*"` for all)
- SessionStart hooks should be idempotent — use `copy-if-not-exists` patterns
- PreToolUse hooks can block operations — test carefully to avoid breaking workflows
- Prompt-based hooks (type `"prompt"`) inject context without shell scripts

### MCP Servers — External Tool Integration

Defined in `.mcp.json` at plugin root. Makes plugins self-contained with external dependencies.

```json
{
  "mcpServers": {
    "server-name": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@some/mcp-server"]
    }
  }
}
```

Watch out for:

- MCP servers start on plugin load — slow servers delay session start
- Plugins bundling MCP config are more portable than relying on workspace settings
- Not all users will have the MCP server's dependencies installed

## Marketplace Structure

A marketplace is a git repo with `.claude-plugin/marketplace.json` at root.

```json
{
  "name": "marketplace-name",
  "owner": { "name": "author" },
  "metadata": {
    "description": "What this collection provides",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugins/plugin-name",
      "description": "One-line description for browse UI",
      "version": "1.0.0"
    }
  ]
}
```

Watch out for:

- `source` is relative to repo root
- `description` here is what users see when browsing — keep it actionable
- Each plugin needs its own `.claude-plugin/plugin.json` in addition to the marketplace entry

## Patterns That Work Well

### Commands Wrapping Skills

Commands handle discoverability and argument collection. Skills hold the actual logic. This avoids duplication and lets both auto-invocation and manual invocation work.

### Symlinked References for DRY

When multiple skills reference the same best-practices doc, symlink to a single source. Deploy via a shared script that follows symlinks (`cp -L`).

### Non-Destructive SessionStart Deploys

Use `copy-if-not-exists` in setup scripts so hooks never overwrite user customizations:

```bash
[ -f "$target" ] || cp "$source" "$target"
```

### Fork Context for Research Skills

Skills that search, read, or analyze the codebase should use `context: fork` to prevent search noise from polluting the main conversation context.

### Tiered Plugin Categories

Separate infrastructure plugins (hooks, settings, deploy scripts) from domain plugins (skills, commands). Infrastructure plugins set up the workspace; domain plugins provide expertise.

## Common Pitfalls

### Over-Engineering

- Multi-agent swarm orchestration for simple task collections
- Pipeline/workflow chaining when sequential skill invocation suffices
- Continuous learning hooks with unproven value
- Per-plugin statuslines when a shared one works

### Under-Engineering

- No README per plugin — marketplace browsing and `/plugin` discovery rely on it
- Skills without commands — users can't find or invoke them intentionally
- Hardened settings without runtime hooks — static config doesn't catch everything
- Hooks not declared in `plugin.json` — reduces auto-discovery reliability

### Structural Mistakes

- Nesting component directories inside `.claude-plugin/` (must be at plugin root)
- Destructive SessionStart hooks that overwrite user files
- Hook scripts without timeouts that hang the session
- Agents with overly broad scope that duplicate what Claude already does
- Skills with vague descriptions that trigger on the wrong prompts
- Duplicating logic between commands and skills instead of commands wrapping skills

### Context Window Traps

- Research skills without `context: fork` flood the main context with search results
- Large reference docs loaded into skills without summarization
- Verbose hook output that doesn't get compacted
- Agents returning raw dumps instead of structured summaries

## Ecosystem Landscape (as of March 2026)

### Official

- [anthropics/claude-code](https://github.com/anthropics/claude-code/tree/main/plugins) — bundled `plugin-dev` plugin with skill/hook/agent/command development guides
- [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) — curated marketplace directory
- [anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins) — plugins for knowledge workers (Claude Cowork)

### Community

- [oh-my-claudecode](https://github.com/yeachan-heo/oh-my-claudecode) — multi-agent orchestration, swarm mode, pipeline chaining, tiered model routing
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) — broad collection of agents, rules, commands, skills across multiple languages
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) — curated index of plugins, skills, hooks, and tools
- [claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase) — comprehensive example project with all component types and GitHub Actions
- [claude-code-tools](https://github.com/pchalasani/claude-code-tools) — hooks and utilities for programmatic control
- [claude-code-hook-sdk](https://github.com/mizunashi-mana/claude-code-hook-sdk) — TypeScript SDK for type-safe hook development

### Patterns Emerging in the Ecosystem

| Pattern | Who Uses It | Maturity |
| --- | --- | --- |
| Commands wrapping skills | claude-code-showcase, plugin-dev | Established |
| PreToolUse safety guardrails | oh-my-claudecode, Dippy | Established |
| Parallel agent teams | oh-my-claudecode, agent-teams | Experimental |
| Stop hooks for iteration loops | everything-claude-code (Ralph Wiggum) | Experimental |
| Session learning on Stop | everything-claude-code | Experimental |
| UserPromptSubmit skill routing | claude-code-showcase | Experimental |
| Swarm orchestration via SQLite | oh-my-claudecode | Experimental |
| Prompt-based hooks (no scripts) | plugin-dev docs | Established |

## Checklist: Before Publishing a Plugin

- [ ] `plugin.json` has name, version, description, author, keywords
- [ ] README.md documents purpose, installation, usage, and all components
- [ ] Every skill has a precise description (the trigger condition)
- [ ] Research skills use `context: fork`
- [ ] SessionStart hooks are idempotent (won't break on re-run)
- [ ] Hook scripts have appropriate timeouts
- [ ] Commands exist for any skill users should invoke directly
- [ ] No duplicated logic between commands and skills
- [ ] References are symlinked, not copied, across skills
- [ ] `$CLAUDE_PLUGIN_ROOT` used for all internal paths (portability)
