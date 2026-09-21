# YAML Validation Report

## Purpose

Record syntax and schema validation for Kubernetes and policy YAML files in the repository.

## Validation commands

Run from the repository root:

```bash
find k8s charts ci config -type f \( -name '*.yaml' -o -name '*.yml' \) -print
```

If `yamllint` is available:

```bash
yamllint k8s charts ci config
```

If `kubeconform` is available:

```bash
find k8s -type f -name '*.yaml' -print0 | \
  xargs -0 kubeconform -strict -ignore-missing-schemas
```

For Helm templates:

```bash
helm lint charts/service-template
helm template finserv-service charts/service-template > /tmp/finserv-service-rendered.yaml
kubeconform -strict -ignore-missing-schemas /tmp/finserv-service-rendered.yaml
```

## Results

| Validation type | Scope | Result | Date | Notes |
|---|---|---|---|---|
| YAML syntax | Phase 2 package | Pass — 13 files checked | 2026-09-21 | Syntax only; not cluster validation |
| YAML syntax | Days 11–13 additions | To execute | Pending | Run `yamllint` or equivalent |
| Kubernetes schema | Kubernetes manifests | To execute | Pending | Use target cluster version |
| Helm lint | Service template | To execute | Pending | Requires Helm 3 |
| Rendered schema | Helm output | To execute | Pending | Requires kubeconform |
| Policy validation | Kyverno/Falco/Istio | To execute | Pending | Requires compatible tools and versions |

## Interpretation

A syntax pass does not prove that a manifest is accepted by the Kubernetes API or that a security policy behaves as intended. Record failures, tool versions, command output and remediation commits.
