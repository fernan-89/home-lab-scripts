# SSH Banner

🇺🇸 English · 🇧🇷 [Português](README.pt-BR.md)

## Architectural Role

This category configures a generic SSH pre-login banner and a post-login system-status script on a Linux host. It changes host configuration and may reload the active SSH service; it does not create users, change authentication policy, or restart the host.

## Contractual Obligations

- Accept banner path, SSH daemon configuration path, MOTD/status path, and banner title.
- Default to `/etc/ssh/ssh_banner`, `/etc/ssh/sshd_config`, `/etc/profile.d/ssh-status.sh`, and `AUTHORIZED SYSTEM`.
- Require `sudo`, write the banner and status script, back up the SSH configuration to `.bak`, and maintain one active `Banner` directive.
- Make the status script executable and show an animated, themed (Alien / Nostromo, MU/TH/UR 6000) login console: a boot sequence, crew identification (rank and clearance from the user's privileges), and host, OS, kernel, mission day, pending updates, load, temperature, memory, swap, mounted disks, running containers, network links, listening ports, failed SSH logins in the last 24 hours, the user's recent logins and logged-in users when available, plus a priority alert when systemd units have failed.
- Place the `Banner` directive before the first `Match` block, validate the new configuration with `sshd -t` before replacing the real file, and abort without changes if it is invalid.
- Reload `ssh` when active or `sshd` when active after successful writes; do not silently restart services.

### Generated Results

The scripts create or replace the banner file and executable status script, and update the configured SSH daemon file. They also create `<sshd_config>.bak`. No user accounts, keys, passwords, firewall rules, or authentication methods are changed.

### Safety and Recovery

Review paths and title before running with elevated privileges. The scripts validate the new SSH configuration with `sshd -t` before replacing it and keep the backup before reloading. If access behavior changes unexpectedly, restore the backup and reload the daemon from an existing console. Do not put hostnames, addresses, credentials, or personal names in the banner.

## Configuration

| Setting | PowerShell | Bash | Default |
| --- | --- | --- | --- |
| Pre-login banner file | `-BannerPath` | `BANNER_PATH` | `/etc/ssh/ssh_banner` |
| SSH daemon configuration | `-SshConfigPath` | `SSH_CONFIG_PATH` | `/etc/ssh/sshd_config` |
| Post-login status script | `-MotdPath` | `MOTD_PATH` | `/etc/profile.d/ssh-status.sh` |
| Banner title | `-BannerTitle` or `SSH_BANNER_TITLE` | `SSH_BANNER_TITLE` | `AUTHORIZED SYSTEM` |

PowerShell parameters win; where a parameter's default reads an environment variable, that variable applies when the parameter is omitted. `$1`, `$2` and `$3` are Bash positional arguments; when both the environment variable and the argument are set, the variable wins.

## Usage

Prerequisites: an SSH server, `sudo`, `systemctl`, and permission to modify `/etc/ssh` and `/etc/profile.d`.

PowerShell: `./configure-ssh-banner.ps1`

Bash: `SSH_BANNER_TITLE='AUTHORIZED SYSTEM' ./configure-ssh-banner.sh`

Override paths with `BANNER_PATH`, `SSH_CONFIG_PATH`, and `MOTD_PATH` in Bash, or the corresponding PowerShell parameters. The login console is plain text when `NO_COLOR` is set, and `MOTHER_FAST=1` in the user's shell skips the boot animation.

## Telemetry & Observability

Only local installation and reload status is reported. The generated login status displays host telemetry to authorized users; it is not sent to an external service. Host and address values may be sensitive.

## Verification

Test with temporary paths, verify the backup, inspect the single `Banner` directive, check status-script permissions, validate SSH configuration, and confirm reload behavior for both `ssh` and `sshd` service names.
