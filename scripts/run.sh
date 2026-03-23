#!/usr/bin/env bash

command_name="${1:-start}"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"
export AMBULANCE_API_MONGODB_USERNAME="root"
export AMBULANCE_API_MONGODB_PASSWORD="secret"

mongo() {
  docker compose --file "${project_root}/deployments/docker-compose/compose.yaml" "$@"
}

case "$command_name" in
  start)
    mongo up --detach
    trap 'mongo down' EXIT
    go run "${project_root}/cmd/ambulance-api-service"
    ;;
  mongo)
    mongo up
    ;;
  openapi)
    docker run --rm -ti -v "${project_root}:/local" openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
    ;;
  *)
    echo "Unknown command: ${command_name}" >&2
    exit 1
    ;;
esac
