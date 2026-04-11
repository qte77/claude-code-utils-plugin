---
name: detecting-secrets
description: Detect hardcoded secrets, API keys, tokens, and credentials in code and git history. Use when auditing for leaked secrets or before publishing code.
compatibility: Designed for Claude Code
metadata:
  allowed-tools: Read, Grep, Glob, Bash
  argument-hint: [file-or-directory]
  stability: stable
---

# Secrets and Credential Detection

**Scope**: $ARGUMENTS

## When to Use

- Pre-publish audit (open-sourcing, npm publish, Docker push)
- Reviewing PRs for accidental credential commits
- Periodic security sweep
- Post-incident secret rotation verification

## Workflow

1. **Scan files** for secret patterns (see detection rules)
2. **Check configuration files** (.env, config, YAML, JSON)
3. **Inspect git history** for previously committed secrets
4. **Classify findings** by type and severity
5. **Recommend remediation** (rotate, revoke, remove)

## Detection Patterns

### API Keys and Tokens

- [ ] AWS access keys (`AKIA[0-9A-Z]{16}`)
- [ ] AWS secret keys (`[0-9a-zA-Z/+]{40}` near AWS context)
- [ ] GCP service account keys (JSON with `"type": "service_account"`)
- [ ] GCP API keys (`AIza[0-9A-Za-z_-]{35}`)
- [ ] Azure connection strings (`DefaultEndpointsProtocol=`)
- [ ] GitHub tokens (`ghp_`, `gho_`, `ghu_`, `ghs_`, `ghr_`)
- [ ] GitLab tokens (`glpat-`)
- [ ] Slack tokens (`xoxb-`, `xoxp-`, `xoxs-`)
- [ ] Stripe keys (`sk_live_`, `pk_live_`, `rk_live_`)
- [ ] Generic API key patterns (`api[_-]?key`, `apikey`, `api[_-]?secret`)

### Private Keys

- [ ] RSA private keys (`-----BEGIN RSA PRIVATE KEY-----`)
- [ ] EC private keys (`-----BEGIN EC PRIVATE KEY-----`)
- [ ] OpenSSH private keys (`-----BEGIN OPENSSH PRIVATE KEY-----`)
- [ ] PGP private keys (`-----BEGIN PGP PRIVATE KEY BLOCK-----`)
- [ ] PKCS8 keys (`-----BEGIN PRIVATE KEY-----`)

### Passwords and Credentials

- [ ] Hardcoded passwords (`password\s*=\s*["'][^"']+["']`)
- [ ] Database connection strings with credentials (`://user:pass@`)
- [ ] JDBC URLs with passwords
- [ ] `.env` files with secrets committed to repo
- [ ] `.netrc` / `.pgpass` / `.my.cnf` with credentials

### JWT and Session Secrets

- [ ] JWT signing secrets in code (`jwt.sign`, `JWT_SECRET`)
- [ ] Session secrets (`SESSION_SECRET`, `SECRET_KEY`)
- [ ] Cookie signing keys
- [ ] Encryption keys in plaintext

## High-Risk File Patterns

Prioritize scanning these locations:

- `.env`, `.env.*` (should be gitignored)
- `config/`, `settings/`, `secrets/`
- `docker-compose*.yml` (environment sections)
- `*.tfvars`, `terraform.tfstate`
- CI configs (`.github/workflows/`, `.gitlab-ci.yml`)
- `Dockerfile` (ENV and ARG with secrets)

## Git History Scan

Check for secrets in past commits:

- [ ] Search commit diffs for secret patterns
- [ ] Check for `.env` files added then removed
- [ ] Look for reverted commits that contained secrets
- [ ] Verify `.gitignore` covers sensitive file patterns

**Note**: Secrets in git history remain accessible even after removal from
HEAD. If found, the secret must be rotated regardless.

## Output Format

| # | Type | Severity | File:Line | Pattern Match | Remediation |
|---|------|----------|-----------|---------------|-------------|
| 1 | AWS Key | Critical | `.env:3` | `AKIA...` | Rotate in IAM, add to .gitignore |
| 2 | Private Key | Critical | `certs/key.pem` | RSA key | Remove, regenerate, gitignore |
| 3 | DB Password | High | `config/db.yml:12` | `password: hunter2` | Move to env var |
| 4 | JWT Secret | High | `src/auth.js:8` | `SECRET = "..."` | Move to env var |

### Severity Definitions

- **Critical** — Active credential that grants external access (cloud, API, DB)
- **High** — Secret that could enable access if combined with other info
- **Medium** — Internal-only credential or test/dev secret in prod path
- **Low** — Potential false positive or non-sensitive token pattern

### Remediation Steps

For every confirmed secret:

1. **Rotate** — Generate new credentials immediately
2. **Revoke** — Invalidate the exposed credential
3. **Remove** — Delete from codebase and git history if needed
4. **Prevent** — Add pattern to `.gitignore` and pre-commit hooks
