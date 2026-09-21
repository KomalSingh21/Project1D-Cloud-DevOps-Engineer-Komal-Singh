# FinServ Digital — Pod Security Standards

## Security tier model

| Tier | Intended use | FinServ position |
|---|---|---|
| Privileged | Infrastructure/system workloads | Exception-only |
| Baseline | Compatibility workloads | Minimize |
| Restricted | Security-sensitive application workloads | Default target |

Kubernetes defines Privileged, Baseline and Restricted profiles. Restricted is the target
for FinServ application namespaces.

## Namespace enforcement

All twelve application namespaces use:

```text
enforce = restricted
audit   = restricted
warn    = restricted
```

This creates an enforceable baseline while retaining audit/warn visibility.

## Required workload posture

Production application Pods should use:

- `runAsNonRoot: true`
- `seccompProfile: RuntimeDefault`
- `allowPrivilegeEscalation: false`
- drop all Linux capabilities
- read-only root filesystem where application compatibility permits
- explicit resource requests/limits
- immutable image digest

## Exemption process

An exemption must never be an informal developer override.

Required fields:
- namespace
- workload
- requested exception
- security reason
- compensating control
- owner
- approver
- expiry/review date
- rollback plan

## Relationship to other controls

PSS does not replace:
- RBAC
- NetworkPolicy
- image signing
- vulnerability scanning
- Vault
- Falco

It is another workload-hardening layer.
