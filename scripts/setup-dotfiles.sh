#!/usr/bin/env bash

# Dotfiles setup script using GNU Stow

set -e  # Exit on any error

echo "Setting up dotfiles with GNU Stow..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the repository root (parent of scripts directory)
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Change to repository root
cd "$REPO_ROOT"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "❌ GNU Stow is not installed."
    echo "Install it with: brew install stow"
    exit 1
fi

# Packages to stow
PACKAGES=("home" "config" "ssh")

echo "📁 Repository root: $(pwd)"
echo "🔗 Setting up symlinks for packages: ${PACKAGES[*]}"
echo ""

# Track what gets linked
LINKED_COUNT=0

for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        echo "⏳ Processing $package..."
        
        # Count files before stowing
        BEFORE=$(find "$package" -type f | wc -l | xargs)
        
        # Stow the package
        if stow -R "$package" 2>/dev/null; then
            echo "   ✅ $package ($BEFORE files)"
            LINKED_COUNT=$((LINKED_COUNT + BEFORE))
        else
            echo "   ⚠️  $package had conflicts (use stow -D $package to remove first)"
        fi
    else
        echo "   ❌ $package directory not found"
    fi
done

echo ""
echo "✅ Dotfiles setup complete!"
echo "📊 Summary: $LINKED_COUNT files symlinked"
echo ""
echo "Your dotfiles are now active. Changes to files in this repo"
echo "will immediately affect your system configuration."