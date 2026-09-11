# RBAC Permission Verification

## Purpose

This document records the Day 4 validation method. Tests should be executed against each environment after the RBAC manifests are applied.

## Positive tests

| Identity | Namespace | Expected |
|---|---|---|
| Dev developer group | matching dev namespace | `get pods` = yes |
| Dev developer group | matching dev namespace | `get pods/log` = yes |
| Dev developer group | matching dev namespace | `create pods/exec` = yes |
| Prod developer group | matching prod namespace | `get pods` = yes |
| Security auditor group | any application namespace | `get networkpolicies` = yes |
| Monitoring service account | application namespace | `get pods` = yes |

## Negative tests

| Identity | Action | Expected |
|---|---|---|
| Prod developer group | `create pods/exec` | no |
| Developer group | `get secrets` | no |
| CI/CD service account | `get secrets` | no |
| Monitoring service account | `get secrets` | no |
| Security auditor group | `delete deployments` | no |
| Dev CI/CD identity | deploy to staging/prod | no by identity design |

## Evidence capture

For each executed command, record:

- cluster/context
- namespace
- identity
- command
- expected result
- actual result
- timestamp

Do not store bearer tokens, kubeconfig contents, client certificates, or Secret values in this repository.
