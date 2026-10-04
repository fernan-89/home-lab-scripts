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
# Set MOTHER_FAST=1 at login to skip the boot animation; NO_COLOR disables colors.
$motd = @'
# shellcheck shell=bash
# MU/TH/UR 6000 login console (Alien / USCSS Nostromo). Sourced from /etc/profile.d at login.
# MOTHER_FAST=1 skips animations. NO_COLOR disables colors. MOTHER_FORCE=1 bypasses the TTY check.
if [ -z "${MOTHER_FORCE:-}" ]; then
  case $- in *i*) ;; *) return 0 2>/dev/null || exit 0 ;; esac
  [ -t 1 ] || { return 0 2>/dev/null || exit 0; }
fi
[ -n "${MOTHER_SHOWN:-}" ] && { return 0 2>/dev/null || exit 0; }
export MOTHER_SHOWN=1

# --- Phosphor palette ---
if [ -z "${NO_COLOR:-}" ] && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  G=$'\033[32m'; GB=$'\033[1;32m'; D=$'\033[2;32m'
  A=$'\033[1;33m'; R=$'\033[1;31m'; BL=$'\033[5;1;32m'; N=$'\033[0m'
else
  G=; GB=; D=; A=; R=; BL=; N=
fi
W=70

nap()  { [ -n "${MOTHER_FAST:-}" ] || sleep "$1" 2>/dev/null; }
rule() { printf '%s' "$D"; printf '%*s' "$W" '' | tr ' ' "${1:--}"; printf '%s\n' "$N"; }
say()  { printf '%s\n' "$1"; nap 0.025; }

# typed <color> <text>: typewriter effect, one character at a time.
typed() {
  local s=$2 i
  printf '%s' "$1"
  if [ -n "${MOTHER_FAST:-}" ]; then printf '%s' "$s"
  else for ((i=0;i<${#s};i++)); do printf '%s' "${s:i:1}"; sleep 0.018 2>/dev/null; done; fi
  printf '%s\n' "$N"
}

# boot <label>: dotted leader that fills in, then OK.
boot() {
  local label=$1 n i
  n=$((W - 8 - ${#label}))
  printf ' %s> %s%s %s' "$GB" "$label" "$N" "$D"
  for ((i=0;i<n;i++)); do printf '.'; nap 0.006; done
  nap 0.12
  printf '%s %sOK%s\n' "$N" "$GB" "$N"
}

sec()  { printf '\n'; say " ${A}[ $1 ]${N}"; rule; }
line() {
  local label=$1 val=$2 dots
  dots=$(printf '%*s' $((24 - ${#label})) '' | tr ' ' '.')
  say "$(printf ' %s%s%s %s%s%s %s' "$G" "$label" "$N" "$D" "$dots" "$N" "$val")"
}
# gauge <pct>: [||||||      ] 42%  (green < 70, amber < 90, red >= 90)
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

# --- Data collection (every source is optional) ---
user=${USER:-$(id -un 2>/dev/null)}
host=$(hostname 2>/dev/null)
groups_=$(id -nG 2>/dev/null)
if   [ "$(id -u 2>/dev/null)" = 0 ]; then rank="CAPTAIN"; clr=5
elif case " $groups_ " in *" sudo "*|*" admin "*|*" wheel "*) true;; *) false;; esac; then rank="EXECUTIVE OFFICER"; clr=4
else rank="CREW MEMBER"; clr=2; fi
os=$( . /etc/os-release 2>/dev/null && echo "$PRETTY_NAME" )
kernel=$(uname -r)
secs=$(cut -d. -f1 /proc/uptime 2>/dev/null || echo 0)
mday=$(( secs / 86400 + 1 ))
up=$(uptime -p 2>/dev/null | sed 's/^up //')
cpu_n=$(nproc 2>/dev/null || echo 1)
cpu_model=$(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo 2>/dev/null | sed 's/(R)//g;s/(TM)//g;s/  */ /g')
read -r l1 l5 l15 _ < /proc/loadavg 2>/dev/null
load_pct=$(awk -v l="${l1:-0}" -v n="$cpu_n" 'BEGIN{p=l/n*100; if(p>100)p=100; printf "%d",p}')
mem_pct=$(free 2>/dev/null | awk '/^Mem:/ {printf "%d",$3/$2*100}')
mem_h=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3"/"$2}')
swap_pct=$(free 2>/dev/null | awk '/^Swap:/ {if($2>0) printf "%d",$3/$2*100; else print 0}')
procs=$(ps -e --no-headers 2>/dev/null | wc -l)
temp=$(awk '{printf "%.0f", $1/1000}' /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
failed=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
chan=$(ss -H -tln 2>/dev/null | wc -l)
upd=$(awk '/updates? can be applied/ {print $1; exit}' /var/lib/update-notifier/updates-available 2>/dev/null)
pods=
if command -v docker >/dev/null 2>&1; then pods=$(timeout 2 docker ps -q 2>/dev/null | wc -l); fi
intr=
if journalctl -q -n1 --no-pager >/dev/null 2>&1; then
  intr=$(journalctl -q --no-pager --since '-24h' _COMM=sshd _COMM=sshd-session 2>/dev/null | grep -c 'Failed password' || true)
fi
now=$(date -u '+%Y-%m-%d %H:%M:%S UTC')

# --- Render ---
printf '\n'
rule '='
say " ${A}WEYLAND-YUTANI CORP${N}  ${D}//${N}  ${GB}COMMON CARRIER${N}  ${D}//${N}  ${GB}BUILDING BETTER WORLDS${N}"
rule '='
printf '%s' "$GB"
cat <<'ART'
  _   _  ___  ____ _____ ____   ___  __  __  ___
 | \ | |/ _ \/ ___|_   _|  _ \ / _ \|  \/  |/ _ \
 |  \| | | | \___ \ | | | |_) | | | | |\/| | | | |
 | |\  | |_| |___) || | |  _ <| |_| | |  | | |_| |
 |_| \_|\___/|____/ |_| |_| \_\\___/|_|  |_|\___/
ART
printf '%s' "$N"
say " ${D}USCSS NOSTROMO  //  REG 180924609  //  COMMERCIAL TOWING VEHICLE${N}"
rule '='
printf '\n'
boot "ESTABLISHING UPLINK TO MU/TH/UR 6000"
boot "AUTHENTICATING CREW CREDENTIALS"
boot "SYNCHRONIZING SHIP CHRONOMETER"
boot "LOADING SYSTEMS TELEMETRY"
printf '\n'
typed "$GB" " > INQUIRY: CREW IDENTIFICATION"
typed "$G"  "   ${user} @ ${host}"
nap 0.3
typed "$GB" " > RESPONSE: IDENTITY CONFIRMED"
typed "$G"  "   RANK: ${rank}   CLEARANCE: LEVEL ${clr}   ${now}"

sec "SHIP STATUS"
line "VESSEL"           "${host}"
line "OPERATING SYSTEM" "${os:-N/A}"
line "KERNEL"           "${kernel}"
line "MISSION DAY"      "${mday}  ${D}(${up:-N/A})${N}"
[ -n "$upd" ] && line "SUPPLY STATUS" "$( [ "$upd" -gt 0 ] && echo "${A}${upd} PACKAGE UPDATE(S) PENDING${N}" || echo "${GB}CURRENT${N}")"

sec "PROPULSION / COMPUTE"
line "PROCESSOR"        "${cpu_n}x ${D}${cpu_model:-N/A}${N}"
line "REACTOR LOAD"     "$(gauge "$load_pct")  ${D}${l1} ${l5} ${l15}${N}"
[ -n "$temp" ] && line "CORE TEMPERATURE" "$(gauge "$temp")  ${D}${temp}C${N}"
line "ACTIVE PROCESSES" "${procs}"

sec "LIFE SUPPORT"
line "MEMORY"           "$(gauge "${mem_pct:-0}")  ${D}${mem_h}${N}"
line "SWAP RESERVE"     "$(gauge "${swap_pct:-0}")"

sec "CARGO HOLD"
while read -r mnt use size used; do
  line "HOLD ${mnt:0:16}" "$(gauge "${use%\%}")  ${D}${used}/${size}${N}"
done < <(df -hP -x tmpfs -x devtmpfs -x squashfs -x overlay 2>/dev/null \
         | awk 'NR>1 && !seen[$1]++ {print $6, $5, $2, $3}' | head -n 4)
[ -n "$pods" ] && line "CRYOPODS ACTIVE" "${pods}  ${D}(containers)${N}"

sec "COMMUNICATIONS"
while read -r ifc addr; do
  line "LINK ${ifc:0:16}" "${GB}${addr}${N}"
done < <(ip -br -4 addr 2>/dev/null | awk '$1!="lo" && $3 {print $1, $3}' | head -n 3)
line "CHANNELS OPEN"    "${chan}  ${D}(listening TCP ports)${N}"
if [ -n "$intr" ]; then
  if [ "$intr" -gt 0 ]; then line "BOARDING ATTEMPTS" "${R}${intr} FAILED LOGIN(S) IN 24H${N}"
  else line "BOARDING ATTEMPTS" "${GB}NONE IN 24H${N}"; fi
fi

sec "CREW LOGBOOK"
logbook=$(last -n 4 -a "$user" 2>/dev/null | awk 'NF && $1!="wtmp" && $1!="reboot"' | head -n 3)
if [ -n "$logbook" ]; then
  while IFS= read -r l; do say " ${D}${l:0:$((W-2))}${N}"; done <<< "$logbook"
else
  say " ${D}NO PREVIOUS ENTRIES${N}"
fi
crew=$(who 2>/dev/null | awk '{printf "%s|%s|%s %s\n",$1,$2,$3,$4}')
if [ -n "$crew" ]; then
  while IFS='|' read -r cu ct cw; do line "ABOARD ${cu^^}" "${D}${ct}  since ${cw}${N}"; done <<< "$crew"
fi

printf '\n'
rule '='
if [ "${failed:-0}" -gt 0 ]; then
  say " ${R}*** PRIORITY ALERT *** ${failed} SYSTEM UNIT(S) IN FAILED STATE${N}"
  say " ${R}SPECIAL ORDER 937: INVESTIGATE ANOMALY  (systemctl --failed)${N}"
else
  say " ${GB}ALL SYSTEMS NOMINAL${N}"
fi
[ -f /var/run/reboot-required ] && say " ${A}REBOOT PENDING - RETURN TO CRYOSLEEP TO COMPLETE CYCLE${N}"
rule '='
printf ' %sINTERFACE 2037 READY FOR INQUIRY%s %s_%s\n\n' "$GB" "$N" "$BL" "$N"
unset -f nap rule say typed boot sec line gauge
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
