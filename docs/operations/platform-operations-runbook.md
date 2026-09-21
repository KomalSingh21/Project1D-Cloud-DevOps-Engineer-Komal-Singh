# Platform Operations Runbook

**Scope:** FinServ Digital Kubernetes platform  
**Audience:** Platform engineering, SRE, security operations and approved service owners

## 1. Incident handling principles

- Confirm the affected environment and impact before making changes.
- Preserve evidence before restarting or deleting resources where practical.
- Use approved change references for production actions.
- Prefer reversible actions and document UTC timestamps.
- Never copy secrets or sensitive customer data into tickets or chat.

## 2. First-response checklist

```bash
kubectl config current-context
kubectl get nodes
kubectl get pods -A --field-selector=status.phase!=Running
kubectl get events -A --sort-by=.lastTimestamp
```

Capture:

- environment and cluster
- namespace and workload
- start time and observed symptoms
- recent deployment or configuration changes
- relevant alerts, events and sanitized logs

## 3. Common troubleshooting procedures

### Deployment unavailable

```bash
kubectl rollout status deployment/<name> -n <namespace>
kubectl describe deployment/<name> -n <namespace>
kubectl get rs -n <namespace>
kubectl get pods -n <namespace> -o wide
```

### Pod crash or restart loop

```bash
kubectl describe pod/<pod> -n <namespace>
kubectl logs pod/<pod> -n <namespace> --previous
kubectl get events -n <namespace> --sort-by=.lastTimestamp
```

Check exit codes, probes, missing configuration, memory limits and dependency health.

### Service or DNS issue

```bash
kubectl get service,endpointslice -n <namespace>
kubectl run dns-check --rm -it --image=busybox:1.36 --restart=Never -- nslookup <service>.<namespace>.svc
```

Confirm NetworkPolicy permits DNS TCP and UDP port 53 and that the destination Service has ready endpoints.

### Admission rejection

```bash
kubectl describe pod/<pod> -n <namespace>
kubectl get events -n <namespace>
```

Check image digest, signature identity, PSS settings, resource limits and policy reports. Do not bypass admission controls without security approval.

## 4. Scaling procedures

### Manual scaling

```bash
kubectl scale deployment/<name> --replicas=5 -n <namespace>
kubectl rollout status deployment/<name> -n <namespace>
```

Manual scaling is temporary unless the desired state is updated through Git.

### HPA inspection

```bash
kubectl get hpa -n <namespace>
kubectl describe hpa/<name> -n <namespace>
kubectl top pods -n <namespace>
```

### B3.4 scale-test scenario

Objective: handle a simulated traffic increase up to five times the baseline.

1. Confirm the test namespace and approved load-test window.
2. Record baseline replicas, CPU, memory, latency, error rate and queue depth.
3. Confirm HPA metrics are available.
4. Increase load in controlled stages: 1x → 2x → 3x → 5x.
5. Observe HPA response, scheduling capacity, Pod startup time and application latency.
6. Confirm that ResourceQuota and node capacity do not prevent scale-out.
7. Verify NetworkPolicy, Vault injection and service-mesh sidecars remain healthy.
8. Record saturation points, scaling lag, errors and recovery behavior.
9. Reduce load gradually and confirm scale-in stabilization.
10. Produce a test report with timestamps and dashboard screenshots.

Do not run the scenario against production without written approval.

## 5. Backup and restore

### Backup requirements

- Back up Kubernetes resource definitions and approved configuration through Git.
- Back up stateful data using the approved database-native or storage backup mechanism.
- Encrypt backups in transit and at rest.
- Restrict restore permissions and record every restore action.
- Test restores regularly in an isolated environment.

### Restore sequence

1. Declare the recovery event and identify the recovery point.
2. Confirm backup integrity and encryption-key availability.
3. Restore foundational dependencies first.
4. Restore namespaces, service accounts, policies and configuration.
5. Restore stateful data and validate consistency.
6. Deploy workloads using signed images and approved manifests.
7. Validate DNS, NetworkPolicy, Vault, mTLS and application health.
8. Perform business-level transaction verification.
9. Record RPO/RTO results and obtain service-owner sign-off.

## 6. Certificate rotation

1. Identify certificate, owner, expiry and affected workloads.
2. Generate or request the replacement through the approved PKI process.
3. Validate SANs, trust chain, key usage and expiry.
4. Update the secret through the approved secret-management workflow.
5. Restart or reload workloads only as required.
6. Verify TLS handshakes, mTLS policy and application health.
7. Remove expired material according to retention policy.
8. Record evidence of successful rotation.

## 7. Node maintenance

1. Confirm workload redundancy and PodDisruptionBudgets.
2. Notify stakeholders and open a change record.
3. Cordon the node:

```bash
kubectl cordon <node>
```

4. Drain using approved settings:

```bash
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data
```

5. Perform patching or hardware maintenance.
6. Validate kubelet, runtime, networking, monitoring and security agents.
7. Uncordon after verification:

```bash
kubectl uncordon <node>
```

8. Confirm workloads are balanced and no alerts remain.

## 8. Cluster upgrade procedure

- Review Kubernetes, CNI, CSI, ingress, Vault, Falco and service-mesh compatibility.
- Back up cluster configuration and stateful data.
- Test the upgrade in development and staging.
- Validate admission policies, PSS, NetworkPolicy, DNS, mTLS and observability.
- Upgrade one failure domain at a time where supported.
- Monitor control-plane and node health.
- Run smoke tests and rollback procedures if defined exit criteria are breached.

## 9. Escalation matrix

| Condition | Primary owner | Escalation |
|---|---|---|
| Application crash | Service owner | Platform engineering |
| Admission policy failure | Platform security | Security engineering |
| Falco critical alert | Security operations | Incident commander |
| Node or control-plane failure | SRE/platform | Cloud provider support |
| Suspected data exposure | Security operations | Incident response and compliance |

## 10. Closure requirements

Every operational event must include:

- impact and duration
- commands or approved automation used
- evidence references
- root cause or current hypothesis
- remediation and follow-up actions
- owner and due date
