# Generate the Git Security Hardening Pair From Scratch

Act as a senior DevOps maintainer. Generate exactly `configure-git-security.ps1`, `configure-git-security.sh`, and a local `README.md`.

## Objective and Inputs

Apply a repository-local `.gitignore` policy and untrack selected local artifacts without deleting them from disk. PowerShell must accept `-RepositoryPath`; Bash must accept the repository path as its first argument. Default to the current directory.

## Required Behavior

- Validate that the target is an existing Git repository with a usable Git identity.
- Replace or generate `.gitignore` rules for compiled artifacts, archives, build output, IDE files, Postman reports, logs, temporary files, OS metadata, environment files, and local secrets.
- Detect tracked paths such as `build/`, `.gradle/`, `.idea/`, `bin/`, `out/`, and `*.iml` and remove them from the index with `git rm --cached` while preserving working-tree files.
- Show the proposed `.gitignore` and staged changes before committing.
- Require explicit confirmation before broad staging and the documented security commit; never silently publish or push.
- Report the final `git status` and commit result.

## Safety and Parity

Use caller paths only. Never embed credentials, hosts, tokens, private paths, or personal identifiers. Do not delete ignored files from disk or rewrite history. Treat `.gitignore` replacement, broad staging, and automatic commits as high-impact operations. PowerShell and Bash must produce equivalent policy, untracking behavior, confirmation flow, and output. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, review steps, and recovery guidance.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test an isolated repository with tracked artifacts, untracked artifacts, a missing Git identity, and a declined confirmation. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.