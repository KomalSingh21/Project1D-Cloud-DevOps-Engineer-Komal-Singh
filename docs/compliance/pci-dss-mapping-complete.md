# PCI-DSS Engineering Control Mapping — Phase 3 Completion

> This document is an engineering traceability aid for the fictional FinServ Digital scenario. It is not formal PCI-DSS certification or an assessor opinion.

| Control theme | Platform implementation | Evidence reference | Validation status |
|---|---|---|---|
| Network segmentation | Namespace boundaries, default-deny and explicit NetworkPolicies | `k8s/network-policies/`, `docs/security/network-policy-specification.md` | Design complete; CNI validation pending |
| Least privilege | Namespace Roles, ClusterRoles, bindings and verification plan | `k8s/rbac/`, `docs/security/rbac-matrix.md` | Design complete; cluster test pending |
| Secrets protection | Vault domain policies, Agent Injector and CSI alternative | `k8s/vault/`, `docs/security/vault-architecture.md` | Design complete; Vault deployment validation pending |
| Secure configuration | ConfigMap guidance, Vault paths and Git-reviewed values | `docs/operations/developer-onboarding-guide.md` | Documentation complete |
| Image security | Trivy scanning, Cosign signing design and Kyverno admission | `k8s/admission/kyverno/`, `docs/security/image-security-pipeline.md` | Policy test pending |
| Workload hardening | Restricted PSS labels and security contexts | `k8s/pod-security/` | Cluster enforcement test pending |
| Auditability | Kubernetes audit policy and evidence retention design | `k8s/audit/audit-policy.yaml` | API-server configuration pending |
| Runtime monitoring | FinServ-specific Falco rules and alert routing | `k8s/falco/`, `docs/security/alerting-pipeline.md` | Version tuning pending |
| Encryption in transit | Istio strict mTLS and traffic controls | `k8s/service-mesh/`, `docs/security/service-mesh-validation.md` | Mesh validation pending |
| Vulnerability management | CI scan gates and severity policy | `config/trivy/trivy.yaml`, `ci/templates/service-ci.yaml` | CI integration pending |
| Incident response | B3.3 response playbook and escalation process | `docs/security/incident-response-playbook.md` | Tabletop exercise pending |
| Availability and recovery | HPA, backup/restore runbook and scale-test procedure | `k8s/autoscaling/`, `docs/operations/platform-operations-runbook.md` | Test evidence pending |

## Evidence collection rules

- Store evidence references with commit SHA, UTC timestamp, environment and operator.
- Redact credentials, tokens, personal data and customer transaction payloads.
- Capture both successful controls and controlled negative tests.
- Retain raw evidence only in approved private locations.
- Link each evidence item to a control, test procedure and reviewer.
