# Network Mapping

Collects the local hostname/address, queries a configurable public-IP service, and runs a configurable traceroute. The report may contain private and public network addresses.

Prerequisites: PowerShell networking cmdlets and `tracert.exe` on Windows, or `hostname`, `traceroute`, and optionally `curl` on Linux/macOS.

PowerShell: `./map-network.ps1 -TraceTarget example.com -ReportPath ./network-mapping.txt`

Bash: `./map-network.sh example.com ./network-mapping.txt`

Environment overrides: `TRACE_TARGET`, `PUBLIC_IP_SERVICE_URL`, `NETWORK_REPORT_PATH`, and `MAXIMUM_HOPS`.