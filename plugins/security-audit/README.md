# security-audit

Code security auditing plugin with three skills for repo-wide audits. For diff-scoped security review, use Claude Code's built-in `/security-review` command instead.

## Skills

- **auditing-code-security** — OWASP Top 10 vulnerability audit with structured findings
- **scanning-dependencies** — Dependency vulnerability scanning, license compliance, supply chain risk
- **detecting-secrets** — Secrets and credential detection across files and git history

## Install

```bash
claude plugin install security-audit@qte77-claude-code-plugins
```
