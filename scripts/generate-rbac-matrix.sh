#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
echo "RBAC source files:"
find k8s/rbac -type f \( -name '*.yaml' -o -name '*.yml' \) -print | sort
echo
echo "Review docs/security/rbac-matrix.md for the approved persona-to-permission matrix."
