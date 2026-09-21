# Vault Integration Patterns

## Pattern 1 — Vault Agent Injector (primary)

**Decision:** Use this as the default for application workloads.

Advantages:
- Application remains Vault-unaware.
- Secrets are rendered into an in-memory shared volume.
- Vault Agent handles authentication and renewal.
- Per-Pod ServiceAccounts can map to per-domain Vault roles.

Trade-off:
- Adds a sidecar container to each workload.
- Requires the injector webhook and Vault connectivity.

## Pattern 2 — Vault CSI Provider (secondary)

Use the Vault CSI integration for workloads that primarily need secrets mounted as files
and where avoiding a per-Pod Agent sidecar is desirable.

Advantages:
- Kubernetes-native volume mounting model.
- No Vault Agent sidecar in every application Pod.
- Useful for certificate/file-oriented consumers.

Trade-offs:
- Different lifecycle/renewal semantics from the Agent pattern.
- The application still needs to handle its own behavior when a mounted secret changes.
- Operational teams must understand the CSI driver and SecretProviderClass lifecycle.

## Pattern 3 — External Secrets Operator (evaluated, not selected as the default)

ESO can synchronize external secret material into Kubernetes Secrets. It is useful for
applications that explicitly require a Kubernetes Secret object, but it creates a larger
Kubernetes Secret data footprint.

For FinServ's default pattern, Vault Agent/CSI are preferred so applications do not require
a broad dependency on Kubernetes Secret objects.

## Selection rule

- Application reads files and can use injected material → Vault Agent.
- File/volume-oriented integration and sidecar reduction is important → Vault CSI.
- Legacy integration requires a Kubernetes Secret object → consider ESO with explicit risk review.

No pattern should be used to bypass Vault policy boundaries.
