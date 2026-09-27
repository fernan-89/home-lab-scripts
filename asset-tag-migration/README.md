# Asset Tag Migration

🇺🇸 English · 🇧🇷 [Português](README.pt-BR.md)

## Architectural Role

This utility performs a local, deterministic data migration for JSON asset records. It does not discover hardware, call an API, or publish data. Its only mutation is assigning sequential `assetTag` values to top-level JSON files selected by the operator.

## Contractual Obligations

- Read only top-level `*.json` files and process them in alphabetical filename order.
- Accept either one JSON object or an array of JSON objects in each file.
- Assign one tag to an object and one tag to every array element.
- Use a configurable prefix, defaulting to `ASSET-`, and three-digit numbering starting at `001`.
- Preserve object-versus-array shape and overwrite each source file in place only after successful parsing.
- Fail on a missing directory, invalid JSON, or missing Bash `jq` dependency.

### Generated Results

No new report file is created. Each input file is rewritten with its `assetTag` fields updated. For example, an object becomes `ASSET-001`; the next object or array element receives `ASSET-002`. The scripts print the discovered file count, each updated filename, and the next sequence number.

### Safety and Recovery

Back up or commit the input directory before execution. Review the generated diff and confirm that the numbering order matches the intended business order; filenames and array order control assignment. The migration does not recurse and does not transmit file contents.

## Configuration

| Setting | PowerShell | Bash | Default |
| --- | --- | --- | --- |
| JSON directory | `-JsonDirectory` | `JSON_DIRECTORY` or `$1` | required |
| Tag prefix | `-AssetTagPrefix` or `ASSET_TAG_PREFIX` | `ASSET_TAG_PREFIX` | `ASSET-` |
| First sequence number | `-StartNumber` | `START_NUMBER` | `1` |

PowerShell parameters win; where a parameter's default reads an environment variable, that variable applies when the parameter is omitted. `$1`, `$2` and `$3` are Bash positional arguments; when both the environment variable and the argument are set, the variable wins.

## Usage

Prerequisites: PowerShell with JSON cmdlets, or Bash with `jq`. Back up the input directory before running.

PowerShell: `./update-asset-tags.ps1 -JsonDirectory C:\path\to\json -AssetTagPrefix ASSET- -StartNumber 1`

Bash: `ASSET_TAG_PREFIX=ASSET- START_NUMBER=1 ./update-asset-tags.sh /path/to/json`

## Telemetry & Observability

Only local progress messages are emitted. No external telemetry or network access occurs. JSON files may contain asset identifiers and must be treated as sensitive after migration.

## Verification

Test one object, an array, multiple files, an empty directory, invalid JSON, custom prefix, and a non-default starting number. Validate resulting files with a JSON parser before importing them elsewhere.
