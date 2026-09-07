param(
    [string]$BannerPath = "/etc/ssh/ssh_banner",
    [string]$SshConfigPath = "/etc/ssh/sshd_config",
    [string]$MotdPath = "/etc/profile.d/ssh-status.sh",
    [string]$BannerTitle = $(if ($env:SSH_BANNER_TITLE) { $env:SSH_BANNER_TITLE } else { "AUTHORIZED SYSTEM" })
)
$ErrorActionPreference = "Stop"
if (-not (Get-Command sudo -ErrorAction SilentlyContinue)) { throw "sudo is required on the target system." }
$banner = @"
====================================================================
$BannerTitle
RESTRICTED ACCESS: AUTHORIZED USERS ONLY
ACTIVITY MAY BE MONITORED AND LOGGED
DISCONNECT IMMEDIATELY IF YOU ARE NOT AUTHORIZED.
====================================================================
"@
$motd = @'
#!/usr/bin/env bash
hostname_value=$(hostname)
ip_value=$(hostname -I 2>/dev/null | awk '{print $1}')
uptime_value=$(uptime -p 2>/dev/null || true)
load_value=$(awk '{print $1, $2, $3}' /proc/loadavg 2>/dev/null || true)
memory_value=$(free 2>/dev/null | awk '/Mem:/ {printf "%.0f%%", $3/$2*100}')
disk_value=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')
printf '\nSYSTEM STATUS\nHost: %s\nAddress: %s\nUptime: %s\nLoad: %s\nMemory: %s\nRoot disk: %s\n\n' "$hostname_value" "$ip_value" "$uptime_value" "$load_value" "$memory_value" "$disk_value"
'@
$tempBanner = Join-Path $env:TEMP "ssh-banner.txt"
$tempMotd = Join-Path $env:TEMP "ssh-status.sh"
$banner | Set-Content $tempBanner -Encoding utf8
$motd | Set-Content $tempMotd -Encoding utf8
& sudo cp $tempBanner $BannerPath
& sudo cp $SshConfigPath "$SshConfigPath.bak"
& sudo sed -i '/^Banner /d' $SshConfigPath
& sudo sed -i '/^#Banner /d' $SshConfigPath
"Banner $BannerPath" | & sudo tee -a $SshConfigPath | Out-Null
& sudo cp $tempMotd $MotdPath
& sudo chmod +x $MotdPath
if (systemctl is-active --quiet ssh) { & sudo systemctl reload ssh } elseif (systemctl is-active --quiet sshd) { & sudo systemctl reload sshd }
Write-Output "SSH banner configured."
