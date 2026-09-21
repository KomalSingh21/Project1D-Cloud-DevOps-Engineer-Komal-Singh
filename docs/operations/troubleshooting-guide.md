# Troubleshooting Guide

This guide provides first-response checks for the security-hardened FinServ Digital Kubernetes platform. Commands are examples and must be executed only against an authorised environment.

## 1. Manifest validation failures

```bash
./scripts/validate-manifests.sh
```

- Confirm `yamllint` and `kubeconform` are installed.
- Review the first reported file and line number.
- Check API versions, required metadata, indentation, and duplicate YAML keys.
- Treat `--ignore-missing-schemas` output as structural validation, not proof of live-cluster compatibility.

## 2. Helm chart problems

```bash
helm lint charts/service-template
helm template finserv-service charts/service-template --values charts/service-template/values.yaml
```

- Verify values keys match the templates.
- Confirm rendered resources have names, namespaces, selectors, and resource requests/limits.
- Review rendered output before applying it.

## 3. HPA not scaling

```bash
kubectl get hpa -A
kubectl describe hpa <hpa-name> -n <namespace>
kubectl top pods -n <namespace>
```

- Confirm Metrics Server is available.
- Confirm the target Deployment exists and selector labels match. The repository currently provides the `payment-gateway` HPA only; add a transaction-processor HPA after its Deployment is defined.
- Confirm CPU/memory requests are defined when the HPA uses resource utilisation.
- Review HPA events and current/desired replica counts.

## 4. NetworkPolicy connectivity issue

```bash
kubectl get networkpolicy -A
kubectl describe networkpolicy <policy-name> -n <namespace>
kubectl get pods -n <namespace> --show-labels
```

- Confirm the namespace has the expected labels.
- Check both ingress and egress rules.
- Validate pod labels and named ports.
- Test only from an authorised diagnostic pod.

## 5. Vault secret injection issue

```bash
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> -c vault-agent
```

- Confirm the service account and Vault role match.
- Verify the secret path and policy permissions.
- Check injector annotations and pod events.
- Never print secret values into logs or tickets.

## 6. Falco alert investigation

- Record the alert timestamp, namespace, workload, pod, node, and rule name.
- Preserve relevant Kubernetes audit and workload logs.
- Follow `docs/security/incident-response-playbook.md`.
- Do not disable detection rules as a first response; tune only through an approved change.

## 7. Evidence handling

- Store command output with timestamp, operator, environment, and scope.
- Mark evidence as design, test result, or production observation.
- Redact credentials, tokens, personal data, and payment information.
