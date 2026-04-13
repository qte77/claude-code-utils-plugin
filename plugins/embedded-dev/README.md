# embedded-dev

Embedded firmware development plugin covering the full compliance-to-traceability lifecycle.

## Skills

| Skill | Phase | Description |
|-------|-------|-------------|
| `checking-compliance` | §1-2 | Generate requirements from CE/FCC/UL standards and device description |
| `implementing-firmware` | §2-3,7 | ESP-IDF/PlatformIO implementation with requirement tags and MISRA-C |
| `tracing-requirements` | §4-5 | Validate SYS→PRD→SW requirement chain, DB-vs-code reconciliation |
| `auditing-pcb-design` | standalone | KiCad DRC/ERC, gerber export, BOM generation |

## Pipeline

The skills form a lifecycle pipeline. Each skill's output feeds the next:

```
checking-compliance → implementing-firmware → tracing-requirements
                      auditing-pcb-design (standalone)
```

## SessionStart Hook

On session start, if `gcc` is found in `$PATH` and `.claude/settings.local.json`
does not exist, the plugin deploys embedded toolchain permissions (gcc, cppcheck,
clang-tidy, clang-format, sqlite3, doxygen) via copy-if-not-exists.

## Install

```bash
claude plugin install embedded-dev@qte77-claude-code-plugins
```
