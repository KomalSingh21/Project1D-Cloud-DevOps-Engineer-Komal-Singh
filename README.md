# FinServ Digital — Security-Hardened Kubernetes Platform

**Candidate:** Komal Singh
**Project:** DevOps & Cloud Engineer — Security Hardened Kubernetes Platform
**Classification:** Private / Confidential — authorized reviewers only

## Project summary

This project designs a security-hardened Kubernetes platform for a regulated fintech scenario. It addresses workload isolation, least-privilege access, secrets management, software supply-chain security, workload hardening, runtime detection, encrypted service communication, operational resilience, and PCI-oriented evidence preparation.

## Delivered capabilities

- Multi-environment Kubernetes architecture and namespace hierarchy
- Resource quotas, limit ranges, and Pod Security Standards
- Persona-based RBAC and zero-trust NetworkPolicies
- Vault architecture and workload secret-injection patterns
- Image scanning, signing, and admission-control design
- Kubernetes audit logging, Falco detection, alerting, and incident response
- Service-mesh evaluation, strict mTLS, and traffic-management patterns
- Developer onboarding, Helm templates, CI pipeline templates, and operations runbook
- HPA examples, monitoring dashboard specifications, PCI mapping, audit evidence index, and compliance checklist
- Final architecture overview and submission quality controls

## Scenario coverage

- **B3.2 — Developer onboarding:** guided deployment, logs, debugging, configuration, and Vault-backed secret access.
- **B3.3 — Compromised Pod:** isolation, default-deny controls, RBAC limits, secret access restrictions, runtime detection, alerting, containment, and evidence preservation.
- **B3.4 — Scale event:** controlled 1x-to-5x scaling, HPA prerequisites, observability checks, and rollback criteria.
- **B3.5 — Audit readiness:** traceability from controls to manifests, access reviews, Vault configuration, mTLS policy, audit logs, Falco events, vulnerability results, and admission outcomes.

## Validation and evidence

The repository separates design documentation from live-environment validation. Before submission, record tool versions, Kubernetes schema versions, timestamps, commands, output, warnings, failures, and remediation actions in the validation report.

## Repository navigation

- `docs/architecture/` — architecture and diagram artifacts
- `docs/security/` — security controls and incident response
- `docs/compliance/` — PCI mapping and audit preparation
- `docs/operations/` — onboarding, runbook, troubleshooting, and quality controls
- `k8s/` — Kubernetes manifests and policy examples
- `charts/` and/or `helm/` — Helm templates and values
- `ci/` — CI/CD templates
- `scripts/` — validation and matrix-generation helpers
