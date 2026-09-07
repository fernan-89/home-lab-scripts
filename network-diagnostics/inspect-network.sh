#!/usr/bin/env bash
set -euo pipefail
PROBE_HOST="${NETWORK_PROBE_HOST:-${1:-example.com}}"
OUTPUT_FILE="${NETWORK_OUTPUT_FILE:-network-report.txt}"
command -v ping >/dev/null || { echo "ping is required." >&2; exit 1; }
{
    printf 'Network report\nTimestamp: %s\nProbe host: %s\n\n' "$(date -u +%FT%TZ)" "$PROBE_HOST"
    printf 'Addresses:\n'; (ip -brief address 2>/dev/null || hostname -I 2>/dev/null || true)
    printf '\nPing:\n'; ping -c 2 "$PROBE_HOST" || true
    printf '\nTrace:\n'; if command -v traceroute >/dev/null; then traceroute -m 8 "$PROBE_HOST" || true; else echo 'traceroute unavailable'; fi
} > "$OUTPUT_FILE"