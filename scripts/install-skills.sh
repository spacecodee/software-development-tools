#!/bin/bash

# Function to install a skill
# Usage: install_skill <repo_url> <skill_name>
install_skill() {
    local repo=$1
    local name=$2
    echo "----------------------------------------------------"
    echo "Installing skill: $name from $repo..."
    echo "----------------------------------------------------"
    npx skills add "$repo" --skill "$name"
}

# Ensure we are in the project root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "Starting project skill installation in $(pwd)..."

# List of skills to install
# Format: "repository_url|skill_name"
SKILLS=(
    "https://github.com/vercel-labs/skills|find-skills"
    "https://github.com/anthropics/skills|skill-creator"
    "https://github.com/obra/superpowers|brainstorming"
    "https://github.com/obra/superpowers|sing-superpowers"
    "https://github.com/obra/superpowers|writing-plans"
    "https://github.com/obra/superpowers|executing-plans"
    "https://github.com/juliusbrussee/caveman|caveman"
)

# Loop through the array and install each skill
for skill_entry in "${SKILLS[@]}"; do
    REPO="${skill_entry%|*}"
    NAME="${skill_entry#*|}"
    
    if [[ "$REPO" == "$skill_entry" || -z "$NAME" ]]; then
        echo "Error: Invalid skill format in '$skill_entry'. Use 'repo_url|skill_name'"
        continue
    fi
    
    install_skill "$REPO" "$NAME"
done

echo ""
echo "Skills installation process complete."
