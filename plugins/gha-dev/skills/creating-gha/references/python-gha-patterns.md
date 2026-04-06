# Python GHA Patterns

Full walkthrough for Python-based composite GitHub Actions using uv.
Based on `gha-biorxiv-stats-action` reference implementation.

## Composite action.yaml

```yaml
name: "My Python Action"
description: "What this action does"
author: "qte77"
branding:
  icon: "zap"
  color: "blue"
inputs:
  MY_INPUT:
    description: "Description of input"
    required: true
runs:
  using: "composite"
  steps:
    - name: Checkout repository
      uses: actions/checkout@v6
      with:
        fetch-depth: 1

    - name: Setup uv
      uses: astral-sh/setup-uv@v6
      with:
        enable-cache: true

    - name: Run action
      shell: bash
      env:
        MY_INPUT: ${{ inputs.MY_INPUT }}
        PYTHONPATH: ${{ github.action_path }}/src
        UV_PROJECT_ENVIRONMENT: ${{ runner.temp }}/.venv
      run: |
        uv sync --frozen --no-dev --project "${{ github.action_path }}"
        uv run --project "${{ github.action_path }}" python "${{ github.action_path }}/src/app.py"
```

### Key patterns

- **`${{ github.action_path }}`** -- resolves to the action's directory (not the
  calling repo's root). Required for `--project` so uv finds pyproject.toml.
- **`UV_PROJECT_ENVIRONMENT`** -- set to `${{ runner.temp }}/.venv` to avoid
  polluting the calling repo's directory.
- **`--frozen --no-dev`** -- install only production deps from lockfile. Never
  run `uv lock` in CI.
- **`PYTHONPATH`** -- set to `${{ github.action_path }}/src` so imports resolve.
- **`enable-cache: true`** -- caches the uv tool and dependency downloads.

## pyproject.toml (PEP 735 dep groups)

```toml
[project]
name = "my-python-action"
version = "0.1.0"
description = "What this action does"
authors = [{ name = "qte77", email = "qte@77.gh" }]
readme = "README.md"
requires-python = ">=3.10"

[dependency-groups]
dev = ["pytest>=8.0", "ruff>=0.9"]

[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["."]

[tool.ruff]
target-version = "py310"
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I", "W"]

[tool.bumpversion]
current_version = "0.1.0"
parse = '(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)'
serialize = ["{major}.{minor}.{patch}"]
commit = false
tag = false
allow_dirty = true
```

### PEP 735 dependency groups

Dev tools go in `[dependency-groups]`, not `[project.optional-dependencies]`:

```toml
[dependency-groups]
dev = ["pytest>=8.0", "ruff>=0.9"]
lint = ["ruff>=0.9"]
```

- `uv sync --frozen` installs all groups (including dev)
- `uv sync --frozen --no-dev` installs only `[project] dependencies`
- `uv sync --frozen --group lint` installs production + lint group

## CI Workflows

### pytest (`.github/workflows/test.yml`)

```yaml
---
name: Tests
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: astral-sh/setup-uv@v6
        with:
          enable-cache: true
      - run: uv sync --frozen
      - run: uv run pytest
...
```

### ruff lint (`.github/workflows/ruff.yml`)

```yaml
---
name: Lint
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: astral-sh/setup-uv@v6
        with:
          enable-cache: true
      - run: uv sync --frozen
      - run: uv run ruff check .
      - run: uv run ruff format --check .
...
```

## File Layout

```
my-python-action/
  action.yaml          # composite action with branding
  pyproject.toml       # PEP 735, ruff, bump-my-version
  uv.lock              # committed, used with --frozen
  src/
    app.py             # entry point
  tests/
    test_app.py        # pytest tests
  .github/workflows/
    test.yml           # pytest CI
    ruff.yml           # ruff lint + format check
  README.md            # usage with @v1, inputs table, version badge
```

## Gotchas

- **Always commit `uv.lock`** -- CI uses `--frozen` which requires a lockfile
- **`UV_PROJECT_ENVIRONMENT`** -- without this, uv creates `.venv` in the
  calling repo's workspace, causing permission and caching issues
- **`FORCE_JAVASCRIPT_ACTIONS_TO_NODE24`** -- set as env var on setup-uv step
  if GitHub runners enforce Node 24 (suppresses deprecation warning)
- **S310 pattern** -- if using `urllib.request.urlopen()`, add `_ensure_https()`
  guard that validates URL scheme before opening, then annotate with `# noqa: S310`
