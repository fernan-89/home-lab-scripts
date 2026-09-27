#!/usr/bin/env bash
set -euo pipefail
PROBE_HOSTS="${NETWORK_PROBE_HOSTS:-${1:-example.com}}"
COUNT="${PING_COUNT:-4}"
OUTPUT_FILE="${NETWORK_OUTPUT_FILE:-network-performance.txt}"
{ printf 'Network performance report\nHosts: %s\nTimestamp: %s\n\n' "$PROBE_HOSTS" "$(date -u +%FT%TZ)"; IFS=',' read -ra hosts <<< "$PROBE_HOSTS"; for host in "${hosts[@]}"; do printf '--- %s ---\n' "$host"; ping -c "$COUNT" "$host" || true; done; if [[ -n "${NETWORK_TEST_URLS:-}" ]] && command -v curl >/dev/null; then printf '\nDownload tests:\n'; IFS=',' read -ra urls <<< "$NETWORK_TEST_URLS"; for url in "${urls[@]}"; do curl --fail --silent --show-error --max-time 30 -o /dev/null -w '%{url_effective} %{size_download} bytes %{time_total}s\n' "$url" || true; done; fi; } > "$OUTPUT_FILE"