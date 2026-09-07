# Terraform Documentation

Aggregates recursive `.tf` files into a Markdown document with HCL code fences. The output may contain infrastructure secrets if the input files contain them; review the result before publishing.

Prerequisites: PowerShell or Bash with read access to the Terraform tree and write access to the output path.

PowerShell: `./document-terraform.ps1 -RootPath C:\path\to\terraform -OutputPath C:\path\to\terraform.md`

Bash: `./document-terraform.sh /path/to/terraform /path/to/terraform.md`