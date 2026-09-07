# SSH Banner

Installs a generic pre-login SSH banner and a post-login system-status message. The script creates a backup of the SSH configuration before editing it.

Prerequisites: an SSH server, `sudo`, `systemctl`, and permission to modify `/etc/ssh` and `/etc/profile.d`.

PowerShell: `./configure-ssh-banner.ps1`

Bash: `SSH_BANNER_TITLE='AUTHORIZED SYSTEM' ./configure-ssh-banner.sh`

Override paths with `BANNER_PATH`, `SSH_CONFIG_PATH`, and `MOTD_PATH` in Bash, or the corresponding PowerShell parameters.
