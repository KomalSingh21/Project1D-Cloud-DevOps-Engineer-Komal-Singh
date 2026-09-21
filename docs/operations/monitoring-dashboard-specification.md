# Monitoring Dashboard Specification

## Dashboard 1 — Executive service health

Audience: service owners and incident commanders.

Panels:
- request rate by service
- success and error rate
- p50, p95 and p99 latency
- active incidents and critical alerts
- transaction throughput
- failed and pending payment transactions

Filters:
- environment
- namespace
- service
- region
- time range

## Dashboard 2 — Kubernetes platform health

Panels:
- node readiness and utilization
- Pod restart rate
- Pending and failed Pods
- CPU and memory requests versus usage
- ResourceQuota consumption
- HPA desired versus current replicas
- scheduling failures
- PVC capacity and status

## Dashboard 3 — Security and compliance

Panels:
- Falco alerts by severity
- denied admission requests
- unsigned or mutable-image attempts
- Vault authentication failures
- Kubernetes audit events by resource
- NetworkPolicy deny indicators
- privileged or non-compliant Pod attempts
- certificate expiry horizon

## Dashboard 4 — B3.4 scale test

Panels:
- load-test request rate
- replicas over time
- HPA desired/current replicas
- Pod startup latency
- CPU and memory saturation
- request latency and error rate
- queue depth
- node scale-out events
- Vault and Istio sidecar readiness

## Alert thresholds to tune during validation

| Signal | Initial condition | Severity |
|---|---|---|
| API error rate | Above agreed SLO for 5 minutes | High |
| p99 latency | Above service threshold for 10 minutes | High |
| HPA at max replicas | Sustained for 10 minutes | High |
| Pending Pods | Any production workload pending for 5 minutes | High |
| Node not ready | 5 minutes | Critical |
| Falco production shell | Any confirmed event | Critical |
| Certificate expiry | Less than 30 days | Warning; escalate at 7 days |
