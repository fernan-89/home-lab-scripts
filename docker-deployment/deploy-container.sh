#!/usr/bin/env bash
set -euo pipefail
REPOSITORY_URL="${GIT_REPOSITORY_URL:-${1:-}}"
WORKING_DIRECTORY="${APP_DIRECTORY:-${2:-$PWD/source}}"
CONTAINER_NAME="${CONTAINER_NAME:-home-lab-app}"
IMAGE_NAME="${IMAGE_NAME:-home-lab-app:latest}"
MONGODB_URI="${MONGODB_URI:-}"
HOST_PORT="${HOST_PORT:-8080}"
CONTAINER_PORT="${CONTAINER_PORT:-8080}"
[[ -n "$REPOSITORY_URL" ]] || { echo "Set GIT_REPOSITORY_URL or pass the repository URL." >&2; exit 1; }
[[ -n "$MONGODB_URI" ]] || { echo "Set MONGODB_URI before running this script." >&2; exit 1; }
command -v docker >/dev/null || { echo "Docker is required." >&2; exit 1; }
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
docker image rm "$IMAGE_NAME" 2>/dev/null || true
rm -rf -- "$WORKING_DIRECTORY"
git clone "$REPOSITORY_URL" "$WORKING_DIRECTORY"
cd "$WORKING_DIRECTORY"
docker build -t "$IMAGE_NAME" .
docker run -d --name "$CONTAINER_NAME" -p "${HOST_PORT}:${CONTAINER_PORT}" -e "MONGODB_URI=$MONGODB_URI" "$IMAGE_NAME"