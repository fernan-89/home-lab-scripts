# Network Performance

## Architectural Role

This category measures network behavior without changing network configuration. It provides latency, jitter, packet-loss context, and optional trusted HTTPS transfer measurements for a defined test window.

## Contractual Obligations

- Accept one or more probe hosts, sample count, optional HTTPS test URLs, and output path.
- Default to four ICMP samples and no download test unless URLs are supplied.
- Compute or record latency samples, average latency, jitter, packet loss, transfer bytes, elapsed seconds, and megabits per second where applicable.
- Download response bodies only to a discard target; never persist them.
- Require trusted HTTPS URLs, certificate validation, and a 30-second download timeout.
- Preserve failed or unavailable measurements as explicit results.

### Generated Results

PowerShell writes `network-performance.json` with structured per-host and per-download measurements. Bash writes `network-performance.txt` with labeled raw ping and transfer metrics. Existing output is replaced, and test response bodies are not included.

### Safety and Recovery

Use hosts and URLs approved for testing; repeated ICMP or download tests can affect service quotas. Reports may reveal topology and external endpoints. The scripts do not tune interfaces, alter routes, or retain downloaded payloads.

## Telemetry & Observability

Measurement output is local and operator-selected; no separate telemetry service is used. The report records test inputs and timestamps necessary to interpret results. Redact private addresses before sharing.

## Verification

Test one host, multiple hosts, packet loss, invalid sample counts, no download URLs, a trusted HTTPS download, timeout behavior, and malformed endpoints. Confirm metrics are not reported as successful when tools fail.

Prerequisites: ICMP access and the `ping` utility. Optional download tests use trusted HTTPS URLs supplied by the operator; certificate validation is never disabled.

PowerShell: `./measure-network.ps1 -ProbeHost example.com -Count 4 -DownloadUrl https://example.com/test.bin`

Bash: `PING_COUNT=4 NETWORK_TEST_URLS=https://example.com/test.bin ./measure-network.sh example.com`