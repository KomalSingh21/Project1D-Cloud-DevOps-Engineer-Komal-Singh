# Audit Evidence Package Index

## Evidence package structure

```text
audit-evidence/
├── 01-governance/
├── 02-architecture/
├── 03-identity-and-access/
├── 04-network-segmentation/
├── 05-secrets-and-encryption/
├── 06-image-and-workload-security/
├── 07-logging-and-monitoring/
├── 08-incident-response/
├── 09-availability-and-recovery/
└── 10-validation-reports/
```

## Evidence register

| ID | Evidence | Source | Owner | Status |
|---|---|---|---|---|
| EV-001 | Repository privacy and branch protection screenshot | Repository settings | Repository owner | To collect |
| EV-002 | HA cluster and namespace architecture | `docs/architecture/` | Platform engineering | Prepared |
| EV-003 | RBAC matrix and `kubectl auth can-i` output | `docs/security/rbac-matrix.md` | IAM owner | Test pending |
| EV-004 | NetworkPolicy manifests and deny/allow test results | `k8s/network-policies/` | Network security | Test pending |
| EV-005 | Vault policies and injection evidence | `k8s/vault/` | Secrets owner | Test pending |
| EV-006 | Trivy reports and signed-image verification | CI artifacts | Supply-chain owner | Integration pending |
| EV-007 | PSS labels and rejected privileged workload test | `k8s/pod-security/` | Platform security | Test pending |
| EV-008 | API audit policy and retained audit event sample | `k8s/audit/` | Platform security | Configuration pending |
| EV-009 | Falco detection and alert routing test | `k8s/falco/` | Security operations | Tuning pending |
| EV-010 | mTLS verification and traffic policy test | `k8s/service-mesh/` | Service mesh owner | Test pending |
| EV-011 | B3.3 incident-response tabletop evidence | `docs/security/incident-response-playbook.md` | Incident commander | Exercise pending |
| EV-012 | B3.4 five-times load test report | `docs/operations/platform-operations-runbook.md` | SRE | Test pending |
| EV-013 | Backup and restore test evidence | Operations runbook | Data owner | Test pending |
| EV-014 | YAML validation report | `docs/compliance/yaml-validation-report.md` | Repository owner | Generated during validation |

## B3.5 audit-day response

When the audit team requests evidence:

1. Confirm the request scope and deadline.
2. Map each request to an evidence ID.
3. Export only the minimum necessary evidence.
4. Redact secrets and customer data.
5. Include commit SHA, test date, environment and reviewer.
6. Record gaps honestly as pending, not complete.
7. Track remediation owners and due dates.
