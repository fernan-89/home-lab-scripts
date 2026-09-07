#!/usr/bin/env bash
set -euo pipefail
OUTPUT_DIRECTORY="${TERRAFORM_OUTPUT_DIRECTORY:-${1:-$PWD/terraform}}"
CLOUD_REGION="${CLOUD_REGION:-REPLACE_WITH_REGION}"
MONGODB_PROJECT_ID="${MONGODB_PROJECT_ID:-REPLACE_WITH_PROJECT_ID}"
mkdir -p "$OUTPUT_DIRECTORY"
cat > "$OUTPUT_DIRECTORY/variables.tf" <<EOF
terraform {
  required_version = ">= 1.5.0"
}
variable "cloud_region" { type = string; default = "$CLOUD_REGION" }
variable "mongodb_project_id" { type = string; default = "$MONGODB_PROJECT_ID" }
variable "mongodb_public_key" { type = string; sensitive = true }
variable "mongodb_private_key" { type = string; sensitive = true }
EOF
printf '# Infrastructure configuration\n\nProvide credentials through variables or a secret manager. Do not commit secrets.\n' > "$OUTPUT_DIRECTORY/README.md"