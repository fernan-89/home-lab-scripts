# Network Mapping

🇺🇸 English · 🇧🇷 [Português](README.pt-BR.md)

## Architectural Role

This utility records a local/public addressing snapshot and a configurable route trace. It is an observational diagnostic and does not configure interfaces, DNS, routing, or firewall rules.

## Contractual Obligations

- Accept trace target, public-IP service URL, maximum hops, and report path.
- Default to `example.com`, `https://api.ipify.org`, 20 hops, and a local report path.
- Record UTC time, hostname, local IPv4, public IPv4, target, and trace output.
- Use a five-second timeout for public-IP lookup and use `Unavailable` when it cannot be resolved.
- Use `tracert.exe` on Windows or `traceroute` on Unix-like systems.
- Preserve evidence when one observation fails and report the final file path.

### Generated Results

The output is a plain-text report containing labeled local/public address, endpoint, timestamp, and route sections. PowerShell creates the parent directory when necessary; Bash expects the parent to exist. Existing output is overwritten.

### Safety and Recovery

Private/public addresses, hostnames, and routes are sensitive. Use approved endpoints, restrict report access, and redact before sharing. The utility makes no network configuration changes and does not send credentials to the public-IP service.

## Configuration

| Setting | PowerShell | Bash | Default |
| --- | --- | --- | --- |
| Trace target | `-TraceTarget` or `TRACE_TARGET` | `TRACE_TARGET` or `$1` | `example.com` |
| Public-IP service | `-PublicIpServiceUrl` or `PUBLIC_IP_SERVICE_URL` | `PUBLIC_IP_SERVICE_URL` | `https://api.ipify.org` |
| Report file | `-ReportPath` or `NETWORK_REPORT_PATH` | `NETWORK_REPORT_PATH` or `$2` | `%TEMP%\network-mapping.txt` (PowerShell), `./network-mapping.txt` (Bash) |
| Maximum hops | `-MaximumHops` | `MAXIMUM_HOPS` | `20` |

PowerShell parameters win; where a parameter's default reads an environment variable, that variable applies when the parameter is omitted. `$1`, `$2` and `$3` are Bash positional arguments; when both the environment variable and the argument are set, the variable wins.

## Usage

Prerequisites: PowerShell networking cmdlets and `tracert.exe` on Windows, or `hostname`, `traceroute`, and optionally `curl` on Linux/macOS.

PowerShell: `./map-network.ps1 -TraceTarget example.com -ReportPath ./network-mapping.txt`

Bash: `./map-network.sh example.com ./network-mapping.txt`

Environment overrides: `TRACE_TARGET`, `PUBLIC_IP_SERVICE_URL`, `NETWORK_REPORT_PATH`, and `MAXIMUM_HOPS`.

## Telemetry & Observability

Only the local report and status messages are produced. There is no external telemetry beyond the operator-selected public-IP request. The report records enough evidence to reproduce the diagnostic context.

## Verification

Test successful and unavailable public-IP lookup, missing trace command, invalid hop limit, a custom report path, and a target that cannot be reached. Confirm the fallback is explicit rather than mistaken for a real address.
