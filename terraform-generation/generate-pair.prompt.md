# Generate the Terraform Scaffold Pair From Scratch

Act as a senior infrastructure maintainer. Generate exactly `generate-infrastructure.ps1`, `generate-infrastructure.sh`, and a local `README.md`.

## Objective and Inputs

Generate a minimal Terraform starter directory without provisioning infrastructure. PowerShell must accept `-OutputDirectory`, `-CloudRegion`, and `-MongodbProjectId`; Bash must use `TERRAFORM_OUTPUT_DIRECTORY`, `CLOUD_REGION`, and `MONGODB_PROJECT_ID`. Defaults are `./terraform`, `REPLACE_WITH_REGION`, and `REPLACE_WITH_PROJECT_ID`.

## Required Behavior

- Create the configured output directory and generate only `variables.tf` and `README.md`.
- Declare Terraform `>= 1.5.0` variables for `cloud_region`, `mongodb_project_id`, `mongodb_public_key`, and `mongodb_private_key`.
- Mark credential variables sensitive and instruct operators to use a secret manager or protected variables; never write actual credentials.
- Do not generate providers, resources, modules, backends, state, or network changes.
- Require an explicit overwrite option before replacing existing files and report every generated path.
- Validate the generated text structurally and fail clearly on invalid output paths.

## Safety, Parity, and Documentation

Use only caller-provided configuration and placeholders. Never embed private domains, accounts, access keys, tokens, or personal paths. PowerShell and Bash must generate byte-for-byte equivalent intent and the same variable contract. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, generated-file descriptions, secret-management guidance, and a clear statement that no infrastructure is provisioned.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test a new output directory, an existing directory without overwrite authorization, placeholder defaults, custom values, and generated Terraform syntax when Terraform is available. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.