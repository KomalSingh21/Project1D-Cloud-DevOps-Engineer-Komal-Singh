# Developer Onboarding Guide

**Audience:** FinServ Digital application developers, service owners and on-call engineers  
**Primary user journey:** Vikram (B2.2)  
**Scope:** Development and staging namespaces; production access remains approval-based.

## 1. Operating principles

- Deploy through the approved CI/CD pipeline; do not apply arbitrary production manifests.
- Use a dedicated namespace and service account for every workload.
- Use immutable image digests rather than mutable tags.
- Secrets are injected through Vault; developers must not commit secrets or place them in Git.
- Logs and diagnostics are observable through approved commands and dashboards.
- Production access is time-bound, ticketed and audited.

## 2. Prerequisites

Install or obtain access to:

- `kubectl`
- Helm 3
- Git
- Access to the private repository
- Access to the approved container registry
- SSO/VPN and the relevant Kubernetes context

Verify the context before continuing:

```bash
kubectl config current-context
kubectl get namespaces
kubectl auth can-i get pods -n finserv-dev-payments
```

Never continue if the current context is an unexpected production cluster.

## 3. Deploying a new service

### Step 1 — Create the service directory

```text
services/payment-gateway/
├── src/
├── Dockerfile
├── chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
└── .github/workflows/service-ci.yaml
```

### Step 2 — Add a secure Dockerfile

Use a multi-stage build, a minimal runtime image, a non-root user and a pinned base image digest. The image must pass Trivy scanning and Cosign signing in CI.

### Step 3 — Configure Helm values

Set only non-sensitive configuration in `values.yaml`:

```yaml
image:
  repository: ghcr.io/finserv-digital/payment-gateway
  digest: "sha256:REPLACE_WITH_APPROVED_DIGEST"

service:
  port: 8080

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

Do not place passwords, tokens, private keys or connection strings in Helm values.

### Step 4 — Configure Vault injection

Use the service account assigned to the application domain. The approved Vault policy must allow only the service's required paths.

Example annotations:

```yaml
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/role: "finserv-payments"
vault.hashicorp.com/agent-inject-secret-config: "secret/data/payments/payment-gateway"
```

### Step 5 — Validate locally

```bash
helm lint ./chart
helm template payment-gateway ./chart > rendered.yaml
kubectl apply --dry-run=client -f rendered.yaml
```

Where available, also run schema validation with the target Kubernetes version.

### Step 6 — Open a pull request

The pipeline should perform:

1. Unit and integration tests
2. Static analysis
3. Trivy vulnerability and secret scanning
4. Image build
5. Cosign signing
6. Manifest rendering and policy checks
7. Pull-request review

Only approved, signed images may be admitted to the cluster.

### Step 7 — Verify deployment

```bash
kubectl rollout status deployment/payment-gateway -n finserv-dev-payments
kubectl get pods -n finserv-dev-payments -l app.kubernetes.io/name=payment-gateway
kubectl describe deployment payment-gateway -n finserv-dev-payments
```

## 4. Viewing logs

### View logs for one Pod

```bash
kubectl logs -n finserv-dev-payments pod/<pod-name>
```

### Follow logs

```bash
kubectl logs -n finserv-dev-payments -f pod/<pod-name>
```

### View the previous container instance

```bash
kubectl logs -n finserv-dev-payments pod/<pod-name> --previous
```

### Select a container

```bash
kubectl logs -n finserv-dev-payments pod/<pod-name> -c <container-name>
```

### View logs by label

```bash
kubectl logs -n finserv-dev-payments \
  -l app.kubernetes.io/name=payment-gateway \
  --all-containers=true \
  --prefix=true \
  --tail=200
```

Logs may contain regulated or personal data. Do not copy raw production logs into tickets or public channels. Redact sensitive fields.

## 5. Debugging Pods

### Step 1 — Inspect Pod status

```bash
kubectl get pods -n finserv-dev-payments -o wide
kubectl describe pod -n finserv-dev-payments <pod-name>
```

### Step 2 — Review events

```bash
kubectl get events -n finserv-dev-payments \
  --sort-by=.lastTimestamp
```

### Step 3 — Check resource pressure

```bash
kubectl top pod -n finserv-dev-payments
kubectl top node
```

### Step 4 — Check probes and configuration

```bash
kubectl get deployment payment-gateway -n finserv-dev-payments -o yaml
kubectl get configmap -n finserv-dev-payments
kubectl get service -n finserv-dev-payments
```

### Step 5 — Use an ephemeral debug container where approved

```bash
kubectl debug -n finserv-dev-payments pod/<pod-name> \
  -it --image=busybox:1.36 --target=<container-name>
```

Use approved diagnostic images only. Do not install arbitrary tools into production containers.

### Common symptoms

| Symptom | Checks |
|---|---|
| `CrashLoopBackOff` | Previous logs, exit code, probes, missing configuration |
| `ImagePullBackOff` | Registry access, image digest, admission events, imagePullSecret |
| `Pending` | ResourceQuota, node capacity, taints, PVC and scheduling events |
| Readiness failure | Service port, dependency health, readiness endpoint |
| OOMKilled | Memory usage, limits, leak indicators and recent deployment changes |
| DNS failure | Service name, namespace, CoreDNS health and NetworkPolicy DNS allowance |

## 6. Managing configuration

- Store non-sensitive configuration in ConfigMaps or Helm values.
- Store sensitive values in Vault.
- Version configuration changes through pull requests.
- Roll out configuration changes deliberately and verify the resulting Pods.

```bash
kubectl get configmap <configmap-name> -n finserv-dev-payments -o yaml
kubectl rollout restart deployment/payment-gateway -n finserv-dev-payments
kubectl rollout status deployment/payment-gateway -n finserv-dev-payments
```

Do not use `kubectl edit` for unreviewed production changes.

## 7. Requesting secrets access

1. Open an access request ticket.
2. Specify the service, namespace, business justification, exact secret path and requested duration.
3. Obtain service-owner and security approval.
4. Security updates the Vault policy and Kubernetes service-account mapping.
5. Validate access using a non-sensitive test value.
6. Record the approval and expiry date.

Developers must not request broad wildcard access when a specific path is sufficient. Human access to production secrets should be exceptional, time-bound and audited.

## 8. Vikram walkthrough — B2.2

Vikram is onboarding without prior Helm knowledge.

1. He uses the repository's service template rather than creating a chart from scratch.
2. He runs `helm lint` and `helm template` using the documented commands.
3. He submits a pull request and lets CI build, scan and sign the image.
4. He deploys to the assigned development namespace through the approved workflow.
5. He uses the log commands in this guide instead of requiring unrestricted production `exec`.
6. He follows the troubleshooting table for a failing Pod.
7. He requests Vault access through a ticket rather than completing five manual secret steps.
8. The onboarding owner confirms that Vikram can deploy, view development logs and diagnose a failed Pod.

## 9. Escalation

Escalate immediately when:

- A production secret may have been exposed.
- A workload attempts unexpected network access.
- A signed-image or admission policy fails unexpectedly.
- A production deployment is unavailable beyond the agreed SLO.
- Audit logs or Falco alerts indicate suspicious activity.

Include namespace, workload, UTC timestamp, change reference and sanitized evidence.
