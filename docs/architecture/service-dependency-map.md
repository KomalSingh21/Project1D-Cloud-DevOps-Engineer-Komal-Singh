# FinServ Digital — 20-Service Dependency Map

## Service inventory

| Domain | Services |
|---|---|
| Payments | payment-gateway, transaction-processor, settlement-engine, refund-service, recurring-payments-scheduler |
| Risk & Compliance | fraud-detection, aml-screening, risk-scoring, compliance-reporting, audit-log-aggregator |
| Customer | user-management, kyc-verification, notification, customer-support, preference-manager |
| Platform | api-gateway, service-registry, configuration, health-monitor, report-generator |

## Explicit application dependencies

| Source | Source domain | Destination | Destination domain | Port | Rationale |
|---|---|---|---|---:|---|
| `api-gateway` | Customer | `user-management` | Customer | 8443 | Required application dependency |
| `api-gateway` | Payments | `payment-gateway` | Payments | 8443 | Required application dependency |
| `api-gateway` | Customer | `kyc-verification` | Customer | 8443 | Required application dependency |
| `payment-gateway` | Payments | `transaction-processor` | Payments | 8443 | Required application dependency |
| `payment-gateway` | Risk & Compliance | `fraud-detection` | Risk & Compliance | 8443 | Required application dependency |
| `payment-gateway` | Customer | `notification` | Customer | 8443 | Required application dependency |
| `transaction-processor` | Risk & Compliance | `fraud-detection` | Risk & Compliance | 8443 | Required application dependency |
| `transaction-processor` | Risk & Compliance | `risk-scoring` | Risk & Compliance | 8443 | Required application dependency |
| `transaction-processor` | Payments | `settlement-engine` | Payments | 8443 | Required application dependency |
| `settlement-engine` | Payments | `refund-service` | Payments | 8443 | Required application dependency |
| `refund-service` | Customer | `notification` | Customer | 8443 | Required application dependency |
| `recurring-payments-scheduler` | Payments | `payment-gateway` | Payments | 8443 | Required application dependency |
| `fraud-detection` | Risk & Compliance | `aml-screening` | Risk & Compliance | 8443 | Required application dependency |
| `aml-screening` | Risk & Compliance | `risk-scoring` | Risk & Compliance | 8443 | Required application dependency |
| `risk-scoring` | Risk & Compliance | `audit-log-aggregator` | Risk & Compliance | 8443 | Required application dependency |
| `compliance-reporting` | Risk & Compliance | `audit-log-aggregator` | Risk & Compliance | 8443 | Required application dependency |
| `compliance-reporting` | Customer | `user-management` | Customer | 8443 | Required application dependency |
| `customer-support` | Customer | `user-management` | Customer | 8443 | Required application dependency |
| `preference-manager` | Customer | `notification` | Customer | 8443 | Required application dependency |
| `report-generator` | Risk & Compliance | `audit-log-aggregator` | Risk & Compliance | 8443 | Required application dependency |
| `health-monitor` | Platform | `service-registry` | Platform | 8443 | Required application dependency |

## Security interpretation

Only the listed application paths are intended to be permitted. All other cross-service traffic is denied by default. DNS is a separate infrastructure dependency and is allowed explicitly to kube-dns on TCP/UDP 53. External dependencies are restricted to documented destination CIDRs rather than blanket `0.0.0.0/0` egress.

## External dependencies

| Consumer | Dependency | Example destination CIDR | Port | Reason |
|---|---|---|---:|---|
| `payment-gateway` | External payment processor API | `203.0.113.0/28` | 443 | Authorised payment processing endpoint placeholder |
| `aml-screening` | External AML provider | `198.51.100.0/28` | 443 | Authorised compliance screening endpoint placeholder |
| `notification` | Approved notification provider | `203.0.113.16/28` | 443 | Email/SMS/Push integration placeholder |

> The CIDRs above use documentation address space and are intentionally placeholders. They must be replaced with the real approved provider CIDRs before production use.

## Policy rule principle

For every application dependency, both sides must be represented: the source workload needs egress permission and the destination workload needs ingress permission. This makes the communication contract reviewable and avoids relying on an implicit allow.