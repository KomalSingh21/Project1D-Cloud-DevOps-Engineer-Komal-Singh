# Service Mesh Validation Plan

## mTLS

Verify:
```bash
istioctl x authz check <pod> -n finserv-prod-payments
```

Confirm PeerAuthentication is STRICT and service-to-service traffic is proxied.

## Canary

Confirm approximately:
- 90% requests → v1
- 10% requests → v2

Increase v2 only after error rate, latency and business metrics are acceptable.

## Circuit breaking

Generate controlled concurrent load against transaction-processor and confirm that
connection/pending-request limits prevent unlimited pressure on the dependency.

## NetworkPolicy compatibility

Confirm that the service mesh sidecars do not accidentally require broader network access
than the Day 5 NetworkPolicy specification.

## Rollback

- Set v2 weight to 0.
- Restore v1 to 100%.
- Preserve the DestinationRule so the subset remains defined.
- Investigate failures before reintroducing v2.

## Production gate

No production mesh rollout should occur until:
- mTLS is validated;
- health probes remain functional;
- observability is available;
- NetworkPolicy behavior is verified;
- resource overhead is measured;
- rollback is tested.
