#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
find . -type f \( -name '*.yaml' -o -name '*.yml' \) -not -path './.git/*' -print0 | xargs -0 -n1 yamllint
find k8s -type f \( -name '*.yaml' -o -name '*.yml' \) -print0 | xargs -0 kubeconform -strict -summary -ignore-missing-schemas
if command -v helm >/dev/null 2>&1 && [ -d charts/service-template ]; then
  helm lint charts/service-template
  helm template service-template charts/service-template --values charts/service-template/values.yaml >/tmp/service-template-rendered.yaml
fi
