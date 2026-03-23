#!/usr/bin/env bash
set -euo pipefail

command_name="${1:-start}"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"

case "$command_name" in
  start)
    go run "${project_root}/cmd/ambulance-api-service"
    ;;
  openapi)
    docker run --rm -ti -v "${project_root}:/local" openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
    ;;
  *)
    echo "Unknown command: ${command_name}" >&2
    exit 1
    ;;
esac
