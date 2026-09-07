# Terraform Generation

Prerequisites: PowerShell or Bash. Terraform is required to validate the generated files.

PowerShell: `./generate-infrastructure.ps1 -OutputDirectory ./terraform`

Bash: `./generate-infrastructure.sh ./terraform`

Configuration uses `CLOUD_REGION`, `MONGODB_PROJECT_ID`, and `TERRAFORM_OUTPUT_DIRECTORY`.