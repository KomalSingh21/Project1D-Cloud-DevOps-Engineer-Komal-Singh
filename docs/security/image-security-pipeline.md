# FinServ Digital — Image Security and Supply Chain Pipeline

## Objective

Only images that pass vulnerability scanning, originate from the approved registry,
use immutable references, and carry a trusted signature should reach production.

## Pipeline

```text
Developer Commit
      |
      v
Build
      |
      v
Unit Tests
      |
      v
Container Build (multi-stage)
      |
      +----> Secret / IaC / dependency checks
      |
      v
Trivy image scan
      |
      +----> HIGH/CRITICAL policy gate
      |
      v
SBOM generation
      |
      v
Cosign signature / attestation
      |
      v
Push image + digest
      |
      v
Kubernetes admission
      |
      +----> Kyverno verifies signature
      +----> Kyverno rejects unapproved registry
      +----> Kyverno rejects mutable `latest`
      |
      v
Deployment
```

## Image identity

Production deployments should reference an immutable digest:

```text
ghcr.io/finserv-digital/payment-gateway@sha256:<approved-digest>
```

A tag alone is mutable. A digest binds the deployment to a specific image artifact.

## Vulnerability policy

CI blocks images containing unresolved HIGH or CRITICAL vulnerabilities unless there is
an explicitly approved exception.

Exceptions must include:
- CVE
- affected component
- business justification
- compensating control
- owner
- expiry/review date

`--ignore-unfixed` is not the default policy because an unfixed vulnerability is still
risk that must be visible to the risk owner.

## Signing

Cosign is used to sign the image after the image has passed security gates.

The recommended production model is keyless signing through CI identity/OIDC.

The admission policy verifies the expected signer/identity and requires a valid signature.

## Admission

Kyverno is selected instead of OPA/Gatekeeper for this project because it provides
Kubernetes-native YAML policies and image verification capabilities that fit the scope.

The policies in this repository are deliberately separated into:
- registry/tag hygiene
- signature verification

## Separation of duties

- Developer: source changes.
- CI: build, scan and sign.
- Registry: immutable artifact storage.
- Admission: independent deployment gate.
- Platform/Security: policy ownership.

## What this phase does NOT claim

The repository documents the pipeline and admission policy. A live CI runner, registry and
production signing identity must be configured with organization-owned infrastructure before
these controls are treated as operationally active.
