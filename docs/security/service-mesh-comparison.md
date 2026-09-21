# FinServ Digital — Istio vs Linkerd Evaluation

## Decision

**Selected mesh: Istio**

The decision is based on this project's explicit requirement to design:
- mTLS for inter-service traffic
- canary traffic management
- circuit breaking
- timeouts/retries
- controlled service-to-service routing

## Comparison

| Capability | Istio | Linkerd |
|---|---|---|
| mTLS | Strong, configurable | Automatic mTLS is a core feature |
| Traffic routing | Rich VirtualService/DestinationRule model | Strong service routing with simpler operational model |
| Canary/A-B routing | Strong weighted routing | Supported through traffic split patterns |
| Circuit breaking | Rich Envoy-based controls | More lightweight model |
| Operational complexity | Higher | Lower |
| Resource footprint | Higher | Lower |
| Policy/control surface | Broad | Narrower |
| Best fit here | Detailed traffic/security requirements | Simpler mesh with lower overhead |

## Why Istio for this case study?

The project needs an explicit traffic-management design including canary deployment and
circuit breaking. Istio's traffic-management model directly represents these controls
through VirtualService and DestinationRule resources.

## mTLS design

Use namespace/workload-level `PeerAuthentication` with:

```yaml
mtls:
  mode: STRICT
```

The mesh therefore requires authenticated encrypted proxy-to-proxy communication.

## Canary design

Example:

```text
transaction-processor-v1 → 90%
transaction-processor-v2 → 10%
```

Traffic weights are changed progressively after validation.

## Circuit breaking

Protect payment-critical callers from an unhealthy dependency by limiting:
- concurrent connections
- pending requests
- unhealthy host reuse

## Existing NetworkPolicy relationship

Service mesh does NOT replace Kubernetes NetworkPolicy.

NetworkPolicy answers:

> Is this network path allowed?

mTLS/service mesh additionally answers:

> Is this workload authenticated and how should the allowed traffic be routed/resilienced?

Both layers remain valuable.

## Rollout principle

1. Install mesh in a non-production environment.
2. Enable sidecars for a controlled namespace.
3. Validate mTLS.
4. Validate existing NetworkPolicies.
5. Apply traffic policies to one service.
6. Canary.
7. Observe.
8. Expand gradually.

## Decision caveat

The mesh is an architecture/configuration design in this phase. Production adoption requires
load testing, resource sizing, compatibility testing and operational approval.
