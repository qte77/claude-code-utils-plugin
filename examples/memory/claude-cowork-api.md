# Claude Cowork & Skills API Reference

## Workspaces (Admin API)

- **Auth**: Admin API key (`sk-ant-admin...`), org admin role required
- **Base**: `https://api.anthropic.com/v1/organizations/workspaces`
- **Endpoints**: `POST /` (create), `GET /` (list), `POST /{id}/archive`, `POST /{id}/members`, `DELETE /{id}/members/{user_id}`
- **Limits**: Max 100 workspaces/org. Resources (Files, Batches, Skills) scoped per workspace.
- **IDs**: `wrkspc_` prefix

## Agent Skills API

- **Beta headers** (all required): `code-execution-2025-08-25`, `skills-2025-10-02`, `files-api-2025-04-14`
- **Endpoints**: `POST /v1/skills` (create), `GET /v1/skills` (list), `GET /v1/skills/{id}` (retrieve), `DELETE /v1/skills/{id}` (delete)
- **Versions**: `POST /v1/skills/{id}/versions`, `GET /v1/skills/{id}/versions`, `DELETE /v1/skills/{id}/versions/{version}`
- **Pre-built skill IDs**: `pptx`, `xlsx`, `docx`, `pdf` (type: `anthropic`)
- **Custom skill IDs**: Generated `skill_01Abc...` (type: `custom`, workspace-scoped)
- **Max 8 skills per Messages API request**
- **Python SDK**: `client.beta.skills.create(display_title=..., files=files_from_dir(...), betas=[...])`
- **Messages API usage**: `container={"skills": [{"type": "anthropic", "skill_id": "xlsx", "version": "latest"}]}` + `tools=[{"type": "code_execution_20250825", "name": "code_execution"}]`
- **Multi-turn**: Reuse container via `response.container.id`
- **Long-running**: Handle `pause_turn` stop reason for continuation

### Skill File Structure

```
my-skill/
├── SKILL.md          # Required (YAML frontmatter: name, description)
├── REFERENCE.md      # Optional, loaded on demand
└── scripts/
    └── analyze.py    # Optional, executed via bash (output only enters context)
```

- `name`: max 64 chars, lowercase + hyphens, no "anthropic"/"claude"
- `description`: max 1024 chars
- Total upload: < 8 MB

## Cowork Plugins

- **Not a REST API** — file-based packages (plugin.json + .mcp.json + skills/ + commands/)
- **Creation**: Plugin Create (built-in Cowork plugin), templates from github.com/anthropics/knowledge-work-plugins, or manual
- **Enterprise**: Private plugin marketplaces via admin "Customize" menu, per-user provisioning, auto-install, private GitHub repo sources
- **Cross-surface**: Work in Cowork + Claude Agent SDK (same file format)
- **Connectors (MCP)**: Google Workspace, DocuSign, Apollo, Salesforce, Slack, etc.

## Surface Availability

| Feature | API | Claude Code | Cowork/claude.ai |
|---------|-----|-------------|------------------|
| Workspaces | Admin API | N/A | Console UI |
| Skills CRUD | /v1/skills | Filesystem .claude/skills/ | Settings upload |
| Skills in messages | container.skills | Automatic | Automatic |
| Plugins | N/A (file-based) | Filesystem | Plugin Create + marketplace |

## Key Docs

- Skills API guide: platform.claude.com/docs/en/build-with-claude/skills-guide
- Skills overview: platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- Workspaces: platform.claude.com/docs/en/build-with-claude/workspaces
- Plugin templates: github.com/anthropics/knowledge-work-plugins
- Open standard: agentskills.io
