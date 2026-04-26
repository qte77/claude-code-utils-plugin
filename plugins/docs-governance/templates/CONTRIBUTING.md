# Contributing

Technical workflows, coding standards, and command references for this project.
For behavioral rules and decision frameworks, see [AGENTS.md](AGENTS.md).

## Development Setup

<!-- Project-specific setup commands. Common patterns:
- `make setup` — install dev dependencies
- `make setup_claude_code` — install Claude Code CLI
- Document any required env vars or external services
-->

## Testing

<!-- Test framework and commands. Examples:
- `make test_all` — run full test suite
- `make test_single FILE=<path>` — run a specific test
- Coverage thresholds and how to view reports
-->

## Code Style

<!-- Lint and format commands. Examples:
- `make ruff` (Python) / `make fmt` (Go) / `npm run lint` (TS)
- Static type checking command
- Style guide reference (PEP 8, Google style, etc.)
-->

## Pre-commit Checklist

1. <!-- format/lint command -->
2. <!-- type-check command -->
3. <!-- test command -->
4. Update documentation if patterns changed
5. Update CHANGELOG.md for non-trivial changes

## Pull Requests

- **Title**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`)
- **Body**: detailed summary of purpose + test plan checklist
- Link related issues by number
- Provide screenshots for UI changes

## Documentation

- Apply [markdownlint rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- Use ISO 8601 timestamps (`YYYY-MM-DDTHH:MM:SSZ`)
- Update AGENTS.md when introducing new agent patterns
