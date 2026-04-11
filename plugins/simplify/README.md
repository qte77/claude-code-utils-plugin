# simplify

Post-review, pre-commit simplification pass. Reviews changed code for
opportunities to simplify — reuse, quality, efficiency.

## Workflow Position

```
implement → test → review → simplify → commit
```

Complements language-specific review skills by focusing specifically on
KISS/DRY/YAGNI enforcement.

## Skills

| Skill | Description |
|---|---|
| `simplifying-code` | Review recent changes for simplification opportunities |

## Usage

```
/simplify              # Review staged changes
/simplify src/foo.py   # Review specific file
```
