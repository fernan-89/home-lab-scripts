# Home Lab Scripts

**Version:** v1.3.0

**Status:** Public-ready automation toolkit

Cross-platform PowerShell and Bash utilities for secure home lab automation, network diagnostics, hardware inventory, Git maintenance, Docker deployment, Terraform workflows, and infrastructure operations.

## Overview

Home Lab Scripts is a cross-platform collection of operational utilities for local infrastructure, network diagnostics, hardware inventory, Git repository maintenance, Docker deployment, Terraform documentation, SSH configuration, and controlled file or data migrations.

Every maintained task is organized by capability and provides functionally equivalent PowerShell and Bash implementations. Configuration is supplied through parameters or environment variables instead of personal paths, private hostnames, credentials, tokens, or private domains.

The repository is intentionally composed of small, inspectable scripts rather than a single runtime application. Each category includes a focused `README.md` with prerequisites and execution examples plus a standalone `generate-pair.prompt.md` that another AI can use to recreate the pair from an empty directory.

## Technology Stack

* **Shells:** Windows PowerShell / PowerShell Core and Bash 4+
* **Repository tooling:** Git and GitHub CLI (`gh`) where explicitly required
* **Containers:** Docker CLI and Docker Engine
* **Infrastructure:** Terraform input generation and Markdown documentation
* **Network tooling:** `ping`, `traceroute`/`tracert`, `curl`, and platform networking cmdlets
* **Hardware tooling:** Windows CIM, `dmidecode`, `lscpu`, `free`, `lsblk`, `lspci`, and `jq`
* **Data formats:** JSON, Markdown, HCL, shell environment variables, and Git configuration
* **Security model:** Externalized secrets, explicit destructive-operation flags, generated backups for SSH configuration, and local-only repository indexing

## Repository Model

```text
home-lab-scripts/
├── <category>/
│   ├── <task>.ps1
│   ├── <task>.sh
│   ├── README.md
│   └── generate-pair.prompt.md
├── prompts/                         # Source prompts and historical design material
├── README.md
└── LICENSE                         # MIT License
```

Each category owns one task pair, a local enterprise README, and a `generate-pair.prompt.md` contract describing how to regenerate the pair. The PowerShell and Bash versions share the same operational intent while respecting platform-native commands and conventions. Application-design prompts that do not represent shell utilities remain archived under `prompts/` instead of receiving artificial wrappers.

## Recreating a Category From Scratch

The local generation prompt is a portable specification for another AI. It must require the AI to:

1. Generate exactly the named PowerShell script, Bash script, and local README.
2. Preserve the documented inputs, defaults, output formats, side effects, and platform-specific command choices.
3. Keep secrets, private paths, hostnames, IP addresses, tokens, and personal identifiers outside source files.
4. Produce equivalent behavior, explicit error handling, safe mutation controls, and standard-English logs.
5. Include `Architectural Role`, `Contractual Obligations`, and `Telemetry & Observability` in the local README only.
6. Parser-validate PowerShell, run `bash -n` where Bash is available, and test the smallest meaningful success and failure cases.
7. Avoid modifying the root `README.md` or `LICENSE` unless the operator explicitly requests repository documentation changes.

The prompt is intentionally stored beside the implementation so the pair, its operational contract, and its regeneration instructions evolve together. The [prompt catalog](prompts/) explains why application-design and historical prompts do not receive artificial shell wrappers.

## Operational Principles

### 1. Configuration and Anonymization

Scripts accept paths, hosts, URLs, image names, ports, prefixes, and credentials through parameters or environment variables. Secret values are never included in the repository.

Examples:

```powershell
$env:MONGODB_URI = "mongodb://user:password@example.invalid/database"
./docker-deployment/deploy-container.ps1 -RepositoryUrl $env:GIT_REPOSITORY_URL
```

```bash
GIT_REPOSITORY_URL="https://example.invalid/project.git" \
MONGODB_URI="mongodb://user:password@example.invalid/database" \
./docker-deployment/deploy-container.sh
```

Use a secret manager, CI secret store, or protected local environment for real credentials. Do not place them in command history, committed files, generated reports, or Terraform output.

### 2. Dry Run Before Mutation

Operations that rename folders or files default to a preview mode. Apply changes only after reviewing the proposed mapping:

```powershell
./driver-organization/standardize-driver-folders.ps1 -BasePath C:\path\to\drivers -Apply
./batch-file-renaming/rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper -Apply
```

```bash
APPLY_CHANGES=true ./driver-organization/standardize-driver-folders.sh /path/to/drivers
APPLY_CHANGES=true ./batch-file-renaming/rename-files.sh /path/to/files mobile wallpaper
```

### 3. Backups and Review

Scripts that overwrite JSON, text, or Terraform documentation should be run against a backup or a disposable working tree. `git-security-hardening` and `git-repository-setup` create commits or publish remote changes; inspect `git status`, the generated files, and the target remote before execution.

### 4. Sensitive Outputs

Hardware inventory can contain serial numbers and hostnames. Network reports can contain private addresses, public addresses, routes, and external service responses. Terraform documentation can reproduce secrets or infrastructure identifiers already present in `.tf` files. Treat generated output as sensitive until reviewed.

## Category Map

| Category | Purpose | PowerShell | Bash |
| --- | --- | --- | --- |
| [asset-tag-migration](asset-tag-migration/) | Add sequential `assetTag` values to JSON objects or arrays. | `update-asset-tags.ps1` | `update-asset-tags.sh` |
| [batch-file-renaming](batch-file-renaming/) | Rename files using a generated prefix, sequence, random ID, and date. | `rename-files.ps1` | `rename-files.sh` |
| [directory-indexing](directory-indexing/) | Generate a Markdown index of directories. | `generate-directory-index.ps1` | `generate-directory-index.sh` |
| [docker-deployment](docker-deployment/) | Clone, build, and run a Dockerized application. | `deploy-container.ps1` | `deploy-container.sh` |
| [driver-organization](driver-organization/) | Standardize known driver folder names. | `standardize-driver-folders.ps1` | `standardize-driver-folders.sh` |
| [file-combination](file-combination/) | Combine top-level text files into one output file. | `combine-text-files.ps1` | `combine-text-files.sh` |
| [gemini-export](gemini-export/) | Open an approved shared-chat URL and create a manual export file. | `export-shared-chat.ps1` | `export-shared-chat.sh` |
| [git-repository-bootstrap](git-repository-bootstrap/) | Initialize a local repository and configure its remote. | `bootstrap-repository.ps1` | `bootstrap-repository.sh` |
| [git-repository-setup](git-repository-setup/) | Configure workflows and publish an existing repository through `gh`. | `setup-existing-repository.ps1` | `setup-existing-repository.sh` |
| [git-security-hardening](git-security-hardening/) | Generate `.gitignore` rules and untrack local artifacts. | `configure-git-security.ps1` | `configure-git-security.sh` |
| [hardware-inventory](hardware-inventory/) | Collect hardware metadata into placeholder and null-field JSON variants. | `collect-inventory.ps1` | `collect-inventory.sh` |
| [network-diagnostics](network-diagnostics/) | Collect local addresses, ping results, and trace output. | `inspect-network.ps1` | `inspect-network.sh` |
| [network-mapping](network-mapping/) | Map local/public addressing and a configurable route target. | `map-network.ps1` | `map-network.sh` |
| [network-performance](network-performance/) | Measure latency, jitter, and optional HTTPS download performance. | `measure-network.ps1` | `measure-network.sh` |
| [repository-indexing](repository-indexing/) | Create a local file inventory without external AI or uploads. | `index-repository.ps1` | `index-repository.sh` |
| [repository-training-index](repository-training-index/) | Create a local Markdown snapshot of source files for offline training and review. | `generate-training-index.ps1` | `generate-training-index.sh` |
| [ssh-banner](ssh-banner/) | Install a generic SSH pre-login banner and post-login status message. | `configure-ssh-banner.ps1` | `configure-ssh-banner.sh` |
| [terraform-documentation](terraform-documentation/) | Aggregate `.tf` files into Markdown HCL blocks. | `document-terraform.ps1` | `document-terraform.sh` |
| [terraform-generation](terraform-generation/) | Generate a minimal Terraform variables scaffold. | `generate-infrastructure.ps1` | `generate-infrastructure.sh` |

Every row in this table also contains `README.md` and `generate-pair.prompt.md`.

## Generated Artifacts and Side Effects

The local README in each category is the authoritative description of its detailed contract. This summary makes the repository-wide effects visible during review:

| Category | Primary generated artifact or mutation | External side effect |
| --- | --- | --- |
| [asset-tag-migration](asset-tag-migration/) | Rewrites top-level JSON files with sequential `assetTag` values. | None; local file mutation only. |
| [batch-file-renaming](batch-file-renaming/) | Renames top-level files using a generated naming pattern. | None; preview is default. |
| [directory-indexing](directory-indexing/) | Writes a Markdown directory-link index. | None; local metadata only. |
| [docker-deployment](docker-deployment/) | Clones source, builds an image, removes/replaces a container, and starts it. | Docker runtime and repository access. |
| [driver-organization](driver-organization/) | Renames known immediate driver folders. | None; preview is default. |
| [file-combination](file-combination/) | Writes one combined text file from top-level `.txt` inputs. | None; local file output. |
| [gemini-export](gemini-export/) | Opens an approved shared URL and writes a Markdown placeholder. | Browser open only; no scraping. |
| [git-repository-bootstrap](git-repository-bootstrap/) | Creates local Git metadata, origin, README, and initial commit when needed. | No automatic push. |
| [git-repository-setup](git-repository-setup/) | Writes GitHub workflows, branches, commits, and optionally publishes them. | GitHub CLI, remote creation, and pushes. |
| [git-security-hardening](git-security-hardening/) | Writes `.gitignore`, untracks local artifacts, and may create a security commit. | No automatic remote push. |
| [hardware-inventory](hardware-inventory/) | Writes placeholder and null-field hardware JSON inventories. | None; local hardware reads. |
| [network-diagnostics](network-diagnostics/) | Writes JSON/text reachability, address, and trace reports. | Probe traffic to the selected host. |
| [network-mapping](network-mapping/) | Writes local/public address and route-mapping reports. | Public-IP lookup and trace traffic. |
| [network-performance](network-performance/) | Writes latency/jitter and optional HTTPS transfer reports. | ICMP and operator-approved HTTPS traffic. |
| [repository-indexing](repository-indexing/) | Writes a Markdown file metadata table. | None; no file contents uploaded. |
| [repository-training-index](repository-training-index/) | Writes a Markdown snapshot containing selected file contents. | None; output may contain secrets. |
| [ssh-banner](ssh-banner/) | Writes an SSH banner, status script, backup, and daemon configuration. | Elevated host changes and service reload. |
| [terraform-documentation](terraform-documentation/) | Writes Markdown HCL sections from recursive `.tf` files. | None; source may contain secrets. |
| [terraform-generation](terraform-generation/) | Writes a minimal `variables.tf` scaffold and README. | None; no provider or infrastructure call. |

## Documentation Standard

Every maintained category README documents the same review questions:

- **Architectural Role:** why the utility exists and where it belongs in an operational workflow.
- **Contractual Obligations:** accepted inputs, defaults, processing rules, output structure, and failure behavior.
- **Generated Results:** exact files, reports, commits, runtime resources, or in-place mutations produced by execution.
- **Safety and Recovery:** destructive effects, sensitive outputs, backups, authorization gates, and recovery actions.
- **Telemetry & Observability:** local messages, reports, external calls, and data that may appear in logs.
- **Verification:** focused success, failure, idempotence, and platform checks.

The scripts remain concise and operational. Enterprise architecture prose belongs in these READMEs, while `generate-pair.prompt.md` contains the standalone reconstruction contract for another AI.

## Quick Start

### Inspect the Repository

```powershell
./repository-indexing/index-repository.ps1 -RootPath . -Recurse
```

```bash
RECURSIVE=true ./repository-indexing/index-repository.sh . README_INDEX.md
```

### Run a Safe Preview

```powershell
./driver-organization/standardize-driver-folders.ps1 -BasePath C:\path\to\drivers
```

```bash
./batch-file-renaming/rename-files.sh /path/to/files mobile wallpaper
```

### Harden an Existing Git Repository

```powershell
./git-security-hardening/configure-git-security.ps1 -RepositoryPath C:\path\to\repository
```

```bash
./git-security-hardening/configure-git-security.sh /path/to/repository
```

Review the generated `.gitignore`, staged changes, and commit output before sharing the repository.

## Validation

The maintained generation prompts require the following checks for every regenerated pair:

```powershell
$errors = $null
[System.Management.Automation.Language.Parser]::ParseFile(
	(Resolve-Path .\category\task.ps1),
	[ref]$null,
	[ref]$errors
) | Out-Null
if ($errors.Count -gt 0) { $errors | ForEach-Object Message; exit 1 }
```

```bash
bash -n category/task.sh
```

Bash syntax and runtime checks require Bash 4+ through Linux, macOS, WSL, or Git Bash. Scripts that access Docker, GitHub, SSH, hardware, or external network services should be tested in an isolated environment before production use. Never run destructive or publishing workflows against a shared target before reviewing their generated commands and local README.

## Prompt Catalog

The [prompts](prompts/) directory contains historical source prompts and their disposition. Each maintained category keeps its pair-generation prompt beside the scripts. Prompts that describe Java, Next.js, Micronaut, Postman, or Terraform application architecture are documented as archived design inputs rather than converted into misleading shell pairs.

## Security Notes

* Revoke and rotate any credentials that may have existed in historical copies of the legacy scripts.
* Review Git history and remote forks if secrets were ever committed.
* Do not execute deployment, repository publishing, SSH configuration, or hardening scripts without reviewing their target paths and side effects.
* Use `example.invalid`, environment variables, and secret stores for documentation examples.
* Generated inventories, network reports, and Terraform documentation should not be published without redaction.

## License

This project is distributed under the [MIT License](LICENSE).