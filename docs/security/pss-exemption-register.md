# Pod Security Standards Exemption Register

| ID | Workload | Namespace | Requested exception | Reason | Compensating control | Owner | Expiry |
|---|---|---|---|---|---|---|---|
| EX-001 | None approved | N/A | None | No current exception | N/A | Security Team | N/A |

## Policy

No exemption is automatically approved because an application fails Restricted validation.

The application owner must first demonstrate that:
1. the requirement is technically necessary;
2. the workload cannot be redesigned to meet Restricted;
3. the exception is narrowly scoped;
4. a compensating control exists;
5. the exception has an expiry/review date.

System/infrastructure namespaces may require different treatment and must be documented
separately from application namespace exceptions.
