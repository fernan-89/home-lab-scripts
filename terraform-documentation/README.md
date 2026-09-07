# Terraform Documentation

## Architectural Role

This category creates a reviewable Markdown snapshot of a Terraform source tree. It is a documentation and inspection utility, not a Terraform execution wrapper: it never runs `terraform plan`, `terraform apply`, `terraform init`, or any provider operation.

The PowerShell and Bash scripts recursively discover Terraform files, sort them by path, and assemble their source into one Markdown document using HCL code fences. The generated document is useful for offline review, handoff, change analysis, and repository indexing.

## Contractual Obligations

### Inputs

Both implementations require:

- A Terraform root directory with read access.
- An output Markdown path with write access.

PowerShell parameters:

```powershell
./document-terraform.ps1 `
		-RootPath C:\path\to\terraform `
		-OutputPath C:\path\to\terraform.md
```

Bash positional arguments:

```bash
./document-terraform.sh /path/to/terraform /path/to/terraform.md
```

### Discovery and Ordering

- All files ending in `.tf` are discovered recursively.
- Files are sorted by full path before rendering.
- The scripts fail when the root does not exist or no Terraform files are found.
- Existing output is overwritten at the exact path supplied by the operator.
- Parent directories for the output are not implicitly created; create them before execution.

### Generated Results

For each Terraform file, the output contains a section in this shape:

````markdown
## File: /path/to/example.tf

```hcl
resource "example" "sample" {
	# Source is copied exactly for review.
}
```

---
````

The final document contains:

- One heading per discovered `.tf` file.
- The source content inside an `hcl` fenced block.
- A horizontal separator between files.
- No generated Terraform state, provider output, plan, or resource evaluation.

### Failure and Safety Behavior

- Fail fast when the root directory is invalid.
- Fail when the source tree has no `.tf` files.
- Preserve the source files; only the configured output file is written.
- Use a temporary or version-controlled output location when reviewing changes.
- Review the generated document before publishing because Terraform source may contain credentials, private endpoints, account IDs, tokens, or sensitive variables.
- Do not add credentials to command examples or committed files.

## Telemetry & Observability

The scripts emit one local status message containing the number of documented Terraform files and the output path. They collect no external telemetry, make no network calls, and do not upload source content. The output path and source filenames can still reveal infrastructure structure, so treat the generated document as sensitive.

## Prerequisites

- PowerShell for the `.ps1` implementation or Bash for the `.sh` implementation.
- Read permission for the Terraform tree.
- Write permission for the parent directory of the output file.
- Terraform itself is not required to generate the document.

## Verification

PowerShell syntax validation:

```powershell
$errors = $null
[System.Management.Automation.Language.Parser]::ParseFile(
		(Resolve-Path .\document-terraform.ps1),
		[ref]$null,
		[ref]$errors
) | Out-Null
if ($errors.Count -gt 0) { $errors | ForEach-Object Message; exit 1 }
```

Bash syntax validation:

```bash
bash -n ./document-terraform.sh
```

After execution, confirm that every expected `.tf` file appears once, that the HCL fences are balanced, and that no sensitive value is being shared unintentionally.