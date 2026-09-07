# Generate the Hardware Inventory Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `collect-inventory.ps1`, `collect-inventory.sh`, and a local `README.md`.

## Objective and Inputs

Collect local hardware and operating-system metadata into two JSON documents. PowerShell must accept `-OutputDirectory` and default to `inventory`; Bash must accept an output directory argument or `INVENTORY_OUTPUT_DIRECTORY` and use the same default.

## Required Behavior

- PowerShell should use Windows CIM and physical-disk APIs; Bash should use available `dmidecode`, `lscpu`, `free`, `lsblk`, and `lspci` tools with graceful unavailable-value handling.
- Generate `inventory-with-placeholders.json` and `inventory-with-null-fields.json`.
- Include documented fields for serial number, manufacturer, model, hostname, operating system, active state, processor, memory, disks, and graphics.
- The placeholder variant must use clear replacement strings for manually maintained asset type, dates, display, and warranty fields; the null variant must use JSON `null` for those fields.
- Create the output directory when appropriate and report both output paths.
- Never collect credentials, tokens, private keys, or unrelated user data.

## Safety, Parity, and Documentation

Inventory may contain serial numbers, hostnames, hardware identifiers, and other sensitive metadata. Keep collection local, document redaction before sharing, and use caller-provided paths only. PowerShell and Bash must produce equivalent schemas even when platform-specific values are unavailable. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, permissions, schema examples, and sensitivity warnings.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test output creation, unavailable platform commands, and JSON validity. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.