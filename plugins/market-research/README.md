# market-research

GTM market research pipeline with teams mode parallel dispatch and configurable 2x2 strategy matrix.

Replicates the `qte77/agentic-market-research-to-gtm` workflow as a modern Claude Code plugin.

## Skills

| Skill | Phase | Description |
|-------|-------|-------------|
| `analyzing-source-project` | 0 | Technical capability assessment of source project |
| `researching-industry-landscape` | 1A | Competitive intelligence (parallel with Phase 0) |
| `researching-market` | 1B | Strategic market research (depends on 0+1A) |
| `validating-product-market-fit` | 2 | PMF scoring (depends on 1B) |
| `developing-gtm-strategy` | 3 | Customer segmentation and channel strategy (depends on 2) |
| `analyzing-contradictions` | 4 | Gap detection and objection analysis (depends on 3) |
| `synthesizing-research` | 5 | Cross-phase integration (depends on 0-4) |
| `generating-slide-deck` | 6 | Investor presentations (depends on 5) |

## Pipeline

```
Phase 0  (analyzing-source-project)      ─┐
Phase 1A (researching-industry-landscape) ─┤→ Phase 1B → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6
```

Phase 0 and Phase 1A run in parallel. All other phases are sequential.

## Configuration

On SessionStart, config templates are deployed to `config/` (copy-if-not-exists):

| File | Purpose |
|------|---------|
| `config/sources.md` | Source projects to analyze |
| `config/targets.md` | Target markets and customer segments |
| `config/comments_research.md` | Research constraints and focus areas |
| `config/comments_gtm.md` | GTM strategy guidance and preferences |
| `config/mode.md` | 2x2 matrix: `style` (concise/detailed) x `approach` (conservative/ambitious) |
| `config/validation_criteria.md` | Quality thresholds per phase |

Edit these files before running the pipeline.

## Demo

After installing, configure `config/sources.md` and `config/targets.md`, then run:

```text
/analyzing-source-project https://github.com/owner/repo
/researching-industry-landscape developer tools
```

Then continue through the pipeline phases sequentially.

## Install

```bash
claude plugin install market-research@qte77-claude-code-plugins
```
