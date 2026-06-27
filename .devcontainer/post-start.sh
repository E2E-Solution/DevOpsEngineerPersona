#!/bin/bash
# Dev Container post-start hook.
# Starts local emulators and waits until their health checks pass.
set -euo pipefail

export DOCKER_CLI_HINTS=false

echo "🐳 Starting local emulator containers..."

if docker compose up -d --wait --wait-timeout 180; then
  docker compose ps
  echo "🎁 Dev environment ready! Press F5 to start debugging."
  exit 0
fi

cosmos_status="$({ docker inspect cosmosdb-emulator --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}'; } 2>/dev/null || true)"

if [[ "${cosmos_status}" == "unhealthy" ]]; then
  echo "⚠️ Cosmos DB emulator did not become healthy. Recreating it to clear stale local startup state..."
  docker compose up -d --force-recreate --wait --wait-timeout 180 cosmos-db
  docker compose up -d --wait --wait-timeout 180
  docker compose ps
  echo "🎁 Dev environment ready! Press F5 to start debugging."
  exit 0
fi

echo "❌ Local emulator containers did not become healthy."
docker compose ps
exit 1