#!/usr/bin/env bash
set -euo pipefail
OUTPUT_DIRECTORY="${INVENTORY_OUTPUT_DIRECTORY:-${1:-inventory}}"
mkdir -p "$OUTPUT_DIRECTORY"
command -v jq >/dev/null || { echo "jq is required." >&2; exit 1; }
serial_number="$(dmidecode -s system-serial-number 2>/dev/null | xargs || true)"
manufacturer="$(dmidecode -s system-manufacturer 2>/dev/null | xargs || true)"
model="$(dmidecode -s system-product-name 2>/dev/null | xargs || true)"
processor="$(lscpu 2>/dev/null | awk -F: '/Model name/ {gsub(/^ +/,"",$2); print $2; exit}')"
cores="$(lscpu 2>/dev/null | awk -F: '/^Core\(s\) per socket/ {gsub(/^ +/,"",$2); print $2; exit}')"
threads="$(lscpu 2>/dev/null | awk -F: '/^CPU\(s\)/ {gsub(/^ +/,"",$2); print $2; exit}')"
memory_gb="$(free -g 2>/dev/null | awk '/^Mem:/ {print $2; exit}')"
disk_gb="$(lsblk -b -dno SIZE 2>/dev/null | awk '{sum += $1} END {print int(sum / 1024 / 1024 / 1024)}')"
graphics="$(lspci 2>/dev/null | grep -E 'VGA|3D|Display' | tr '\n' ';' || true)"
base_json="$(jq -n \
    --arg serial "$serial_number" --arg manufacturer "$manufacturer" --arg model "$model" \
    --arg hostname "$(hostname)" --arg os "$(. /etc/os-release 2>/dev/null && printf '%s' "$PRETTY_NAME" || uname -s)" \
    --arg processor "$processor" --arg graphics "$graphics" --argjson cores "${cores:-0}" \
    --argjson threads "${threads:-0}" --argjson memory "${memory_gb:-0}" --argjson disk "${disk_gb:-0}" \
    '{serialNumber:$serial, manufacturerName:$manufacturer, modelName:$model, hostName:$hostname, installedSystem:$os, active:true, specifications:{processorModel:$processor, processorCores:$cores, processorThreads:$threads, memoryTotalGb:$memory, diskTotalGb:$disk, graphicsAdapters:$graphics}}')"
jq '. + {itemType:"REPLACE_WITH_ASSET_TYPE", acquisitionDate:"REPLACE_WITH_DATE", activationDate:"REPLACE_WITH_DATE", warranties:"REPLACE_WITH_WARRANTY_DETAILS"}' <<< "$base_json" > "$OUTPUT_DIRECTORY/inventory-with-placeholders.json"
jq '. + {itemType:null, acquisitionDate:null, activationDate:null, warranties:null}' <<< "$base_json" > "$OUTPUT_DIRECTORY/inventory-with-null-fields.json"