param([string]$ProbeHost = $(if ($env:NETWORK_PROBE_HOST) { $env:NETWORK_PROBE_HOST } else { "example.com" }), [string]$OutputFile = "network-report.json")
$ErrorActionPreference = "Stop"
$result = [ordered]@{ Computer = $env:COMPUTERNAME; ProbeHost = $ProbeHost; Timestamp = (Get-Date).ToUniversalTime().ToString("o"); Addresses = @(); Ping = $null; Trace = @() }
try { $result.Addresses = @(Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop | Where-Object { $_.IPAddress -notlike "127.*" } | Select-Object IPAddress,InterfaceAlias) } catch { $result.Addresses = @() }
$result.Ping = Test-Connection -ComputerName $ProbeHost -Count 2 -ErrorAction SilentlyContinue | Select-Object Address,ResponseTime
if (Get-Command tracert.exe -ErrorAction SilentlyContinue) { $result.Trace = @(tracert.exe -d -h 8 $ProbeHost) }
$result | ConvertTo-Json -Depth 5 | Set-Content $OutputFile