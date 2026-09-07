param([string]$OutputDirectory = $(if ($env:TERRAFORM_OUTPUT_DIRECTORY) { $env:TERRAFORM_OUTPUT_DIRECTORY } else { (Join-Path $PWD "terraform") }), [string]$Region = $(if ($env:CLOUD_REGION) { $env:CLOUD_REGION } else { "REPLACE_WITH_REGION" }), [string]$MongoDbProjectId = $(if ($env:MONGODB_PROJECT_ID) { $env:MONGODB_PROJECT_ID } else { "REPLACE_WITH_PROJECT_ID" }))
$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
@"
terraform {
  required_version = ">= 1.5.0"
}
variable "cloud_region" { type = string; default = "REGION_VALUE" }
variable "mongodb_project_id" { type = string; default = "PROJECT_VALUE" }
variable "mongodb_public_key" { type = string; sensitive = true }
variable "mongodb_private_key" { type = string; sensitive = true }
"@.Replace("REGION_VALUE", $Region).Replace("PROJECT_VALUE", $MongoDbProjectId) | Set-Content (Join-Path $OutputDirectory "variables.tf")
"# Infrastructure configuration`n`nProvide credentials through variables or a secret manager. Do not commit secrets." | Set-Content (Join-Path $OutputDirectory "README.md")