#!/usr/bin/env bash
set -euo pipefail

TRACE_TARGET="${TRACE_TARGET:-${1:-example.com}}"
PUBLIC_IP_SERVICE_URL="${PUBLIC_IP_SERVICE_URL:-https://api.ipify.org}"
REPORT_PATH="${NETWORK_REPORT_PATH:-${2:-network-mapping.txt}}"
MAXIMUM_HOPS="${MAXIMUM_HOPS:-20}"
LOCAL_HOST="$(hostname)"
LOCAL_IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
PUBLIC_IP="Unavailable"
if command -v curl >/dev/null; then PUBLIC_IP="$(curl --fail --silent --show-error --max-time 5 "$PUBLIC_IP_SERVICE_URL" 2>/dev/null || printf 'Unavailable')"; fi
{
    printf 'Network mapping report\nGenerated: %s\nLocal host: %s\nLocal IPv4: %s\nPublic IPv4: %s\nTrace target: %s\n\nTrace output:\n' "$(date -u +%FT%TZ)" "$LOCAL_HOST" "$LOCAL_IP" "$PUBLIC_IP" "$TRACE_TARGET"
    if command -v traceroute >/dev/null; then traceroute -n -m "$MAXIMUM_HOPS" "$TRACE_TARGET" || true; else echo 'traceroute is unavailable'; fi
} | tee "$REPORT_PATH"