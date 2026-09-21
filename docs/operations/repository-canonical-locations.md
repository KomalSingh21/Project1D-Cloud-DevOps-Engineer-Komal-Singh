# Repository Canonical Locations

This project uses one canonical location for each deployment artifact type. Namespace security and service-mesh labels are merged into the canonical namespace manifests to prevent duplicate Namespace objects.

| Concern | Canonical location | Guidance |
|---|---|---|
| Namespace definitions and labels | `k8s/namespaces/*-namespaces.yaml` | Contains environment/domain labels, PSS labels, and Istio injection labels. Do not add duplicate Namespace objects elsewhere. |
| Helm chart | `charts/service-template/` | Use this chart for `helm lint` and `helm template`. The top-level `helm/` directory is a submission placeholder only. |
| Standalone HPA manifests | `k8s/autoscaling/` | The active HPA manifest targets the canonical `payment-gateway` Deployment. A transaction-processor HPA is not included until its Deployment is supplied. |
| Falco rules | `k8s/falco/finserv-rules.yaml` | Use this path for FinServ-specific Falco runtime rules. |
| Kubernetes audit policy | `k8s/audit/falco-rules/audit-policy.yaml` | This is the Kubernetes API audit policy, not a Falco runtime rule file; keep it separate. |
| Vault workload example | `k8s/vault/examples/payment-gateway-vault-agent.yaml` | Marked as a non-deployable example and uniquely named to avoid colliding with the canonical workload. |

## Review rule

Do not create a second copy of the same Kubernetes object in another directory. Run duplicate-identity checks before committing.
