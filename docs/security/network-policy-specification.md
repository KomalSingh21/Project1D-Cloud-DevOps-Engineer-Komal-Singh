# Zero-Trust Network Policy Specification

## Objective

The project brief requires every communication path to be explicitly authorized. The Day 5 design therefore starts every application namespace with both ingress and egress denied.

## 1. Default state

Every application namespace receives:

```yaml
policyTypes:
- Ingress
- Egress
podSelector: {}
```

This means a Pod has no allowed ingress or egress until another policy explicitly permits it.

## 2. Application traffic

The service dependency map defines the approved application paths. Each path produces:

1. an ingress policy on the destination workload;
2. an egress policy on the source workload.

This two-sided representation makes the traffic contract easier to audit.

## 3. DNS

All application namespaces receive an explicit egress rule to kube-dns:

- UDP 53
- TCP 53
- `kube-system` namespace
- `k8s-app=kube-dns`

No general DNS egress rule is used.

## 4. External dependencies

External API access is restricted by destination CIDR and port. Blanket:

```text
0.0.0.0/0
```

egress is intentionally prohibited.

The project repository uses RFC 5737 documentation CIDRs as placeholders:

- `203.0.113.0/28` — payment processor
- `198.51.100.0/28` — AML provider
- `203.0.113.16/28` — notification provider

These must be replaced with real, approved provider ranges before a production deployment.

## 5. Namespace selector model

Policies match both:

- `finserv.io/environment`
- `finserv.io/domain`

This prevents an identically named application in another environment from becoming an unintended policy source.

## 6. Security rationale

| Control | Threat addressed |
|---|---|
| Default-deny ingress | Prevents unsolicited service access |
| Default-deny egress | Limits lateral movement and data exfiltration |
| Explicit namespace labels | Prevents accidental cross-environment trust |
| Pod-level selectors | Restricts traffic to intended services |
| DNS-only port 53 | Maintains name resolution without broad egress |
| Specific external CIDRs | Limits external destinations |
| Two-sided rules | Makes dependency intent auditable |

## 7. Incident scenario alignment

If a development Pod is compromised and attempts to scan production, production is outside the namespace/environment selector contract. If it attempts to exfiltrate data to an arbitrary external address, default-deny egress blocks the traffic unless a matching approved rule exists.

NetworkPolicy is one containment layer; RBAC, admission control, Vault, Falco and audit logging are required later for defence in depth.
