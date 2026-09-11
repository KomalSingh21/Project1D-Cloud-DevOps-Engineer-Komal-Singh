# PCI-DSS v4.0 Mapping — Phase 1 Draft

**Status:** Draft started on Day 3  
**Scope:** Kubernetes platform controls designed during Phase 1

> This is an engineering control mapping for the project scenario, not a formal PCI-DSS assessment or legal/compliance opinion. Final applicability must be validated by the organisation's qualified assessor.

## Control mapping

| PCI-DSS requirement | Phase 1 platform control | Evidence |
|---|---|---|
| 1. Install and Maintain Network Security Controls | Separate environment clusters; domain namespaces; default-deny NetworkPolicies planned | Cluster architecture, namespace manifests, Day 5 policies |
| 2. Apply Secure Configurations | Namespace labels, resource boundaries, later Pod Security/admission controls | Namespace YAML, LimitRange/ResourceQuota |
| 3. Protect Stored Account Data | Environment/domain isolation; Vault planned for secret lifecycle | Architecture + later Vault evidence |
| 4. Protect Data in Transit | Explicit service-to-service paths; TLS-ready architecture | Network policy specification + later TLS controls |
| 5. Protect Systems and Networks from Malicious Software | Isolation boundaries; later Falco/runtime detection | Network policy design + later Falco evidence |
| 6. Develop and Maintain Secure Systems and Software | RBAC and controlled deployment identities; later image security pipeline | RBAC manifests + later CI/CD controls |
| 7. Restrict Access by Business Need to Know | Six-persona least-privilege RBAC model | Day 4 RBAC matrix |
| 8. Identify Users and Authenticate Access | Named groups/service accounts and environment-specific identities | Day 4 RBAC bindings |
| 9. Restrict Physical Access | Cloud/hosting responsibility boundary; not directly implemented in Kubernetes manifests | Architecture responsibility note |
| 10. Log and Monitor All Access | Security auditor/monitoring read access; centralized audit logging planned | Day 4 RBAC + later audit stack |
| 11. Test Security Regularly | `kubectl auth can-i`, policy validation, later integration/security tests | Day 4 verification + later test evidence |
| 12. Support Information Security with Policies and Programs | Documented roles, network rationale, audit evidence and operating procedures | Repository documentation |

## Day 3 compliance demand

The simulated audit has been moved forward. The design therefore treats each Kubernetes control as something that must produce reviewable evidence.

### Evidence principles

- A policy must be represented by a version-controlled manifest.
- A permission must be testable with an explicit identity.
- A network rule must have a documented business/security rationale.
- A resource boundary must be visible in YAML.
- Controls implemented in later phases are marked as planned rather than falsely claimed as complete.

## Review questions

1. Which namespaces are inside the cardholder-data environment?
2. Which administrative personas can access production?
3. Which controls prevent a development workload from reaching production?
4. Which evidence will demonstrate that production permissions are least privilege?
5. Which later controls are required before the platform can be considered audit-ready?
