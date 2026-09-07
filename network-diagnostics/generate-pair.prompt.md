# Generate the Network Diagnostics Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `inspect-network.ps1`, `inspect-network.sh`, and a local `README.md`.

## Objective and Inputs

Collect local IPv4 addresses, two reachability probes, and an eight-hop trace to a configurable host. PowerShell must accept `-ProbeHost` and `-OutputFile`, defaulting to `example.com` and `network-report.json`. Bash must use `NETWORK_PROBE_HOST` and `NETWORK_OUTPUT_FILE`, defaulting to `example.com` and `network-report.txt`.

## Required Behavior

- Validate the output parent and preserve the configurable probe host; do not hardcode a private target.
- Collect local IPv4 addresses using platform-native commands.
- Execute two ping attempts and capture success, failure, latency, or unavailable output without aborting the complete report.
- Execute an eight-hop trace using `tracert`/`traceroute` when available and capture its lines.
- PowerShell must emit structured JSON containing computer, probe host, UTC timestamp, addresses, ping results, and trace lines. Bash must emit a clearly labeled text report with equivalent evidence.
- Report the output path and distinguish unavailable tools from failed network probes.

## Safety, Parity, and Documentation

Treat addresses, hostnames, routes, and external responses as sensitive. Use parameters/environment variables and never embed credentials, private infrastructure identifiers, or personal paths. Do not upload reports. The two implementations must preserve equivalent diagnostic intent even when their output formats are native JSON versus text. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, examples, timeout behavior, and sensitivity warnings.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test a reachable host, an unreachable host, missing utilities, and an output path with spaces. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.