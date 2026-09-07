# Generate the Network Performance Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `measure-network.ps1`, `measure-network.sh`, and a local `README.md`.

## Objective and Inputs

Measure ICMP latency for one or more hosts and optionally measure trusted HTTPS download performance. PowerShell must accept configurable probe hosts, sample count, test URLs, and output path, using `NETWORK_PROBE_HOSTS`, `NETWORK_TEST_URLS`, and `network-performance.json` defaults. Bash must use equivalent `NETWORK_PROBE_HOSTS`, `PING_COUNT`, `NETWORK_TEST_URLS`, and `NETWORK_OUTPUT_FILE` values, defaulting to one host, four samples, and `network-performance.txt`.

## Required Behavior

- Validate hosts, sample count, output path, and optional URLs before running tests.
- Collect latency samples, average latency, jitter, and packet-loss information for each host; represent unavailable or failed samples without aborting unrelated hosts.
- When URLs are supplied, download to a discard target only, record bytes, elapsed seconds, and megabits per second, and never persist response bodies.
- Require trusted HTTPS URLs, preserve certificate validation, and enforce a 30-second download timeout.
- Write the documented JSON report in PowerShell and a clearly labeled equivalent text report in Bash.
- Print the output path and summary without exposing response data or credentials.

## Safety and Parity

Use caller-supplied hosts, URLs, counts, and paths. Never embed private infrastructure, credentials, tokens, or personal identifiers. Treat network reports as sensitive. The two implementations must preserve equivalent measurement intent, timeout policy, optional-download semantics, and failure handling even where native tools differ. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, metric definitions, trusted-endpoint policy, and sensitivity warnings.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test one host, multiple hosts, packet loss, invalid count, no download URLs, and a trusted HTTPS download. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.