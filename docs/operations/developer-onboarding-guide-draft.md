# FinServ Digital Developer Onboarding Guide — Revised Day 6 Draft

## Goal

A developer should be able to deploy and inspect a service without needing to understand
Vault internals or perform a five-step manual secret injection procedure.

## What changed after the Developer Revolt scenario?

The scenario identified three problems:

1. The guide assumed Helm knowledge.
2. Developers could not view their own Pod logs.
3. Secret injection required five manual steps.

The revised workflow addresses all three without granting production privilege.

## Developer workflow

### 1. Clone the service repository

```bash
git clone <approved-internal-repository>
cd payment-gateway
```

### 2. Build and test locally

```bash
make test
make build
```

### 3. Build the image

The CI pipeline owns image scanning and signing. Developers do not manually push unsigned
production images.

### 4. Deploy to staging

Use the team's approved Helm command:

```bash
helm upgrade --install payment-gateway ./deploy/helm \
  --namespace finserv-staging-payments \
  --values ./deploy/helm/values-staging.yaml
```

If Helm is unfamiliar, use the documented wrapper:

```bash
./scripts/deploy-staging.sh
```

The wrapper is the developer-friendly abstraction; the underlying Helm workflow remains
documented for transparency.

### 5. View logs

Developers have permission to inspect logs in development/staging:

```bash
kubectl logs -n finserv-staging-payments deploy/payment-gateway
```

Production interactive access remains restricted.

### 6. Understand secrets

Developers do not create production passwords in Kubernetes.

The application receives approved secrets through Vault Agent injection.

Developers only request access by service/domain and environment.

Example request:

```text
Service: payment-gateway
Environment: staging
Required secret path: secret/data/payments/payment-gateway
Business purpose: payment processor integration
```

### 7. Debug safely

Allowed in dev/staging:

```bash
kubectl describe pod <pod> -n finserv-staging-payments
kubectl logs <pod> -n finserv-staging-payments
```

Interactive `kubectl exec` is intentionally unavailable to production developers.

## Security boundary

Developer convenience does not override the platform's security model.

The onboarding guide therefore provides:
- a wrapper for Helm complexity
- read-only log access in appropriate environments
- automated Vault injection
- clear escalation paths

It does NOT provide:
- production Secret read access
- production `kubectl exec`
- cluster-admin access
- ability to bypass image admission controls

## Day 6 acceptance test

A developer unfamiliar with Helm should be able to follow the wrapper workflow and deploy
to staging without manually copying credentials into Kubernetes.
