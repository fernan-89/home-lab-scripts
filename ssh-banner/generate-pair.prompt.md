# Generate the SSH Banner Pair From Scratch

Act as a senior cross-platform operations maintainer. Recreate this category from an empty directory by generating exactly these files:

1. `configure-ssh-banner.ps1`
2. `configure-ssh-banner.sh`
3. `README.md`

The PowerShell and Bash scripts must implement the same operational contract. Use native commands for each platform, but keep inputs, side effects, validation, and observable outcomes equivalent.

## Objective

Install a generic SSH pre-login banner and a post-login shell status script on a Linux host. The utility must update the SSH daemon configuration safely, preserve a backup, and reload the active SSH service only after the files are written successfully.

## Inputs

PowerShell parameters:

- `-BannerPath`, default `/etc/ssh/ssh_banner`.
- `-SshConfigPath`, default `/etc/ssh/sshd_config`.
- `-MotdPath`, default `/etc/profile.d/ssh-status.sh`.
- `-BannerTitle`, default `$env:SSH_BANNER_TITLE` or `AUTHORIZED SYSTEM`.

Bash environment variables:

- `BANNER_PATH`, default `/etc/ssh/ssh_banner`.
- `SSH_CONFIG_PATH`, default `/etc/ssh/sshd_config`.
- `MOTD_PATH`, default `/etc/profile.d/ssh-status.sh`.
- `SSH_BANNER_TITLE`, default `AUTHORIZED SYSTEM`.

Do not hardcode personal names, private hostnames, IP addresses, credentials, tokens, or organization-specific identifiers. The banner title is caller-provided configuration.

## Required Behavior

1. Enable fail-fast error handling.
2. Verify that `sudo` is available before making changes.
3. Generate a generic banner containing the configured title and a clear authorized-use warning.
4. Generate an executable Bash login console themed after the MU/TH/UR 6000 computer from the film Alien (USCSS Nostromo, phosphor-green with amber headings, ASCII only, all text in English). It reports hostname, first local address, OS, kernel, uptime, load, memory, swap, mounted disks, and logged-in users when available, shows a priority alert when systemd units have failed, honors `NO_COLOR`, supports an optional `MOTHER_TYPE=1` typewriter effect, runs only in interactive terminals, and never fails the login when an optional command is unavailable.
5. Write temporary files locally, then copy them to the configured destinations with elevated privileges.
6. Back up the SSH configuration to `<SshConfigPath>.bak` or `<SSH_CONFIG_PATH>.bak` before editing it.
7. Remove existing unindented active or commented `Banner` directives and write exactly one `Banner <configured path>` directive before the first `Match` block (or at the end). Build the new configuration in a temporary file and validate it with `sshd -t -f` before replacing the real file; abort without changes if it is invalid.
8. Install the MOTD/status script and set its executable bit.
9. Reload `ssh` when active, otherwise reload `sshd` when active. Do not restart services or hide reload failures.
10. Print a concise success message only after all required operations succeed.

## Safety and Portability

- Quote every caller-controlled path and value.
- Avoid destructive deletion beyond replacing the explicitly configured generated files.
- Preserve the backup and never expose file contents or secrets in logs.
- Use `/bin/bash`-compatible syntax for the generated status script, and write generated files as ASCII with LF endings and no BOM.
- PowerShell must work under Windows PowerShell or PowerShell 7 when targeting a Linux host through `sudo`.
- Do not assume `systemctl` is available without handling the command failure clearly.

## Acceptance Checks

- Parse the PowerShell file with the PowerShell parser.
- Run `bash -n configure-ssh-banner.sh` and validate the embedded status script syntax where Bash is available.
- Confirm both scripts expose the same configuration contract and write the same three target artifacts.
- Confirm no real infrastructure values or secrets occur in either script or README.
- Keep all documentation in standard English and apply the enterprise README sections `Architectural Role`, `Contractual Obligations`, and `Telemetry & Observability`.

Return the three complete files in separate uninterrupted Markdown code blocks. Do not modify files outside this category, especially the root `README.md` and `LICENSE`.