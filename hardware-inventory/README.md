# Hardware Inventory

Collects local hardware and operating-system metadata, then writes two JSON files: one with explicit replacement placeholders and one with `null` for manually maintained fields. Inventory may include serial numbers and hostnames and should be handled as sensitive output.

Prerequisites: Windows CIM cmdlets for PowerShell. Bash requires `jq`, `dmidecode`, `lscpu`, `free`, `lsblk`, and `lspci`; root privileges may be required for complete hardware data.

PowerShell: `./collect-inventory.ps1 -OutputDirectory ./inventory`

Bash: `./collect-inventory.sh ./inventory`