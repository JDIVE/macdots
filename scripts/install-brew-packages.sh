#!/usr/bin/env bash

# Homebrew package installation script

set -e  # Exit on any error

echo "Installing Homebrew packages from Brewfile..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the repository root (parent of scripts directory)
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Change to repository root
cd "$REPO_ROOT"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed."
    echo "Install it first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Check if Brewfile exists
if [ ! -f "Brewfile" ]; then
    echo "❌ Brewfile not found in repository root: $REPO_ROOT"
    exit 1
fi

echo "📦 Processing Brewfile..."

# Update Homebrew quietly
brew update > /dev/null 2>&1

# Count packages before installation
BEFORE_COUNT=$(brew list --formula | wc -l | xargs)
BEFORE_CASK_COUNT=$(brew list --cask 2>/dev/null | wc -l | xargs)

# Install packages from Brewfile (suppress most output)
echo "⏳ Installing packages..."
if brew bundle --quiet; then
    # Count packages after installation
    AFTER_COUNT=$(brew list --formula | wc -l | xargs)
    AFTER_CASK_COUNT=$(brew list --cask 2>/dev/null | wc -l | xargs)
    
    NEW_FORMULAS=$((AFTER_COUNT - BEFORE_COUNT))
    NEW_CASKS=$((AFTER_CASK_COUNT - BEFORE_CASK_COUNT))
    
    echo ""
    echo "✅ Installation complete!"
    echo "📈 Summary:"
    echo "   • Formulas: $NEW_FORMULAS new (total: $AFTER_COUNT)"
    echo "   • Casks: $NEW_CASKS new (total: $AFTER_CASK_COUNT)"
    
    if [ $NEW_FORMULAS -eq 0 ] && [ $NEW_CASKS -eq 0 ]; then
        echo "   🎉 All packages were already installed!"
    fi
else
    echo "❌ Some packages had installation issues"
    exit 1
fi

# Clean up quietly
brew cleanup > /dev/null 2>&1

echo ""
echo "To update packages later: brew update && brew upgrade"