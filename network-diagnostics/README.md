# Network Diagnostics

## Architectural Role

This category captures a point-in-time local connectivity diagnosis: interface addresses, reachability probes, and a short route trace. It creates evidence for troubleshooting and does not change network configuration.

## Contractual Obligations

- Accept a configurable probe host, defaulting to `example.com`, and a report path.
- Collect local IPv4 addresses.
- Execute two ping attempts and an eight-hop trace using platform-native tools.
- Continue when a probe or optional utility fails and represent unavailable evidence clearly.
- Write structured JSON in PowerShell and a human-readable text report in Bash with equivalent evidence.

### Generated Results

PowerShell writes `network-report.json` with computer name, probe host, UTC timestamp, local addresses, ping objects, and trace lines. Bash writes `network-report.txt` with labeled address, ping, and trace sections. Existing output at the selected path is replaced.

### Safety and Recovery

Probe hosts, addresses, routes, and external responses can be sensitive. Use an approved target, protect the report, and redact it before sharing. The scripts do not alter interfaces, routes, firewall rules, or DNS settings.

## Telemetry & Observability

All evidence remains in the selected local report. No separate telemetry or upload occurs. Status messages identify the output path and failures without hiding command errors.

## Verification

Test a reachable and unreachable host, missing `ping`/trace utilities, an output path with spaces, and repeated execution. Confirm failures remain distinguishable from empty results.

Prerequisites: network utilities and permission to write the report. The probe host is configurable and no private address is embedded.

PowerShell: `./inspect-network.ps1 -ProbeHost example.com -OutputFile network-report.json`

Bash: `NETWORK_PROBE_HOST=example.com ./inspect-network.sh`