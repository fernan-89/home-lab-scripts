# Generate the Asset Tag Migration Pair From Scratch

Act as a senior cross-platform automation maintainer. Starting with an empty category directory, generate exactly `update-asset-tags.ps1`, `update-asset-tags.sh`, and a local `README.md`.

## Objective and Inputs

Update every top-level JSON file in a caller-provided directory with sequential `assetTag` values. PowerShell must require `-JsonDirectory` and support `-AssetTagPrefix` and `-StartNumber`; Bash must accept a directory argument or `JSON_DIRECTORY`, with `ASSET_TAG_PREFIX` and `START_NUMBER` environment overrides. Defaults are `ASSET-` and `1`.

## Required Behavior

- Sort `*.json` files by filename and do not recurse.
- Support one JSON object or an array of JSON objects per file.
- Assign tags in file and array order using three-digit numbering such as `ASSET-001`.
- Preserve object-versus-array JSON shape and overwrite files only after successful parsing and transformation.
- Report the discovered file count and each updated filename with the next sequence number.
- Fail clearly when the directory is missing, JSON is invalid, or Bash `jq` is unavailable.

## Safety and Parity

Use parameters/environment variables for every path and value. Never embed hosts, credentials, private identifiers, or personal data. Recommend a backup before mutation. Use PowerShell JSON cmdlets and Bash `jq`; do not implement JSON parsing with regex. Temporary files must be cleaned up and partial writes must be avoided where practical. Both scripts must produce equivalent tags for identical inputs.

## Acceptance and Output

Parser-validate the PowerShell file and run `bash -n` where Bash is available. Test an object, an array, an empty directory, and invalid JSON. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, examples, and overwrite warnings. Return the three complete files in separate Markdown code blocks and do not modify the root `README.md` or `LICENSE`.