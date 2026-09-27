# Terraform Generation

🇺🇸 English · 🇧🇷 [Português](README.pt-BR.md)

## Architectural Role

This category generates a minimal Terraform variable scaffold for a new infrastructure workspace. It creates input declarations and guidance only; it does not initialize Terraform, create state, contact a provider, or provision resources.

## Contractual Obligations

- Accept an output directory, cloud region, and MongoDB project ID.
- Default to `./terraform`, `REPLACE_WITH_REGION`, and `REPLACE_WITH_PROJECT_ID` or their environment overrides.
- Create exactly `variables.tf` and a local `README.md` in the selected directory.
- Declare Terraform `>= 1.5.0` variables for `cloud_region`, `mongodb_project_id`, `mongodb_public_key`, and sensitive `mongodb_private_key`.
- Use placeholders and never write real credentials, accounts, endpoints, or private identifiers.
- Require explicit overwrite authorization before replacing existing generated files.

### Generated Results

`variables.tf` contains variable declarations only; no provider, resource, module, backend, state, or network configuration is created. The generated README explains inputs and secret handling. The output directory may be created, and the two named files may be overwritten only with authorization.

### Safety and Recovery

Review the output directory before generation. Supply credentials through a secret manager or protected variables at runtime, never by editing committed scaffold files. If generated files are wrong, remove only the scaffold directory or restore it from version control; no cloud rollback is required because no infrastructure was provisioned.

## Configuration

| Setting | PowerShell | Bash | Default |
| --- | --- | --- | --- |
| Output directory | `-OutputDirectory` or `TERRAFORM_OUTPUT_DIRECTORY` | `TERRAFORM_OUTPUT_DIRECTORY` or `$1` | `./terraform` |
| Cloud region | `-Region` or `CLOUD_REGION` | `CLOUD_REGION` | `REPLACE_WITH_REGION` |
| MongoDB Atlas project ID | `-MongoDbProjectId` or `MONGODB_PROJECT_ID` | `MONGODB_PROJECT_ID` | `REPLACE_WITH_PROJECT_ID` |

PowerShell parameters win; where a parameter's default reads an environment variable, that variable applies when the parameter is omitted. `$1`, `$2` and `$3` are Bash positional arguments; when both the environment variable and the argument are set, the variable wins.

## Usage

Prerequisites: PowerShell or Bash. Terraform is required to validate the generated files.

PowerShell: `./generate-infrastructure.ps1 -OutputDirectory ./terraform`

Bash: `./generate-infrastructure.sh ./terraform`

## Telemetry & Observability

Only generated paths and local status are reported. No provider calls or external telemetry occur. Treat the generated README and variables as configuration artifacts until reviewed.

## Verification

Inspect both files, validate Terraform syntax when Terraform is available, test placeholder and custom values, test overwrite refusal, and confirm no provider/resource/backend blocks or real secrets were generated.
