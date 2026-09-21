# Manifest Validation Report

## Commands to execute from the repository root

```bash
find . -type f \( -name '*.yaml' -o -name '*.yml' \) -not -path './.git/*' -print0 | xargs -0 -n1 yamllint
find k8s -type f \( -name '*.yaml' -o -name '*.yml' \) -print0 | xargs -0 kubeconform -strict -summary -ignore-missing-schemas
helm lint charts/service-template
helm template service-template charts/service-template --values charts/service-template/values.yaml
```

If `kubeconform` is not installed, use the approved `kubeval` alternative and record its schema/version behavior.

## Evidence record

| Check | Status | Evidence required |
|---|---|---|
| YAML syntax | Pending execution | Command output and timestamp |
| kubeconform/kubeval | Pending execution | Tool version, Kubernetes schema version, output |
| Helm lint | Pending execution | Helm version and output |
| Helm render | Pending execution | Rendered manifest review |
| Policy validation | Pending execution | Kyverno/Gatekeeper results |
| Runtime integration | Pending execution | Cluster evidence for Vault, network, Falco, mesh, and HPA |

Do not mark a check as passed until the command has actually run and the output has been retained.


## Canonical artifact locations

See `docs/operations/repository-canonical-locations.md` for the approved Helm, HPA, Falco, and audit-policy locations.
## Day 14 structural corrections applied

- Namespace security and Istio injection labels are merged into `k8s/namespaces/*-namespaces.yaml`.
- Duplicate Namespace manifests were removed from `k8s/pod-security/` and `k8s/service-mesh/`.
- The transaction-processor HPA was removed because no corresponding Deployment is included; it must be added only with its workload manifest.
- The Vault workload example has a unique name and is marked non-deployable to prevent object collisions.

These corrections are repository-level changes; kubeconform, Helm, and live-cluster validation must still be executed locally.
