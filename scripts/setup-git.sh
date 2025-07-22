#!/usr/bin/env bash

# Git configuration setup script

echo "Setting up Git configuration..."

# Check if git config is already set
if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
    echo "Git user configuration already exists:"
    echo "  Name: $(git config --global user.name)"
    echo "  Email: $(git config --global user.email)"
    echo ""
    read -p "Do you want to update it? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Keeping existing configuration."
        exit 0
    fi
fi

# Prompt for user information
echo ""
read -p "Enter your full name for Git commits: " git_name
read -p "Enter your email for Git commits: " git_email

# Set Git configuration
git config --global user.name "$git_name"
git config --global user.email "$git_email"

# Set some useful defaults
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global push.autoSetupRemote true

echo ""
echo "Git configuration complete!"
echo "  Name: $(git config --global user.name)"
echo "  Email: $(git config --global user.email)"
echo ""
echo "Additional settings applied:"
echo "  - Default branch: main"
echo "  - Pull strategy: merge (not rebase)"
echo "  - Auto setup remote on push"