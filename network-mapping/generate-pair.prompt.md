# Generate the Network Mapping Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `map-network.ps1`, `map-network.sh`, and a local `README.md`.

## Objective and Inputs

Record the host name, local IPv4 address, public IPv4 address, and a route trace to a configurable target. PowerShell must support `-TraceTarget`, `-PublicIpServiceUrl`, `-MaximumHops`, and `-ReportPath`; Bash must use `TRACE_TARGET`, `PUBLIC_IP_SERVICE_URL`, `MAXIMUM_HOPS`, and `NETWORK_REPORT_PATH`. Defaults are `example.com`, `https://api.ipify.org`, `20`, and a local report path.

## Required Behavior

- Validate the public service as HTTPS and apply a five-second request timeout.
- Resolve the local host/address with native commands and return `Unavailable` when optional values cannot be collected.
- Query the configured public-address service without sending credentials or unrelated data.
- Run `tracert.exe` on Windows or `traceroute` on Unix-like systems with the configured hop limit.
- Write a plain-text report containing UTC timestamp, local/public addresses, target, and trace output; create the PowerShell parent directory when needed.
- Report the final path and preserve diagnostic evidence even when one observation fails.

## Safety and Parity

Treat private/public addresses, hostnames, routes, and external responses as sensitive. Never embed real network values, credentials, private URLs, or personal paths. Keep certificate validation enabled and do not follow arbitrary redirects without documenting the policy. PowerShell and Bash must have equivalent inputs, fallback behavior, report sections, and timeouts. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, endpoint policy, and privacy warnings.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test an unavailable public service, missing trace command, invalid hop count, and a report path with spaces. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.