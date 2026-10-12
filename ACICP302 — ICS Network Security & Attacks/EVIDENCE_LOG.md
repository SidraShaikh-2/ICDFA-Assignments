# Evidence Log — ACICP302 Module 1 Practical

**Learner:** Sidra Shaikh · **Student ID:** C11/26/ACIS/17349
**Source commit:** `2a66f9bcf253eb3fe31c68ad52794cd535421da8`
Times are shown as the lab VM clock (one hour ahead of WAT; subtract 1 h for WAT). Lab performed 10 Oct 2026.

| # | VM time | WAT | Activity | Action | Result / observation | Evidence |
|---|---|---|---|---|---|---|
| 1 | 17:06 | 16:06 | 00 | `git rev-parse HEAD` on course source | commit 2a66f9bc… recorded | 00-source-commit.png |
| 2 | 17:07 | 16:07 | 00 | grep for unsafe addrs / 127.0.0.1 in plant_sim | PASS — no unsafe address; all binds loopback | 00-loopback-check.png |
| 3 | 17:08 | 16:08 | 00 | `pip install -r requirements.txt` | LIBRARIES OK, pymodbus 3.6.9 | 00-dependencies.png |
| 4 | 17:08 | 16:08 | 00 | VirtualBox port-forwarding check | list empty | 00-port-forwarding-empty.png |
| 5 | 17:08 | 16:08 | 00 | snapshot clean-ready; disconnect adapter; `ip -br addr` | enp0s3 DOWN, only lo (127.0.0.1) up | 00-network-disconnected.png |
| 6 | 17:23 | 16:23 | 01 | start plant.py | listening 127.0.0.1:5020, telemetry each second | 01-plant-running.png |
| 7 | 17:26 | 16:26 | 01 | start guard.py | listening 127.0.0.1:5021 | 01-guard-running.png |
| 8 | 17:34 | 16:34 | 01 | open dashboards 8080 / 8081 | SYSTEM NORMAL / PROTECTED; log "waiting for attacks" | 01-dashboard-direct.png, 01-dashboard-guarded.png |
| 9 | 17:55–57 | 16:55 | 01 | record baseline, both views | values agree within tolerance; no guard events | 01-baseline-compare-1.png, 01-baseline-compare-2.png |
| 10 | 18:04 | 17:04 | 03 | `dumpcap -i lo -f "tcp port 5020" -a duration:20` | 120 packets captured on loopback | 03-capture-command.png, evidence/03-normal-modbus.pcapng |
| 11 | 18:11 | 17:11 | 03 | Wireshark Decode As 5020 → Modbus/TCP | request/response decoded | 03-decode-as.png |
| 12 | 18:08 | 17:08 | 03 | identify Trans 2459 request + response | Func 3, regs 705/379/655/0 = 70.5°C/37.9bar/65.5/alarm0 | 03-request.png, 03-response.png |
| 13 | 18:11 | 17:11 | 03 | correlate packet to plant log | matches plant log line at 18:07:09 | 03-wireshark-time.png, 03-plant-log-match.png |
| 14 | 18:37 | 17:37 | 04 | `ss -ltn` | all four lab ports bound to 127.0.0.1 only | 04-listening-ports.png |
| 15 | 19:09 | 18:09 | 06 | T1 attack_hold.py 5020 then 5021 | direct 100% unsafe; guarded 0%, "fully contained" | 06-T1a-output.png, 06-T1a-dashboard.png, 06-T1b-output.png |
| 16 | 19:15 | 18:15 | 06 | inspect guard log / events after T1 | blocked: range + step + drift | 06-T1b-guardlog.png, 06-events-after-T1.png |
| 17 | 19:26 | 18:26 | 06 | T2 slow_drift_attack.py 5020 then 5021 | direct clamped ~40; guarded step 1 accepted then blocked | 06-T2a-output.png, 06-T2a-dashboard.png, 06-T2b-output.png, 06-T2b-guardlog.png |
| 18 | 19:29 | 18:29 | 06 | inspect events after T2 | range/step/drift reasons logged | 06-events-after-T2.png |
| 19 | 19:56 | 18:56 | 06 | T3 replay_attack.py 5020 then 5021 | accepted on both paths; no guard events | 06-T3-combined.png |
| 20 | 20:06 | 19:06 | 07 | Ctrl+C all; `ss -ltn` | lab ports 5020/5021/8080/8081 no longer listening | 07-ports-closed.png |
