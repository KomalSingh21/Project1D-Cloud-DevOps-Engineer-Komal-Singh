# FinServ Digital — Security-Hardened Kubernetes Platform

> **Zetheta Project 1D — Cloud & DevOps Engineer**
>
> **Strictly Private & Confidential — Project Work Product**

## Project Status

| Item | Value |
|---|---|
| Project | Project 1D |
| Candidate | Komal Singh |
| Platform | FinServ Digital |
| Phase | Phase 1 — Foundation and Architecture |
| Current Day | Day 1 — Environment Setup and Repository Initialisation |
| Repository | `Project1D-Cloud-DevOps-Engineer-Komal-Singh` |
| Status | In Progress |

## 1. Project Overview

FinServ Digital is a fictional RBI-regulated fintech processing approximately 180,000 daily transactions for 2.4 million active users across 20 microservices.

The project designs and documents a production-grade, security-hardened Kubernetes platform to replace a legacy VM-based environment that lacks network isolation, secure secrets management, centralised observability, and formal access controls.

The target platform applies defence in depth across:

- Cloud security
- Kubernetes cluster security
- Container security
- Application and software-supply-chain security

The platform will incorporate zero-trust network segmentation, least-privilege RBAC, HashiCorp Vault, runtime threat detection with Falco, image vulnerability scanning and signing, admission control, centralised observability, autoscaling, incident response, and PCI-DSS control mapping.

## 2. Phase 1 Objective

Phase 1 establishes the foundation of the platform design.

By the end of Day 5, the repository will contain the core:

1. Cluster architecture
2. Namespace hierarchy
3. Multi-tenancy/resource controls
4. RBAC model
5. Zero-trust network policy specification

The architecture will be designed for three environments:

- Development
- Staging
- Production

and four business domains:

- Payments
- Risk & Compliance
- Customer
- Platform

## 3. Day 1 Scope

Day 1 establishes the project repository and local engineering environment.

### Day 1 deliverables

- Private GitHub repository
- Required project directory structure
- Initial project README
- Submission tracking document
- Project metadata
- Local tool verification
- Git repository baseline
- Initial Day 1 commit

## 4. Planned Platform Controls

The completed platform will address:

- Environment and namespace isolation
- Zero-trust Kubernetes NetworkPolicies
- Least-privilege Kubernetes RBAC
- Pod Security Standards
- HashiCorp Vault secrets management
- Image vulnerability scanning
- SBOM generation
- Image signing
- Admission control
- Kubernetes API audit logging
- Falco runtime detection
- Service-to-service mTLS/service mesh
- Centralised metrics, logs and traces
- Horizontal Pod Autoscaling
- Disaster recovery and operational procedures
- PCI-DSS evidence mapping

## 5. Repository Structure

```text
Project1D-Cloud-DevOps-Engineer-Komal-Singh/
├── .zetheta-project.json
├── README.md
├── SUBMISSION.md
├── docs/
│   ├── architecture/
│   ├── security/
│   ├── compliance/
│   └── operations/
├── k8s/
│   ├── namespaces/
│   ├── rbac/
│   ├── network-policies/
│   ├── pod-security/
│   ├── resource-quotas/
│   ├── limit-ranges/
│   ├── vault/
│   ├── admission-control/
│   ├── audit/
│   ├── service-mesh/
│   ├── monitoring/
│   └── sample-deployments/
├── helm/
├── Dockerfiles/
└── scripts/
```

The detailed contents will be populated progressively according to the 15-day project methodology.

## 6. Working Principles

This repository is developed as an original FinServ Digital platform design.

Key principles:

- Security controls are explicit rather than assumed.
- Least privilege is preferred over broad convenience permissions.
- Default-deny networking is the baseline.
- Production receives stricter controls than development.
- Security decisions will be documented with rationale and trade-offs.
- Kubernetes manifests will be validated before submission.
- Compliance evidence will be traceable to implemented controls.
- No real credentials, secrets, customer data, payment data, or production access information will be committed.


