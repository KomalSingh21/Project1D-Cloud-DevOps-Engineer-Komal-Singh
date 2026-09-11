# FinServ Digital — Cluster Architecture

**Phase:** 1 — Foundation and Architecture  
**Day:** 2 — Cluster Architecture Design  
**Status:** Design baseline for Security Audit Team review

## 1. Architecture objective

FinServ Digital is migrating 20 payment-platform microservices from a flat VM environment to a security-hardened Kubernetes platform. The target design separates development, staging, and production into distinct Kubernetes clusters rather than relying only on namespaces for environment isolation.

The design follows four principles:

1. **Environment isolation:** dev, staging, and prod have independent cluster boundaries.
2. **Failure-domain separation:** production control-plane and worker capacity are distributed across three availability zones.
3. **Workload isolation:** domain workloads use dedicated node pools and namespace boundaries.
4. **Defence in depth:** cluster isolation is reinforced later by RBAC, Pod Security Standards, NetworkPolicies, Vault, admission controls, runtime detection, and centralized audit/observability.

The project brief requires a highly available production control plane and identifies three control-plane nodes across separate availability zones as the minimum HA pattern for production.

## 2. Environment topology

| Environment | Cluster | Primary purpose | Control plane | Worker strategy |
|---|---|---|---:|---|
| dev | `finserv-dev` | Development and integration | 3 nodes | General + platform |
| staging | `finserv-staging` | Release validation / pre-production | 3 nodes | General + platform + security |
| prod | `finserv-prod` | Production payment workloads | 3 nodes | General + payments + platform + security |

### Why separate clusters?

Namespaces provide useful logical isolation, but production has a materially different risk profile. A compromised development workload must not be able to reach the production API server, node network, or workload plane. Separate clusters establish a stronger administrative and blast-radius boundary.

Production is therefore treated as a separate trust domain. Cross-environment traffic is not part of the normal application communication model.

## 3. Production control-plane HA

Production uses three control-plane nodes:

- `prod-cp-a` — AZ-a
- `prod-cp-b` — AZ-b
- `prod-cp-c` — AZ-c

The three etcd members are distributed across the same failure domains. With three members, etcd retains quorum after one member fails.

The API endpoint is presented through a highly available control-plane endpoint/load balancer. Worker nodes communicate with the API endpoint rather than depending on one control-plane node.

### HA failure assumptions

| Failure | Expected behaviour |
|---|---|
| One control-plane node fails | Remaining two maintain quorum |
| One AZ fails | Remaining two AZs retain the control plane |
| One worker node fails | Replica scheduling moves workloads to healthy capacity |
| One worker AZ fails | Pod topology rules keep replicas available in other AZs |
| API endpoint member fails | HA endpoint routes to healthy API server |

Production workload manifests will later add topology spread constraints / anti-affinity for critical stateless services.

## 4. Node-pool strategy

### Production node pools

| Pool | Workloads | Isolation intent |
|---|---|---|
| `prod-general` | Non-sensitive stateless platform/customer services | Baseline application capacity |
| `prod-payments` | Payment Gateway, Transaction Processor, Settlement, Refund, Recurring Payments | Dedicated capacity for payment processing |
| `prod-platform` | API Gateway, Service Registry, Configuration, Health Monitor, reporting | Platform services |
| `prod-security` | Security/observability agents and security tooling | Reduces competition with application workloads |

Payment workloads use dedicated node-pool labels and taints/tolerations where appropriate. This is an isolation and scheduling decision, not a substitute for NetworkPolicies.

### Non-production node pools

Development and staging use smaller general-purpose pools with a dedicated platform/security pool where needed. They remain separate clusters so a development compromise cannot directly become a production cluster compromise.

## 5. Namespace hierarchy

Each environment contains the same four application-domain namespaces:

```text
finserv-dev
├── payments
├── risk-compliance
├── customer
└── platform

finserv-staging
├── payments
├── risk-compliance
├── customer
└── platform

finserv-prod
├── payments
├── risk-compliance
├── customer
└── platform
```

Cluster-scoped platform components such as ingress, DNS, monitoring, admission control, Falco, and Vault infrastructure are intentionally not mixed into application-domain namespaces.

The exact namespace names use the environment prefix to make accidental cross-environment references obvious.

## 6. Network boundaries

The architecture establishes these boundaries:

```text
Internet / approved external APIs
            |
     Edge / Ingress
            |
      Environment LB
            |
    Kubernetes cluster
            |
   +--------+--------+
   |        |        |
payments  risk    customer
   |        |        |
   +--------+--------+
            |
        platform
```

At Day 5, NetworkPolicies will make the default state deny-all and explicitly permit only documented service dependencies, DNS, and approved external destinations.

## 7. Administrative boundaries

- Platform administrators operate cluster infrastructure.
- Namespace administrators manage workloads within assigned namespaces.
- Developers receive read-oriented access and controlled debugging access in non-production.
- Production developer access does not include interactive `exec`.
- CI/CD identities are environment-specific.
- Security auditors receive read-only evidence access.
- Monitoring identities receive metrics/resource visibility without secret access.

The detailed RBAC implementation is a Day 4 deliverable.

## 8. Capacity and scaling assumptions

The scenario processes approximately 180,000 transactions per day and must be capable of handling a future 5x traffic spike. Day 2 establishes the capacity boundaries; Day 12 will later validate HPA and scaling behaviour.

The production design therefore reserves independent payment capacity rather than treating every workload as one undifferentiated worker pool.

## 9. Security design decisions

| Decision | Rationale |
|---|---|
| Separate clusters for dev/staging/prod | Stronger environment and blast-radius isolation |
| Three production control-plane nodes | Avoid a single control-plane failure |
| Multi-AZ production placement | Improve availability across failure domains |
| Dedicated payment node pool | Reduce resource contention for payment workloads |
| Four domain namespaces | Establish workload ownership and policy boundaries |
| Explicit network boundaries | Prepare for zero-trust policy enforcement |
| Environment-specific CI/CD identities | Prevent lower environments from deploying into production |
| No application secrets in manifests | Vault will provide centralized secret lifecycle management later |

## 10. Deferred controls

The following are intentionally implemented in later phases:

- HashiCorp Vault integration
- image signing and vulnerability scanning
- Pod Security Standards
- OPA/Kyverno admission controls
- Falco runtime detection
- centralized monitoring and logging
- service mesh evaluation/configuration
- HPA implementation and scale testing

This keeps the Day 2 architecture document traceable to the project methodology without pretending that later controls are already deployed.

## 11. Security Audit Team review questions

Priya and Rahul should review:

1. Does the cluster separation provide an adequate environment trust boundary?
2. Is the production control plane resilient to one-node and one-AZ failures?
3. Is the dedicated payment node-pool strategy justified?
4. Are namespace boundaries aligned to business/service domains?
5. Are any cross-environment application flows accidentally required?
6. Does the architecture leave a clear path to default-deny NetworkPolicies?
7. Are administrative responsibilities sufficiently separated for the Day 4 RBAC model?
