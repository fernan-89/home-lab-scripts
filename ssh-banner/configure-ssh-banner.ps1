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
RESTRICTED ACCESS: AUTHORIZED CREW ONLY
ALL ACTIVITY IS MONITORED, LOGGED AND AUDITED.
UNAUTHORIZED ACCESS WILL BE TRACED AND REPORTED.
DISCONNECT IMMEDIATELY IF YOU ARE NOT AUTHORIZED.
====================================================================
INTERFACE 2037 READY FOR INQUIRY
"@
# Post-login MU/TH/UR 6000 console (Alien / Nostromo theme). Single-quoted here-string: nothing expands now.
# Set MOTHER_TYPE=1 at login for a typewriter effect; NO_COLOR disables colors.
$motd = @'
# shellcheck shell=bash
if [ -z "${MOTHER_FORCE:-}" ]; then
  case $- in *i*) ;; *) return 0 2>/dev/null || exit 0 ;; esac
  [ -t 1 ] || { return 0 2>/dev/null || exit 0; }
fi
[ -n "${MOTHER_SHOWN:-}" ] && { return 0 2>/dev/null || exit 0; }
export MOTHER_SHOWN=1

# --- Phosphor palette (disabled by NO_COLOR or dumb terminals) ---
if [ -z "${NO_COLOR:-}" ] && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  G=$'\033[32m'; GB=$'\033[1;32m'; D=$'\033[2;32m'
  A=$'\033[1;33m'; R=$'\033[1;31m'; N=$'\033[0m'
else
  G=; GB=; D=; A=; R=; N=
fi

W=66
rule() { printf '%s' "$D"; printf '%*s' "$W" '' | tr ' ' "${1:--}"; printf '%s\n' "$N"; }

# type <text>: typewriter effect when MOTHER_TYPE=1, instant otherwise.
type() {
  if [ -n "${MOTHER_TYPE:-}" ]; then
    local s=$1 i
    for ((i=0;i<${#s};i++)); do printf '%s' "${s:i:1}"; sleep 0.012; done
    printf '\n'
  else printf '%s\n' "$1"; fi
}

# line <LABEL> <value>: dotted leader, e.g.  HOST .......... nostromo
line() {
  local label=$1 val=$2 dots
  dots=$(printf '%*s' $((22 - ${#label})) '' | tr ' ' '.')
  type "$(printf ' %s%s%s %s%s%s %s' "$G" "$label" "$N" "$D" "$dots" "$N" "$val")"
}

# gauge <pct> -> [|||||||     ] 42%  (green < 70, amber < 90, red >= 90)
gauge() {
  local p=${1:-0} w=24 f i col
  [ "$p" -gt 100 ] && p=100
  f=$(( p * w / 100 ))
  if   [ "$p" -ge 90 ]; then col=$R
  elif [ "$p" -ge 70 ]; then col=$A
  else col=$GB; fi
  printf '%s[%s' "$D" "$col"
  for ((i=0;i<f;i++));  do printf '|'; done
  printf '%s' "$D"
  for ((i=f;i<w;i++));  do printf ' '; done
  printf ']%s %s%3d%%%s' "$N" "$col" "$p" "$N"
}

# --- Data collection ---
user=${USER:-$(id -un 2>/dev/null)}
host=$(hostname 2>/dev/null)
ip=$(hostname -I 2>/dev/null | awk '{print $1}')
os=$( . /etc/os-release 2>/dev/null && echo "$PRETTY_NAME" )
kernel=$(uname -r)
up=$(uptime -p 2>/dev/null | sed 's/^up //')
cpu_n=$(nproc 2>/dev/null || echo 1)
read -r l1 l5 l15 _ < /proc/loadavg 2>/dev/null
load_pct=$(awk -v l="${l1:-0}" -v n="$cpu_n" 'BEGIN{p=l/n*100; if(p>100)p=100; printf "%d",p}')
mem_pct=$(free 2>/dev/null | awk '/^Mem:/ {printf "%d",$3/$2*100}')
mem_h=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3"/"$2}')
swap_pct=$(free 2>/dev/null | awk '/^Swap:/ {if($2>0) printf "%d",$3/$2*100; else print 0}')
procs=$(ps -e --no-headers 2>/dev/null | wc -l)
failed=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
temp=$(awk '{printf "%.0f", $1/1000}' /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
now=$(date -u '+%Y-%m-%d %H:%M:%S UTC')

# --- Render ---
printf '\n'
rule '='
printf ' %sWEYLAND-YUTANI CORP%s %s//%s %sMU/TH/UR 6000%s %s//%s %sINTERFACE 2037%s\n' "$A" "$N" "$D" "$N" "$GB" "$N" "$D" "$N" "$GB" "$N"
rule '='
type " ${GB}> INQUIRY: CREW IDENTIFICATION${N}"
type " ${G}  ${user}@${host}${N}  ${D}[${now}]${N}"
type " ${GB}> RESPONSE: ACCESS GRANTED${N}"
printf '\n'

type " ${A}[ SHIP STATUS ]${N}"
rule
line "VESSEL"          "${host}"
line "COMM ADDRESS"    "${ip:-N/A}"
line "OPERATING SYSTEM" "${os:-N/A}"
line "KERNEL"          "${kernel}"
line "MISSION ELAPSED" "${up:-N/A}"
printf '\n'

type " ${A}[ PROPULSION / COMPUTE ]${N}"
rule
line "CORES ONLINE"    "${cpu_n}"
line "REACTOR LOAD"    "$(gauge "$load_pct")  ${D}${l1} ${l5} ${l15}${N}"
[ -n "$temp" ] && line "CORE TEMP" "$(gauge "$temp")  ${D}${temp}C${N}"
line "ACTIVE PROCESSES" "${procs}"
printf '\n'

type " ${A}[ LIFE SUPPORT ]${N}"
rule
line "MEMORY"          "$(gauge "${mem_pct:-0}")  ${D}${mem_h}${N}"
line "SWAP RESERVE"    "$(gauge "${swap_pct:-0}")"
printf '\n'

type " ${A}[ CARGO HOLD ]${N}"
rule
while read -r mnt use size used; do
  line "HOLD ${mnt:0:14}" "$(gauge "${use%\%}")  ${D}${used}/${size}${N}"
done < <(df -hP -x tmpfs -x devtmpfs -x squashfs -x overlay 2>/dev/null \
         | awk 'NR>1 && !seen[$1]++ {print $6, $5, $2, $3}' | head -n 4)
printf '\n'

type " ${A}[ CREW MANIFEST ]${N}"
rule
crew=$(who 2>/dev/null | awk '{printf "%s|%s|%s %s\n",$1,$2,$3,$4}')
if [ -n "$crew" ]; then
  while IFS='|' read -r cu ct cw; do line "${cu^^}" "${D}${ct}  since ${cw}${N}"; done <<< "$crew"
else
  line "CREW ABOARD" "${D}NONE${N}"
fi
printf '\n'

rule '='
if [ "${failed:-0}" -gt 0 ]; then
  type " ${R}*** PRIORITY ALERT *** ${failed} SYSTEM UNIT(S) IN FAILED STATE${N}"
  type " ${R}INVESTIGATE ANOMALY: systemctl --failed${N}"
else
  type " ${GB}ALL SYSTEMS NOMINAL${N}"
fi
[ -f /var/run/reboot-required ] && type " ${A}REBOOT PENDING - SCHEDULE CRYOSLEEP CYCLE${N}"
rule '='
printf ' %sINTERFACE 2037 READY FOR INQUIRY%s %s_%s\n\n' "$GB" "$N" "$A" "$N"
unset -f rule type line gauge
'@
$awkProgram = @'
/^#?Banner[[:space:]]/ { next }
!done && /^[[:space:]]*Match[[:space:]]/ { print banner; done = 1 }
{ print }
END { if (!done) print banner }
'@
$tempDir = [System.IO.Path]::GetTempPath()
$tempBanner = Join-Path $tempDir "ssh-banner.txt"
$tempMotd = Join-Path $tempDir "ssh-status.sh"
$tempConfig = Join-Path $tempDir "sshd_config.new"
try {
    # ASCII without BOM and LF endings, so the Linux host reads the files exactly as written.
    [System.IO.File]::WriteAllText($tempBanner, ($banner -replace "`r`n", "`n") + "`n", [System.Text.Encoding]::ASCII)
    [System.IO.File]::WriteAllText($tempMotd, ($motd -replace "`r`n", "`n") + "`n", [System.Text.Encoding]::ASCII)
    # Build the new sshd_config in a temp file: drop active/commented Banner lines and place exactly one
    # Banner directive before the first Match block (or at the end). Validate before touching the real file.
    & sudo awk -v "banner=Banner $BannerPath" ($awkProgram -replace "`r`n", "`n") $SshConfigPath | Set-Content $tempConfig -Encoding ascii
    if ($LASTEXITCODE -ne 0) { throw "Could not read $SshConfigPath." }
    & sudo sshd -t -f $tempConfig
    if ($LASTEXITCODE -ne 0) { throw "Generated SSH configuration is invalid; nothing was changed." }
    & sudo cp $tempBanner $BannerPath
    & sudo cp $SshConfigPath "$SshConfigPath.bak"
    & sudo cp $tempConfig $SshConfigPath
    & sudo cp $tempMotd $MotdPath
    & sudo chmod +x $MotdPath
    if (systemctl is-active --quiet ssh) { & sudo systemctl reload ssh } elseif (systemctl is-active --quiet sshd) { & sudo systemctl reload sshd }
} finally {
    Remove-Item $tempBanner, $tempMotd, $tempConfig -Force -ErrorAction SilentlyContinue
}
Write-Output "SSH banner configured."
