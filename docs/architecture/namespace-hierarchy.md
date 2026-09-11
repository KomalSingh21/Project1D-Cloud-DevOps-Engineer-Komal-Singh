# Namespace Hierarchy

## Design

FinServ Digital uses four application-domain namespaces per environment:

| Environment | Namespace | Domain |
|---|---|---|
| dev | `finserv-dev-payments` | Payments |
| dev | `finserv-dev-risk` | Risk & Compliance |
| dev | `finserv-dev-customer` | Customer |
| dev | `finserv-dev-platform` | Platform |
| staging | `finserv-staging-payments` | Payments |
| staging | `finserv-staging-risk` | Risk & Compliance |
| staging | `finserv-staging-customer` | Customer |
| staging | `finserv-staging-platform` | Platform |
| prod | `finserv-prod-payments` | Payments |
| prod | `finserv-prod-risk` | Risk & Compliance |
| prod | `finserv-prod-customer` | Customer |
| prod | `finserv-prod-platform` | Platform |

## Namespace labels

Every application namespace carries:

- `finserv.io/environment`
- `finserv.io/domain`
- `pod-security.kubernetes.io/enforce`
- `pod-security.kubernetes.io/audit`
- `pod-security.kubernetes.io/warn`

The security labels are intentionally included at namespace level so Pod Security Standards can be enforced consistently in the later security phase.

## Ownership model

- **Payments:** payment-processing engineering team
- **Risk:** risk/compliance engineering team
- **Customer:** customer-platform engineering team
- **Platform:** platform engineering team

Namespace ownership does not override cluster-level security controls.

## Trust boundaries

An application Pod belongs to exactly one environment/domain namespace. Network access between namespaces is denied by default and must be explicitly permitted by NetworkPolicy.

Production namespaces are not shared with dev or staging workloads.

## Cluster-scoped services

Cluster infrastructure such as DNS, ingress controllers, monitoring agents, admission controllers, Falco, and Vault infrastructure may use dedicated system namespaces. These are operational namespaces rather than application tenancy namespaces.

## Design rule

Do not create a generic `finserv-prod-apps` namespace. Domain separation is intentional because it allows independent RBAC, quotas, limits, network controls, and audit evidence.
