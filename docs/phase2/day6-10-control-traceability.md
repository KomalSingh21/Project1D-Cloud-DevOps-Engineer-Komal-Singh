# Phase 2 Security Control Traceability

| Day | Control | Threat addressed | Primary evidence |
|---|---|---|---|
| 6 | Vault | credential exposure | Vault policies + architecture |
| 6 | Kubernetes auth | static identity | ServiceAccount → Vault role |
| 7 | Vulnerability scanning | known CVEs | Trivy configuration + CI design |
| 7 | Signing | artifact tampering | Cosign + Kyverno |
| 7 | Admission | unsafe image deployment | Kyverno policies |
| 8 | PSS Restricted | privilege escalation | namespace labels + compliant Deployment |
| 9 | Audit logging | accountability/forensics | audit policy |
| 9 | Falco | runtime compromise | custom Falco rules |
| 9 | Alerting | delayed response | Alertmanager routing |
| 10 | mTLS | service impersonation/eavesdropping | PeerAuthentication |
| 10 | Canary | deployment risk | VirtualService |
| 10 | Circuit breaking | cascading failure | DestinationRule |

## Security incident alignment

B3.3:
- network scan → NetworkPolicy + Falco
- production Secret access → cluster separation + RBAC + audit
- external exfiltration → egress NetworkPolicy + runtime detection

## Audit-day alignment

B3.5 evidence requests are supported by:
- NetworkPolicy YAML + network diagram
- RBAC YAML + matrix
- Vault architecture + mTLS configuration
- audit policy + Falco rules
- image scanning + admission policies
