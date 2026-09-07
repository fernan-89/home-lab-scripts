#!/usr/bin/env bash
set -euo pipefail

BASE_PATH="${DRIVER_BASE_PATH:-${1:-}}"
APPLY="${APPLY_CHANGES:-false}"
[[ -n "$BASE_PATH" && -d "$BASE_PATH" ]] || { echo "Provide an existing driver directory as the first argument or DRIVER_BASE_PATH." >&2; exit 1; }

declare -A NAME_MAP=(
    ["HPE Office Connect Oc20 APP"]="HPE - OfficeConnect OC20 - Access Point App"
    ["M75n Desktop (ThinkCentre) - Type 11GX"]="Lenovo - ThinkCentre M75n - Desktop Nano - Type 11GX"
    ["M75q Gen 2 (Type 11JN, 11JQ, 11JR, 11JS) Desktop (ThinkCentre) - Type 11JQ"]="Lenovo - ThinkCentre M75q Gen 2 - Desktop Tiny - Type 11JQ"
    ["M910s Desktop (ThinkCentre) - Type 10ML"]="Lenovo - ThinkCentre M910s - Desktop SFF - Type 10ML"
    ["NVIDIA Quadro K2000 - Release Windows 10 R352 WQHL"]="NVIDIA - Quadro K2000 - Windows 10 Driver R352 WHQL"
    ["P1 Gen 2 (Type 20QT, 20QU) Laptop (ThinkPad) - Type 20QU"]="Lenovo - ThinkPad P1 Gen 2 - Mobile Workstation - Type 20QU"
    ["P1 Gen 6 (Type 21FV, 21FW) Laptop (ThinkPad) - Type 21FW"]="Lenovo - ThinkPad P1 Gen 6 - Mobile Workstation - Type 21FW"
    ["P520 Workstation (ThinkStation) - Type 30BF"]="Lenovo - ThinkStation P520 - Workstation Tower - Type 30BF"
    ["T590 (Type 20N4, 20N5) Laptop (ThinkPad) - Type 20N5"]="Lenovo - ThinkPad T590 - Laptop - Type 20N5"
    ["ThinkPad Thunderbolt 3 Workstation Dock Gen 2 - Type 40AN"]="Lenovo - ThinkPad Thunderbolt 3 Workstation Dock Gen 2 - Type 40AN"
    ["ThinkPad UltraSlim DVD Burner"]="Lenovo - ThinkPad UltraSlim - External DVD Burner"
    ["ThinkPad X1 Yoga 6th Gen (Type 20XY, 20Y0) Laptop (ThinkPad) - Type 20Y0"]="Lenovo - ThinkPad X1 Yoga Gen 6 - Convertible Laptop - Type 20Y0"
    ["ThinkVision M15 - Type 62CA"]="Lenovo - ThinkVision M15 - Portable Monitor - Type 62CA"
    ["ThinkVision T27i-30 - Type 63A4"]="Lenovo - ThinkVision T27i-30 - 27-inch FHD Monitor - Type 63A4"
    ["Tp-Link  Wi-fi 6 Ax3000 Archer Tx50e"]="TP-Link - Archer TX50E - Wi-Fi 6 AX3000 PCIe Adapter"
    ["Wacom Intuos CTL4100 Small"]="Wacom - Intuos CTL-4100 - Small Pen Tablet"
)

declare -a CURRENT_NAMES NEW_NAMES
while IFS= read -r -d '' folder; do
    current_name="${folder##*/}"
    normalized_name="$(printf '%s' "$current_name" | tr -s ' ')"
    if [[ -n "${NAME_MAP[$normalized_name]+x}" && "$current_name" != "${NAME_MAP[$normalized_name]}" ]]; then
        CURRENT_NAMES+=("$current_name")
        NEW_NAMES+=("${NAME_MAP[$normalized_name]}")
        printf "Proposed: '%s' -> '%s'\n" "$current_name" "${NAME_MAP[$normalized_name]}"
    fi
done < <(find "$BASE_PATH" -mindepth 1 -maxdepth 1 -type d -print0)

if ((${#CURRENT_NAMES[@]} == 0)); then
    echo "No driver folders require renaming."
    exit 0
fi
if [[ "$APPLY" != "true" ]]; then
    echo "Dry run only. Set APPLY_CHANGES=true to rename the folders."
    exit 0
fi
for index in "${!CURRENT_NAMES[@]}"; do
    mv -- "$BASE_PATH/${CURRENT_NAMES[$index]}" "$BASE_PATH/${NEW_NAMES[$index]}"
    printf "Renamed: '%s'\n" "${NEW_NAMES[$index]}"
done