#!/usr/bin/env bash
set -euo pipefail

REPOSITORY_PATH="${1:-$PWD}"
GITIGNORE_LANGUAGE="${GITIGNORE_LANGUAGE:-PowerShell}"
REPOSITORY_NAME="${REPOSITORY_NAME:-$(basename "$(cd "$REPOSITORY_PATH" && pwd)")}"
VISIBILITY="${REPOSITORY_VISIBILITY:-private}"
command -v git >/dev/null || { echo "git is required." >&2; exit 1; }
command -v gh >/dev/null || { echo "GitHub CLI is required." >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Authenticate with 'gh auth login' first." >&2; exit 1; }
[[ -d "$REPOSITORY_PATH" ]] || { echo "Repository path does not exist." >&2; exit 1; }
cd "$REPOSITORY_PATH"
[[ -d .git ]] || git init -b developer
gh api "gitignore/templates/${GITIGNORE_LANGUAGE,,}" --jq '.source' > .gitignore 2>/dev/null || true
mkdir -p .github/workflows
cat > .github/workflows/promote-developer-to-stage.yml <<'EOF'
name: Promote Developer To Stage
on:
  push:
    branches: [developer]
jobs:
  promote:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: {fetch-depth: 0}
      - run: git push origin HEAD:stage
EOF
cat > .github/workflows/validate-pull-request.yml <<'EOF'
name: Validate Pull Request
on:
  pull_request:
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: git status --short
EOF
git add .
git diff --cached --quiet || git commit -m "chore: configure repository workflows"
git branch stage 2>/dev/null || true
git branch master 2>/dev/null || true
case "$VISIBILITY" in
    public|private|internal) gh repo create "$REPOSITORY_NAME" "--$VISIBILITY" --source=. --remote=origin --push ;;
    *) echo "REPOSITORY_VISIBILITY must be public, private, or internal." >&2; exit 1 ;;
esac
git push -u origin developer
git push -u origin stage
git push -u origin master