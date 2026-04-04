# GHA Marketplace Checklist

**First-party references:**

- [Creating a composite action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action) — official guide for `runs: using: composite`
- [Publishing actions to GitHub Marketplace](https://docs.github.com/en/actions/sharing-automations/creating-actions/publishing-actions-in-github-marketplace) — Marketplace listing requirements, branding, and publish flow
- [Git Database API (create commits)](https://docs.github.com/en/rest/git/commits?apiVersion=2022-11-28#create-a-commit) — the API behind the signed commit pattern (blob→tree→commit)

## Required action.yaml Fields

```yaml
name: My Unique Action Name        # Must be unique on Marketplace
description: What this action does  # Shown in search results
branding:
  icon: zap                        # Feather icon name (feathericons.com)
  color: blue                      # white/yellow/blue/green/orange/red/purple/gray-dark
inputs:
  my-input:
    description: Input description
    required: true
runs:
  using: composite
  steps:
    - shell: bash
      run: echo "hello"
```

## README Requirements

- Usage example with pinned major version (`uses: owner/repo@v1`)
- Inputs table (name, description, required, default)
- Version badge: `![Version](https://img.shields.io/github/v/release/owner/repo)`

## Standard Action Pins

```yaml
actions/checkout@v6
actions/setup-python@v6
callowayproject/bump-my-version@1.3.0
astral-sh/setup-uv@v6
```

## Signed Commit Pattern (blob→tree→commit→branch→PR→squash)

```bash
# 1. Create blob for each file
BLOB=$(gh api repos/OWNER/REPO/git/blobs \
  -f encoding=base64 \
  -f "content=$(base64 -w0 < path/to/file)" \
  --jq '.sha')

# 2. Get base tree SHA
BASE_TREE=$(gh api repos/OWNER/REPO/git/ref/heads/BRANCH --jq '.object.sha' | \
  xargs -I{} gh api repos/OWNER/REPO/git/commits/{} --jq '.tree.sha')

# 3. Create tree
TREE=$(gh api repos/OWNER/REPO/git/trees \
  -f "base_tree=$BASE_TREE" \
  -F "tree[][path]=path/to/file" \
  -F "tree[][mode]=100644" \
  -F "tree[][type]=blob" \
  -F "tree[][sha]=$BLOB" \
  --jq '.sha')

# 4. Create commit (GitHub signs it server-side)
PARENT=$(gh api repos/OWNER/REPO/git/ref/heads/BRANCH --jq '.object.sha')
COMMIT=$(gh api repos/OWNER/REPO/git/commits \
  -f "message=feat: my change" \
  -f "tree=$TREE" \
  -F "parents[]=$PARENT" \
  --jq '.sha')

# 5. Update branch ref
gh api repos/OWNER/REPO/git/refs/heads/BRANCH \
  -X PATCH -f sha="$COMMIT"

# 6. Create PR and squash merge
gh pr create --title "feat: my change" --body "..."
GH_TOKEN="${GH_PAT}" gh pr merge NUM --squash \
  --subject "PR feat: my change (#NUM)" \
  --body "* feat: my change"
# Note: GITHUB_TOKEN from Codespaces lacks merge permission; use PAT.
```

## Version Tags

```bash
# After release, create floating major tag
git tag -f v1 v1.2.3
git push origin v1 --force
```

With `bump-my-version` (use `commit=false tag=false` — let the workflow tag):

```toml
[tool.bumpversion]
commit = false
tag = false
```

## Gotchas

- **Ghost ref state**: if a tag push fails mid-flight, use a fresh tag name
- **`GITHUB_TOKEN` can't push `.github/workflows/`** — needs `workflow` scope PAT
- **Workflows disabled after 60 days inactivity** — re-enable via Actions tab
- **`bump-my-version` always increments** — for first release, create tag manually via API
- **Marketplace publish**: must check the box on the GitHub Release page; can't be done via API
- **Blob overflow**: for large CSVs/generated files exceeding API payload, write to temp file, base64-encode, use `--input` with jq rawfile:
  ```bash
  base64 -w0 < large.csv > /tmp/blob.b64
  gh api repos/OWNER/REPO/git/blobs \
    --input <(jq -n --rawfile b /tmp/blob.b64 '{encoding:"base64",content:$b}') \
    --jq '.sha'
  ```
- **S310 pattern**: for Python actions using `urllib.request.urlopen()`, add an `_ensure_https()` guard function that validates URL scheme before opening, then annotate with `# noqa: S310`
- **Merge via `gh api` silently drops `.github/workflows/`**: use `gh pr merge N --squash` instead — the REST API merge endpoint silently drops workflow file changes

## Security Settings API

```bash
# Set workflow permissions to read-only + allow PR creation
gh api repos/OWNER/REPO/actions/permissions/workflow -X PUT \
  -f default_workflow_permissions=read \
  -F can_approve_pull_request_reviews=true
```

## Publish Steps

1. Repo must be public
2. `action.yaml` must be in repo root with `name`, `description`, `branding`
3. Create GitHub Release (not just a tag)
4. On Release creation page: check "Publish this Action to the GitHub Marketplace"
5. Select primary category (required), optional secondary category
