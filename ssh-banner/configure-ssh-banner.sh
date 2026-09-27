#!/usr/bin/env bash
set -euo pipefail

BANNER_PATH="${BANNER_PATH:-/etc/ssh/ssh_banner}"
SSH_CONFIG_PATH="${SSH_CONFIG_PATH:-/etc/ssh/sshd_config}"
MOTD_PATH="${MOTD_PATH:-/etc/profile.d/ssh-status.sh}"
BANNER_TITLE="${SSH_BANNER_TITLE:-AUTHORIZED SYSTEM}"
command -v sudo >/dev/null || { echo "sudo is required." >&2; exit 1; }
TEMP_BANNER="$(mktemp)"
TEMP_MOTD="$(mktemp)"
trap 'rm -f "$TEMP_BANNER" "$TEMP_MOTD"' EXIT
cat > "$TEMP_BANNER" <<EOF
====================================================================
$BANNER_TITLE
RESTRICTED ACCESS: AUTHORIZED USERS ONLY
ACTIVITY MAY BE MONITORED AND LOGGED
DISCONNECT IMMEDIATELY IF YOU ARE NOT AUTHORIZED.
====================================================================
EOF
cat > "$TEMP_MOTD" <<'EOF'
#!/usr/bin/env bash
hostname_value=$(hostname)
ip_value=$(hostname -I 2>/dev/null | awk '{print $1}')
uptime_value=$(uptime -p 2>/dev/null || true)
load_value=$(awk '{print $1, $2, $3}' /proc/loadavg 2>/dev/null || true)
memory_value=$(free 2>/dev/null | awk '/Mem:/ {printf "%.0f%%", $3/$2*100}')
disk_value=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')
printf '\nSYSTEM STATUS\nHost: %s\nAddress: %s\nUptime: %s\nLoad: %s\nMemory: %s\nRoot disk: %s\n\n' "$hostname_value" "$ip_value" "$uptime_value" "$load_value" "$memory_value" "$disk_value"
EOF
sudo cp "$TEMP_BANNER" "$BANNER_PATH"
sudo cp "$SSH_CONFIG_PATH" "$SSH_CONFIG_PATH.bak"
sudo sed -i '/^Banner /d' "$SSH_CONFIG_PATH"
sudo sed -i '/^#Banner /d' "$SSH_CONFIG_PATH"
printf 'Banner %s\n' "$BANNER_PATH" | sudo tee -a "$SSH_CONFIG_PATH" >/dev/null
sudo cp "$TEMP_MOTD" "$MOTD_PATH"
sudo chmod +x "$MOTD_PATH"
if systemctl is-active --quiet ssh; then sudo systemctl reload ssh; elif systemctl is-active --quiet sshd; then sudo systemctl reload sshd; fi
echo "SSH banner configured."
