# Compliance and Release Readiness Checklist

## Repository and governance

- [ ] Repository is private.
- [ ] Only authorized collaborators have access.
- [ ] Branch protection is enabled.
- [ ] Forking, public wiki and public discussions are disabled where supported.
- [ ] No credentials or personal data are committed.
- [ ] Ownership-transfer requirements are documented.

## Kubernetes foundation

- [ ] Environment separation is documented.
- [ ] Namespace labels and quotas are applied and verified.
- [ ] RBAC permissions are tested using `kubectl auth can-i`.
- [ ] Default-deny NetworkPolicies are enforced by the selected CNI.
- [ ] Required DNS traffic is allowed.
- [ ] External CIDRs are approved before production use.

## Secrets and supply chain

- [ ] Vault authentication and TLS are configured.
- [ ] Vault policies are least privilege.
- [ ] Secret injection works without manual secret copying.
- [ ] Trivy scans vulnerabilities and secrets.
- [ ] High and critical findings fail the pipeline according to policy.
- [ ] Images are signed with the approved CI identity.
- [ ] Kyverno verifies signatures and rejects mutable tags.

## Workload and runtime security

- [ ] Restricted PSS is enforced for application namespaces.
- [ ] Workloads run as non-root with RuntimeDefault seccomp.
- [ ] Privilege escalation is disabled.
- [ ] Root filesystem is read-only where supported.
- [ ] Kubernetes audit logging is configured and retained.
- [ ] Falco rules are validated and tuned.
- [ ] Critical alerts reach the approved response channels.
- [ ] Strict mTLS is verified between required services.

## Operations and resilience

- [ ] HPA metrics are available.
- [ ] B3.4 scale test is executed in an approved environment.
- [ ] Backup and restore test is completed.
- [ ] Certificate rotation procedure is tested.
- [ ] Node maintenance procedure is tested.
- [ ] Upgrade and rollback procedures are documented.
- [ ] Monitoring dashboards and alert thresholds are reviewed.

## Audit preparation

- [ ] Every control has an evidence reference.
- [ ] Evidence includes timestamp, environment and reviewer.
- [ ] Sensitive data is redacted.
- [ ] Pending validation items have owners and due dates.
- [ ] B3.5 audit request workflow has been rehearsed.
