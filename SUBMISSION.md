# Project 1D — Submission Tracking

**Candidate:** Komal Singh  
**Project:** DevOps & Cloud Engineer — Security Hardened Kubernetes Platform  
**Scenario:** FinServ Digital  

## Phase 1 — Foundation and Architecture

| Day | Focus | Deliverables | Status |
|---|---|---|---|
| 1 | Environment & repository initialization | README, metadata, repository structure, local tool verification | Complete |
| 2 | Cluster architecture | Cluster architecture, HA design, namespace hierarchy, architecture diagram | Complete |
| 3 | Namespace & multi-tenancy | Namespace YAMLs, ResourceQuotas, LimitRanges, PCI mapping draft | Complete |
| 4 | RBAC | Six-persona RBAC manifests, matrix, verification plan | Complete |
| 5 | Network policy | 20-service dependency map, default-deny policies, allow rules, flow diagram | Complete |

## Phase 2 — Security Controls and Platform Hardening

| Day | Focus | Deliverables | Status |
|---|---|---|---|
| 6 | Secrets management architecture | Vault architecture, domain-specific Vault policies, Vault Agent Injector pattern, CSI integration pattern, Payment Gateway example, revised developer onboarding guidance | Complete |
| 7 | Image security pipeline | Kyverno admission policies, signed-image verification design, mutable-tag restrictions, Trivy configuration, multi-stage Dockerfile and `.dockerignore` | Complete |
| 8 | Pod Security Standards | Restricted PSS labels for all application namespaces, Baseline and Restricted security-context templates, compliant Payment Gateway Deployment, exemption register | Complete |
| 9 | Audit logging and runtime detection | Kubernetes audit policy, FinServ-specific Falco rules, incident-response playbook, Falco-to-Alertmanager-to-PagerDuty/Slack alerting design | Complete |
| 10 | Service mesh and workload-to-workload security | Istio versus Linkerd comparison, strict mTLS configuration, canary traffic policy, circuit-breaking controls, validation guidance and architecture prompt | Complete |


## Phase 1 Review Milestone

By the end of Day 5, the following artifacts were prepared for review by the Security Audit Team:

- Cluster architecture and high-availability design
- Namespace hierarchy and multi-tenancy boundaries
- RBAC matrix covering six platform personas
- RBAC verification plan
- 20-service dependency map
- Default-deny and explicit-allow NetworkPolicy specification
- Network flow diagram
- Initial PCI-DSS engineering control mapping

## Phase 2 Security Review Milestone

By the end of Day 10, the following controls were designed and documented:

- Vault-based secrets management with domain-level policies
- Automated Vault Agent secret injection to reduce manual onboarding steps
- An additional Vault CSI integration pattern
- Container image scanning, signing and admission-control design
- Restrictions against mutable image tags and unsigned images
- Restricted Pod Security Standards across application namespaces
- Kubernetes API audit logging
- FinServ-specific Falco runtime detection rules
- Incident-response handling for the compromised-development-Pod scenario
- Alert routing from runtime detection to operational response channels
- Strict service-mesh mTLS and traffic-management controls
- Canary-release and circuit-breaking examples
- Developer onboarding improvements addressing B3.2 concerns

## Validation Record

- YAML syntax validation: completed for the Phase 2 package; 13 YAML files checked with no syntax errors.
- Kubernetes API/schema validation: must be completed with a compatible cluster and validator before applying manifests.
- `kubectl auth can-i`: Day 4 verification is planned against a test cluster.
- NetworkPolicy validation: must be completed against a CNI that enforces NetworkPolicy.
- Kyverno validation: admission policies require testing with the target Kyverno version and representative signed and unsigned images.
- Image signing: Cosign identity and issuer values are design placeholders until the actual CI/CD identity is configured.
- Vault integration: TLS, authentication configuration, NetworkPolicies and production secret paths must be validated during implementation.
- Pod Security Standards: namespace labels and workload templates are design artifacts until applied and verified in the target cluster.
- Falco rules: require version-specific validation, tuning and false-positive review before production enforcement.
- Service mesh: Istio root namespace, injection readiness, protocol definitions and mTLS behavior must be verified in the target cluster.
- Secrets: no real credentials, tokens or secret values are committed.
- External CIDRs: documentation-only placeholders until approved production ranges are known.
- Provider and identity values: placeholders must be replaced with approved production-specific values before deployment.

## Important Implementation Notes

1. The manifests and policies in this repository are customized for the FinServ Digital scenario.
2. Placeholder provider CIDRs must not be treated as production endpoints.
3. The image-signature verification policy contains placeholder identity values and must be updated for the approved CI/CD signing identity.
4. The sample Dockerfile is illustrative because the final application implementation and language runtime are not specified by the scenario.
5. Vault policies are organized by application domain: payments, risk, customer and platform.
6. NetworkPolicy, RBAC, Vault, Pod Security Standards, audit logging, Falco and service-mesh mTLS provide complementary controls.
7. The PCI-DSS mapping is an engineering traceability aid and does not represent formal PCI-DSS certification.
8. No production deployment should be performed until manifests, policies, identities, CIDRs, certificates and operational integrations have been approved and validated.






