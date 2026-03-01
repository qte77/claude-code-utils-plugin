---
title: KiCad CLI Reference
description: >-
  DRC/ERC commands, JSON output schema, gerber export,
  and BOM generation using kicad-cli
created: 2026-03-01
category: reference
version: 1.0.0
---

# KiCad CLI Reference

## Version Detection

```bash
kicad-cli version
# Expected: 8.x or later (CLI introduced in KiCad 8)
```

## Electrical Rules Check (ERC)

Run on schematic files (`.kicad_sch`):

```bash
kicad-cli sch erc \
    --output erc-report.json \
    --format json \
    --severity-all \
    project.kicad_sch
```

### ERC JSON Output Schema

```json
{
  "source": "project.kicad_sch",
  "date": "2026-03-01T12:00:00",
  "kicad_version": "8.0.0",
  "violations": [
    {
      "type": "pin_not_connected",
      "severity": "error",
      "description": "Pin not connected",
      "items": [
        {
          "description": "U1 pin 3 (VCC)",
          "pos": { "x": 100.0, "y": 50.0 },
          "sheet": "root"
        }
      ]
    }
  ],
  "violation_count": 1
}
```

### Common ERC Violations

| Type | Severity | Meaning |
|------|----------|---------|
| `pin_not_connected` | error | Unconnected pin without no-connect flag |
| `pin_conflict` | error | Conflicting pin types on same net |
| `power_pin_not_driven` | error | Power pin without power source |
| `different_unit_value` | warning | Multi-unit component with different values |
| `unresolved_variable` | warning | Text variable not defined |

## Design Rules Check (DRC)

Run on PCB files (`.kicad_pcb`):

```bash
kicad-cli pcb drc \
    --output drc-report.json \
    --format json \
    --severity-all \
    project.kicad_pcb
```

### DRC JSON Output Schema

```json
{
  "source": "project.kicad_pcb",
  "date": "2026-03-01T12:00:00",
  "kicad_version": "8.0.0",
  "violations": [
    {
      "type": "clearance_violation",
      "severity": "error",
      "description": "Clearance violation (0.15mm < 0.20mm required)",
      "items": [
        {
          "description": "Track on F.Cu",
          "pos": { "x": 120.5, "y": 80.3 }
        },
        {
          "description": "Pad of U1",
          "pos": { "x": 120.8, "y": 80.3 }
        }
      ]
    }
  ],
  "unconnected_count": 0,
  "violation_count": 1
}
```

### Common DRC Violations

| Type | Severity | Meaning |
|------|----------|---------|
| `clearance_violation` | error | Copper-to-copper clearance below minimum |
| `track_width` | error | Track narrower than design rule |
| `unconnected_items` | error | Net has unrouted connections |
| `via_annular_width` | error | Via annular ring too small |
| `courtyard_overlap` | error | Component courtyards overlap |
| `silk_overlap` | warning | Silkscreen text overlaps pad |

## Gerber Export

Only export if DRC passes with no errors:

```bash
# Gerber layers
kicad-cli pcb export gerbers \
    --output gerbers/ \
    --layers F.Cu,B.Cu,F.SilkS,B.SilkS,F.Mask,B.Mask,Edge.Cuts,F.Paste,B.Paste \
    project.kicad_pcb

# Drill files
kicad-cli pcb export drill \
    --output gerbers/ \
    --format excellon \
    --drill-origin absolute \
    project.kicad_pcb
```

### Expected Output Files

```
gerbers/
  project-F_Cu.gbr          # Front copper
  project-B_Cu.gbr          # Back copper
  project-F_SilkS.gbr       # Front silkscreen
  project-B_SilkS.gbr       # Back silkscreen
  project-F_Mask.gbr         # Front solder mask
  project-B_Mask.gbr         # Back solder mask
  project-Edge_Cuts.gbr      # Board outline
  project-F_Paste.gbr        # Front paste (stencil)
  project-B_Paste.gbr        # Back paste (stencil)
  project.drl                # Drill file
  project-NPTH.drl           # Non-plated through holes
```

## BOM Export

```bash
kicad-cli sch export bom \
    --output bom.csv \
    --fields "Reference,Value,Footprint,MPN,Manufacturer" \
    project.kicad_sch
```

## References

- [KiCad CLI documentation](https://docs.kicad.org/8.0/en/cli/cli.html)
- [Gerber format specification (Ucamco)](https://www.ucamco.com/en/gerber)
