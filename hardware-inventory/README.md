# Hardware Inventory

## Architectural Role

This category collects local hardware and operating-system facts into portable JSON suitable for inventory review and later enrichment. It does not register assets in a remote CMDB or transmit collected data.

## Contractual Obligations

- Accept an output directory, defaulting to `inventory` or `INVENTORY_OUTPUT_DIRECTORY`.
- Use Windows CIM/physical-disk APIs in PowerShell and `dmidecode`, `lscpu`, `free`, `lsblk`, and `lspci` in Bash where available.
- Handle unavailable commands or fields without fabricating sensitive values.
- Generate both `inventory-with-placeholders.json` and `inventory-with-null-fields.json`.
- Preserve the documented schema for serial number, manufacturer, model, hostname, OS, active state, processor, memory, disk, graphics, asset type, dates, display, and warranty.

### Generated Results

The placeholder file contains explicit replacement strings for fields that require human enrichment. The null-fields file uses JSON `null` for those fields. Both files contain local machine data and may include serial numbers, hostnames, and hardware identifiers.

### Safety and Recovery

Protect the output directory and redact sensitive fields before sharing. Running again overwrites the two named JSON files, so archive prior results when historical comparison matters. Bash may require elevated access for `dmidecode`; missing privileges should be reported rather than bypassed unsafely.

## Telemetry & Observability

Only local collection status and output paths are reported. No network calls or external telemetry occur. Treat generated JSON as sensitive inventory evidence.

## Verification

Validate both outputs as JSON, confirm both files exist, inspect the stable schema, test missing platform commands, and verify that credentials or unrelated user data are not collected.

Collects local hardware and operating-system metadata, then writes two JSON files: one with explicit replacement placeholders and one with `null` for manually maintained fields. Inventory may include serial numbers and hostnames and should be handled as sensitive output.

Prerequisites: Windows CIM cmdlets for PowerShell. Bash requires `jq`, `dmidecode`, `lscpu`, `free`, `lsblk`, and `lspci`; root privileges may be required for complete hardware data.

PowerShell: `./collect-inventory.ps1 -OutputDirectory ./inventory`

Bash: `./collect-inventory.sh ./inventory`