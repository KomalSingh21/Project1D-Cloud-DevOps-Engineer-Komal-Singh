# Day 14 Quality Checklist

## Manifest review

- [ ] YAML syntax checked for every YAML file.
- [ ] Kubernetes schemas validated with kubeconform or kubeval against the target version.
- [x] Namespaces, labels, selectors, and namespace references are reviewed; canonical Namespace files contain PSS and Istio labels.
- [ ] RBAC subjects, role references, and scope are reviewed.
- [ ] NetworkPolicy selectors, ports, DNS rules, and external CIDRs are reviewed.
- [ ] Vault annotations and service-account references are consistent.
- [ ] Admission policies are checked for placeholders and policy-engine compatibility.
- [ ] PSS labels and workload security contexts are aligned.
- [x] HPA metrics and metrics-server prerequisites are documented; only the HPA with an included Deployment remains.
- [x] Service-mesh labels and traffic-policy assumptions are documented in the canonical namespace and service-mesh files.
- [ ] No plaintext credentials, tokens, private keys, or production secrets are committed.

## Documentation review

- [ ] README, SUBMISSION, and `.zetheta-project.json` agree on scope and status.
- [ ] B3.2, B3.3, B3.4, and B3.5 responses are traceable.
- [ ] Operational procedures include prerequisites, rollback, escalation, and evidence capture.
- [ ] Diagram prompts and exported diagrams are present or explicitly marked pending.
- [x] Required filenames and directory names are consistent; duplicate Namespace manifests were removed.

## Repository hygiene

- [x] Temporary archives and editor files are excluded.
- [ ] `.gitignore` covers secrets, state files, keys, caches, and local environments.
- [ ] Git status is clean after final commit.
- [ ] Repository topics are configured.
- [ ] Authorized collaborators and ownership-transfer instructions are verified.
