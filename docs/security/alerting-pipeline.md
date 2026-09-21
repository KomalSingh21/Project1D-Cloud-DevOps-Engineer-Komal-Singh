# FinServ Digital — Runtime Security Alerting Pipeline

## Target flow

```text
Falco
  |
  | security event
  v
Alert / Exporter
  |
  v
Prometheus / Alertmanager
  |
  +----> Slack
  |
  +----> PagerDuty
  |
  +----> Security SIEM
```

## Severity routing

| Falco priority | Example | Route |
|---|---|---|
| CRITICAL | production shell, Kubernetes client in app container | PagerDuty + Slack + SIEM |
| ERROR | privileged/container escape indicators | PagerDuty + SIEM |
| WARNING | network discovery, suspicious outbound tooling | Slack + SIEM |
| NOTICE/INFO | audit-oriented baseline events | SIEM |

## Alert payload

Every high-value alert should preserve:
- timestamp
- Falco rule
- priority
- cluster/environment
- namespace
- Pod
- container
- image
- process
- command line where safe
- connection where relevant

## Alert fatigue controls

- Start with narrow rules.
- Use known-good exceptions.
- Tune after observing staging behavior.
- Avoid sending every informational event to PagerDuty.
- Record rule owner and review date.
- Test alert delivery during quarterly incident exercises.

## Incident linkage

A CRITICAL Falco event should create an incident ticket or page the on-call security/platform
team. The incident commander decides containment; the alert itself does not automatically
delete workloads unless a separately approved automated response exists.
