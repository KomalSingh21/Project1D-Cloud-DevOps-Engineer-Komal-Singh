# RBAC Matrix — Six Engineering Personas

The project brief defines six personas: Platform Administrator, Namespace Administrator, Developer, CI/CD Service Account, Security Auditor, and Monitoring Service Account.

| Persona | Dev | Staging | Prod | Cluster scope | Secrets |
|---|---|---|---|---|---|
| Platform Administrator | Full | Full | Full | Full | Administrative access; break-glass only |
| Namespace Administrator | Full within assigned namespace | Full within assigned namespace | Full within assigned namespace | None | No cluster-wide secret access |
| Developer | Read + logs + exec | Read + logs + exec | Read + logs; no exec | None | No secret modification/access |
| CI/CD Service Account | Deploy assigned resources | Deploy assigned resources | Separate controlled pipeline identity | None | No direct secret reads |
| Security Auditor | Read-only evidence | Read-only evidence | Read-only evidence | Read-only selected resources | No secret reads |
| Monitoring Service Account | Metrics/resource visibility | Metrics/resource visibility | Metrics/resource visibility | Selected metrics resources | No secret/configmap reads |

## Permission design

### Platform Administrator

Cluster-wide administration is intentionally restricted to a very small group and should be protected by the organisation's MFA/break-glass process.

### Namespace Administrator

Permissions are namespace-scoped. The same role is reused through RoleBindings in the assigned domain namespace.

### Developer

Developers can inspect Pods, Services and Deployments and read logs. Interactive Pod exec is available only in dev/staging. Production has no `pods/exec` permission.

### CI/CD

CI/CD identities are represented by Kubernetes ServiceAccounts. The deployer role excludes `secrets` and `secrets` subresources. Environment-specific ServiceAccounts prevent a dev pipeline identity from being reused as a production identity.

### Security Auditor

The auditor receives read-only access to resources required to review workload configuration, network policy and RBAC configuration. Secret values are excluded.

### Monitoring

Monitoring can inspect workload/resource information and metrics but does not receive Secret or ConfigMap permissions.

## Test matrix

Example verification commands after connecting to a cluster:

```bash
kubectl auth can-i get pods \
  --as=group:finserv:dev:payments:developers \
  -n finserv-dev-payments

kubectl auth can-i create pods/exec \
  --as=group:finserv:dev:payments:developers \
  -n finserv-dev-payments

kubectl auth can-i create pods/exec \
  --as=group:finserv:prod:payments:developers \
  -n finserv-prod-payments

kubectl auth can-i get secrets \
  --as=group:finserv:prod:payments:developers \
  -n finserv-prod-payments

kubectl auth can-i get networkpolicies \
  --as=group:finserv:security-auditors \
  -n finserv-prod-payments
```

> Group impersonation may require cluster-admin/appropriate impersonation privileges in the test environment. These commands are verification examples, not permission grants.

## Security invariants

1. Developers cannot modify Secrets.
2. Developers cannot exec into production Pods.
3. CI/CD identities cannot directly read Secrets.
4. Monitoring cannot read Secrets or ConfigMaps.
5. Security auditors cannot modify resources.
6. Namespace administrators cannot administer another namespace through the namespace-scoped role.
