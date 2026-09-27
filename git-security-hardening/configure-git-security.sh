#!/usr/bin/env bash

set -euo pipefail

REPOSITORY_PATH="${1:-$PWD}"
REPOSITORY_PATH="$(cd "$REPOSITORY_PATH" && pwd)"
cd "$REPOSITORY_PATH"

echo "Starting Git security hardening..."

if [[ ! -e ".git" ]]; then
    echo "Error: the target directory is not a Git repository. Run 'git init' first or provide the repository root as the first argument." >&2
    exit 1
fi

cat > .gitignore <<'EOF'
# Java and compiled artifacts
*.class
*.pyc
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar
hs_err_pid*
replay_pid*

# Gradle and build outputs
.gradle/
build/
bin/
out/
.micronaut-cli.yml.tmp
**/build/
**/out/

# IDE and editor configuration
.idea/
*.iml
*.iws
*.ipr
.vscode/
.classpath
.project
.settings/
.factorypath

# Postman and Newman local reports
reports/
*.html
PostMan-Collection/*.data.json
PostMan-Collection/*_working_copy.json
PostMan-Collection/*.bak

# Logs and temporary files
*.log
logs/
*.tmp
*.bak
*.swp
.DS_Store
Thumbs.db
EOF

echo "Removing tracked build, cache, and IDE files..."
for cached_path in build/ .gradle/ .idea/ bin/ out/ '*.iml'; do
    git rm -r --cached --ignore-unmatch -- "$cached_path"
done

echo "Staging .gitignore and index changes..."
git add .

echo "Committing security hardening changes..."
git commit -m "security: apply gitignore and untrack local artifacts"

echo "Git security hardening completed successfully."