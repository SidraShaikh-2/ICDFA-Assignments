# Evidence Index — ACICP302 Module 1 Practical

**Learner:** Sidra Shaikh · **Student ID:** C11/26/ACIS/17349
**Repository:** https://github.com/SidraShaikh-2/ICDFA-Assignments → `ACICP302 — ICS Network Security & Attacks/`
**Course source referenced (not my work):** github.com/icdfa/ACICP302ICS-Network-Security-and-Attacks @ `2a66f9bcf253eb3fe31c68ad52794cd535421da8`

## Deliverables
| File | What it is | Activity |
|---|---|---|
| Final report (PDF) | Full write-up, all 10 sections, 27 figures | 00–08 |
| topology.png | Annotated topology / data-flow diagram | 01 |
| EVIDENCE_LOG.md | Chronological action log (this evidence) | all |
| EVIDENCE_INDEX.md | This index | all |
| evidence/03-normal-modbus.pcapng | Loopback Modbus capture (sha256 9c1c38906f3221ed…) | 03 |
| evidence/events.jsonl | Guard audit log (sha256 71ad4042766211da…) | 05–06 |

## Screenshots (screenshots/)
| Activity | Files |
|---|---|
| 00 Preflight | 00-source-commit, 00-loopback-check, 00-dependencies, 00-port-forwarding-empty, 00-network-disconnected |
| 01 Baseline | 01-plant-running, 01-guard-running, 01-dashboard-direct, 01-dashboard-guarded, 01-baseline-compare-1, 01-baseline-compare-2 |
| 03 Packet analysis | 03-capture-command, 03-decode-as, 03-request, 03-response, 03-wireshark-time, 03-plant-log-match |
| 04 Exposure | 04-listening-ports |
| 06 Validation | 06-T1a-output, 06-T1a-dashboard, 06-T1b-output, 06-T1b-guardlog, 06-events-after-T1, 06-T2a-output, 06-T2a-dashboard, 06-T2b-output, 06-T2b-guardlog, 06-events-after-T2, 06-T3-combined |
| 07 Recovery | 07-ports-closed |

*All artifacts are my own, produced inside my assigned isolated Ubuntu VM on 127.0.0.1.*
