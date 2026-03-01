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

## Install

```bash
/plugin install embedded-dev@qte77-claude-code-utils
```
