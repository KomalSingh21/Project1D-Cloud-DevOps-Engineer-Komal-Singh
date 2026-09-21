# FinServ Digital — HashiCorp Vault Secrets Management Architecture

## Purpose

This document defines the Phase 2 secrets-management architecture for FinServ Digital.
The design replaces application credentials stored in environment variables or Kubernetes
Secrets with HashiCorp Vault as the system of record for sensitive application material.

The primary integration pattern is the Vault Agent Injector with Kubernetes authentication.
A secondary pattern is the Vault CSI Provider for workloads that need file-mounted secrets
without a persistent Vault Agent sidecar.

## Security objectives

- No application secret values are committed to Git.
- No application workload receives a broad Vault policy.
- Vault access is tied to a dedicated Kubernetes ServiceAccount.
- Policies are separated by business domain.
- Short-lived/dynamic credentials are preferred where supported.
- Vault audit logging is enabled for secret access.
- Production access is separated from development and staging.
- TLS is required between workloads and Vault.
- Applications consume rendered files rather than calling Vault directly in the default pattern.

## Vault logical layout

```text
Vault
├── auth/
│   └── kubernetes/
│
├── secret/
│   └── data/
│       ├── payments/
│       ├── risk/
│       ├── customer/
│       └── platform/
│
└── transit/
    ├── payments-key
    ├── risk-key
    ├── customer-key
    └── platform-key
```

The KV v2 path convention used by this project is `secret/data/<domain>/*`.

## Domain isolation

| Domain | Example workload | Vault policy |
|---|---|---|
| payments | payment-gateway | `finserv-payments` |
| risk | fraud-detection | `finserv-risk` |
| customer | user-management | `finserv-customer` |
| platform | api-gateway | `finserv-platform` |

A payment workload cannot use the payments policy to read `secret/data/risk/*`.

## Primary pattern — Vault Agent Injector

```text
Kubernetes Pod
┌──────────────────────────────────────────────┐
│ Application container                        │
│ reads /vault/secrets/*                       │
│                                              │
│   shared in-memory volume                    │
│              ▲                               │
│              │                               │
│ Vault Agent sidecar                          │
│  1. authenticate using Pod ServiceAccount   │
│  2. obtain Vault token                       │
│  3. render secret templates                  │
│  4. renew/refresh as configured              │
└──────────────┬───────────────────────────────┘
               │ TLS
               ▼
        HashiCorp Vault
               │
               ▼
        domain-scoped policy
```

The Vault Agent Injector is a mutating webhook. Pod annotations request injection.
The Agent authenticates through the Kubernetes auth method and renders secrets into a
shared in-memory volume.

## Authentication flow

1. Workload starts with a dedicated ServiceAccount.
2. Vault Agent receives the ServiceAccount token.
3. Vault Kubernetes auth validates the identity through Kubernetes TokenReview.
4. The ServiceAccount is mapped to a Vault role.
5. The role attaches only the required domain policy.
6. Vault Agent receives a short-lived token.
7. Requested secrets are rendered into `/vault/secrets/`.
8. The application reads the rendered file.
9. Agent renewal/rotation occurs without embedding long-lived credentials in the image.

## Secret classes

### Static application configuration

Use KV v2 for values such as:

- external API credentials
- non-public configuration secrets
- third-party client credentials

### Dynamic credentials

Prefer Vault dynamic secrets for:

- database credentials
- short-lived service credentials
- credentials where the target system supports automated rotation

### Cryptographic operations

Use the Transit engine when the application needs:

- encryption/decryption
- signing/verification

The application should not receive the underlying encryption key.

## Production controls

- Vault runs with HA storage and encrypted persistent storage.
- Vault TLS certificates are managed through the platform certificate process.
- Vault audit devices are enabled.
- Vault administrative access is restricted to the platform/security team.
- Production policies are not shared with development.
- Break-glass access is time-bound and audited.
- Vault backups and recovery are documented separately from Kubernetes etcd backups.

## What this phase does NOT claim

This repository documents the architecture and policy model. It does not claim that a live
Vault cluster has been deployed or that production secrets have been provisioned.

## Day 6 success criteria

- Four domain policies exist.
- Kubernetes auth mapping is documented.
- Agent Injector is documented with an example.
- At least one secondary integration pattern is documented.
- Developer onboarding removes unnecessary manual secret-management steps.
- The developer revolt scenario is addressed without weakening production security.
