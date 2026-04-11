---
title: MAS Threat Matrix Template
description: Cross-framework threat mapping template. Maps concerns to ATLAS techniques, MAESTRO layers, NIST functions, and ISO controls.
created: 2026-04-11
category: template
version: 1.0.0
see-also: mas-security.md
---

For each new feature, document threats with cross-framework mapping. Use this matrix as a starting template — add rows for feature-specific concerns.

| Concern | ATLAS Technique | MAESTRO Layer | NIST Function | ISO Control |
| ------- | --------------- | ------------- | ------------- | ----------- |
| Prompt injection | AML.T0051 | L1 Model | MEASURE 2.6 | A.7.3 |
| API credential theft | AML.T0096 | L3 Integration | GOVERN 1.5 | A.8 |
| Log data leakage | AML.T0024 | L4 Monitoring | MAP 3 | A.7.5 |
| Resource exhaustion | — | L5 Execution | MANAGE 2 | A.6.6 |
| Supply chain compromise | AML.T0040 | L6 Environment | MAP 1.6 | A.8 |
| Agent hijacking | AML.T0056 | L7 Orchestration | MEASURE 2.6 | A.6.4 |
| Evaluation bias | AML.T0043 | L2 Agent Logic | MEASURE 2.5 | A.7.4 |
