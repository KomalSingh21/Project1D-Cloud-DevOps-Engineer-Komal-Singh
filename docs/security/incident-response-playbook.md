# FinServ Digital — Security Incident Response Playbook

## Scenario

A Pod in a development namespace is compromised and attempts to:

1. scan the internal network;
2. read Secrets from production;
3. exfiltrate data to an external IP.

This is B3.3.

## Detection and containment matrix

| Attack action | Preventive control | Detection | Response |
|---|---|---|---|
| Internal network scan | NetworkPolicy | Falco process/network alert | isolate Pod/workload |
| Read production Secrets | Cluster separation + RBAC | API audit / access-denied evidence | disable identity and preserve evidence |
| External exfiltration | Egress NetworkPolicy | Falco + network telemetry | block egress and isolate workload |

## Phase 1 — Detect

1. Confirm Falco alert.
2. Identify cluster, namespace, Pod and ServiceAccount.
3. Query Kubernetes audit logs for related API actions.
4. Preserve timestamps and alert identifiers.
5. Do not delete the workload before evidence is collected unless active impact requires immediate containment.

## Phase 2 — Contain

- Apply the emergency isolation NetworkPolicy.
- Scale the compromised deployment to zero if required by the incident commander.
- Disable/revoke compromised workload identity.
- Block suspicious external destination.
- Confirm the attacker cannot reach production.

## Phase 3 — Eradicate

- Identify the vulnerable image/version.
- Remove compromised image from approved deployment paths.
- Rebuild from a clean source revision.
- Scan and sign the replacement image.
- Redeploy through normal admission controls.
- Rotate any credentials potentially exposed.

## Phase 4 — Recover

- Restore service using the approved image digest.
- Validate NetworkPolicy and RBAC.
- Confirm Vault secret rotation where applicable.
- Verify Falco and audit telemetry.
- Monitor the workload closely after restoration.

## Phase 5 — Lessons learned

Record:
- initial access vector
- affected workload
- controls that blocked the attack
- controls that only detected it
- false positives
- missing telemetry
- remediation owners
- policy changes

## Expected outcome

A compromised development Pod should not be able to:
- read production Kubernetes Secrets;
- communicate freely with production workloads;
- freely reach arbitrary external destinations.

The architecture therefore relies on multiple independent controls rather than Falco alone.
