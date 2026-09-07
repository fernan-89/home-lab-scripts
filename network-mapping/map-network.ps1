param(
    [string]$TraceTarget = $(if ($env:TRACE_TARGET) { $env:TRACE_TARGET } else { "example.com" }),
    [string]$PublicIpServiceUrl = $(if ($env:PUBLIC_IP_SERVICE_URL) { $env:PUBLIC_IP_SERVICE_URL } else { "https://api.ipify.org" }),
    [string]$ReportPath = $(if ($env:NETWORK_REPORT_PATH) { $env:NETWORK_REPORT_PATH } else { (Join-Path $env:TEMP "network-mapping.txt") }),
    [int]$MaximumHops = 20
)

$ErrorActionPreference = "Stop"
$localHost = [System.Net.Dns]::GetHostName()
$localIp = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" } | Select-Object -ExpandProperty IPAddress -First 1
$publicIp = "Unavailable"
try { $publicIp = (Invoke-WebRequest -Uri $PublicIpServiceUrl -TimeoutSec 5 -UseBasicParsing).Content.Trim() } catch { }
$trace = if (Get-Command tracert.exe -ErrorAction SilentlyContinue) { @(tracert.exe -d -h $MaximumHops $TraceTarget) } else { @("tracert.exe is unavailable") }
$report = @(
    "Network mapping report"
    "Generated: $((Get-Date).ToUniversalTime().ToString('o'))"
    "Local host: $localHost"
    "Local IPv4: $localIp"
    "Public IPv4: $publicIp"
    "Trace target: $TraceTarget"
    ""
    "Trace output:"
    $trace
)
$parent = Split-Path -Parent $ReportPath
if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
$report | Set-Content -LiteralPath $ReportPath -Encoding utf8
$report