# Network Performance

🇺🇸 English · 🇧🇷 [Português](README.pt-BR.md)

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

## Configuration

| Setting | PowerShell | Bash | Default |
| --- | --- | --- | --- |
| Probe hosts (comma-separated) | `-ProbeHost` or `NETWORK_PROBE_HOSTS` | `NETWORK_PROBE_HOSTS` or `$1` | `example.com` |
| Pings per host | `-Count` | `PING_COUNT` | `4` |
| Download test URLs (comma-separated, HTTPS) | `-DownloadUrl` or `NETWORK_TEST_URLS` | `NETWORK_TEST_URLS` | none (no download test) |
| Report file | `-OutputFile` | `NETWORK_OUTPUT_FILE` | `network-performance.json` (PowerShell), `network-performance.txt` (Bash) |

PowerShell parameters win; where a parameter's default reads an environment variable, that variable applies when the parameter is omitted. `$1`, `$2` and `$3` are Bash positional arguments; when both the environment variable and the argument are set, the variable wins.

## Usage

Prerequisites: ICMP access and the `ping` utility. Optional download tests use trusted HTTPS URLs supplied by the operator; certificate validation is never disabled.

PowerShell: `./measure-network.ps1 -ProbeHost example.com -Count 4 -DownloadUrl https://example.com/test.bin`

Bash: `PING_COUNT=4 NETWORK_TEST_URLS=https://example.com/test.bin ./measure-network.sh example.com`

## Telemetry & Observability

Measurement output is local and operator-selected; no separate telemetry service is used. The report records test inputs and timestamps necessary to interpret results. Redact private addresses before sharing.

## Verification

Test one host, multiple hosts, packet loss, invalid sample counts, no download URLs, a trusted HTTPS download, timeout behavior, and malformed endpoints. Confirm metrics are not reported as successful when tools fail.
