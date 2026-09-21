# Day 14 Quality Checklist

## Manifest review

- [x] YAML syntax checked for every YAML file.
- [x] Kubernetes schemas validated with kubeconform or kubeval against the target version.
- [x] Namespaces, labels, selectors, and namespace references are reviewed; canonical Namespace files contain PSS and Istio labels.
- [x] RBAC subjects, role references, and scope are reviewed.
- [x] NetworkPolicy selectors, ports, DNS rules, and external CIDRs are reviewed.
- [x] Vault annotations and service-account references are consistent.
- [x] Admission policies are checked for placeholders and policy-engine compatibility.
- [x] PSS labels and workload security contexts are aligned.
- [x] HPA metrics and metrics-server prerequisites are documented; only the HPA with an included Deployment remains.
- [x] Service-mesh labels and traffic-policy assumptions are documented in the canonical namespace and service-mesh files.
- [x] No plaintext credentials, tokens, private keys, or production secrets are committed.

## Documentation review

- [x] README, SUBMISSION, and `.zetheta-project.json` agree on scope and status.
- [x] B3.2, B3.3, B3.4, and B3.5 responses are traceable.
- [x] Operational procedures include prerequisites, rollback, escalation, and evidence capture.
- [x] Required filenames and directory names are consistent; duplicate Namespace manifests were removed.

## Repository hygiene

- [x] Temporary archives and editor files are excluded.
- [x] `.gitignore` covers secrets, state files, keys, caches, and local environments.
- [x] Git status is clean after final commit.
- [x] Repository topics are configured.
- [x] Authorized collaborators and ownership-transfer instructions are verified.
