---
title: Compliance Standards Reference
description: >-
  Regulatory directives and harmonized standards for embedded
  device certification in EU and US markets
created: 2026-03-01
category: reference
version: 1.0.0
see-also: requirement-hierarchy.md
---

# Compliance Standards Reference

## EU Directives

### Low Voltage Directive (LVD) — 2014/35/EU

Applies to electrical equipment with voltage 50-1000V AC or 75-1500V DC.

**Harmonized standard:** IEC 62368-1:2023 (Ed. 3) — Audio/video, information and communication technology equipment — Safety requirements.

Key clauses:

- §5.2: Electrically-caused injury
- §5.3: Electrically-caused fire
- §5.4: Hazardous substances
- §6: Mechanical hazards
- §7: Thermal hazards
- §9: Radiation hazards

### EMC Directive — 2014/30/EU

Applies to all electrical/electronic equipment that may generate or be affected by electromagnetic disturbance.

**Harmonized standards:**

- **EN 55032:2015+A1:2020** — Electromagnetic compatibility of multimedia equipment — Emission requirements
  - Class A: Commercial/industrial environment
  - Class B: Residential environment (stricter)
  - Tests: Conducted emissions (150 kHz–30 MHz), radiated emissions (30 MHz–6 GHz)
- **EN 55035:2017+A11:2020** — Electromagnetic compatibility of multimedia equipment — Immunity requirements
  - ESD immunity (IEC 61000-4-2)
  - Radiated immunity (IEC 61000-4-3)
  - EFT/burst (IEC 61000-4-4)
  - Surge (IEC 61000-4-5)

### Radio Equipment Directive (RED) — 2014/53/EU

Applies to equipment that intentionally transmits/receives radio waves (Wi-Fi, Bluetooth, Zigbee, LoRa, cellular).

**Harmonized standards:**

- ETSI EN 300 328 (2.4 GHz wideband)
- ETSI EN 301 893 (5 GHz RLAN)
- ETSI EN 303 345 (broadcast receivers)
- EN IEC 62311:2020 (EMF human exposure)

### RoHS — EU 2011/65/EU (Recast 2023)

Restriction of hazardous substances. Maximum concentration values:

| Substance | Limit |
|-----------|-------|
| Lead (Pb) | 0.1% |
| Mercury (Hg) | 0.1% |
| Cadmium (Cd) | 0.01% |
| Hex. chromium (Cr6+) | 0.1% |
| PBB | 0.1% |
| PBDE | 0.1% |
| DEHP, BBP, DBP, DIBP | 0.1% each |

### REACH — EU 1907/2006

Registration, Evaluation, Authorization and Restriction of Chemicals. Applies when device contains substances on the SVHC Candidate List above 0.1% w/w.

## US Regulations

### UL 62368-1:2019

US-harmonized version of IEC 62368-1 for the North American market. Published by UL (Underwriters Laboratories). NRTL certification required for market access.

### FCC Part 15 — 47 CFR §15

Unintentional radiators (all digital devices):

- §15.107: Conducted emission limits
- §15.109: Radiated emission limits
- Class A: Commercial, industrial, or business environment
- Class B: Residential (stricter, equivalent to EU Class B)

Intentional radiators (devices with radio transmitters):

- §15.247: Spread spectrum (2.4 GHz, 5.8 GHz)
- §15.407: UNII bands (5 GHz)

## Decision Matrix

```
Device has radio? ──► YES ──► RED (EU) + FCC Part 15.247+ (US)
       │
       NO
       │
       ▼
Powered by mains? ──► YES ──► LVD + EMC (EU) + UL + FCC Class B (US)
       │
       NO (battery only, <50V)
       │
       ▼
       EMC only (EU) + FCC Class B (US)

Always applicable: RoHS + REACH (EU)
```

## References

- [EU Blue Guide 2022 — Implementation of EU product rules](https://single-market-economy.ec.europa.eu/single-market/goods/blue-guide_en)
- [FCC Equipment Authorization](https://www.fcc.gov/engineering-technology/laboratory-division/general/equipment-authorization)
- [IEC 62368-1 overview](https://www.iec.ch/homepage)
