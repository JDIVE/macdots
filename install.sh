#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
  local color=$1
  local emoji=$2
  local message=$3
  echo -e "${color}${emoji} ${message}${NC}"
}

print_message "${BLUE}" "⚙️" "Setting up dotfiles..."

# Check if GNU Stow is installed
if ! command -v stow &> /dev/null; then
  print_message "${RED}" "❌" "GNU Stow is not installed. Please install it first."
  print_message "${YELLOW}" "💡" "On macOS, you can install it with: brew install stow"
  exit 1
fi

# Create a backup directory with timestamp
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
print_message "${BLUE}" "📁" "Created backup directory: $BACKUP_DIR"

# Backup existing .config if it exists
if [ -L "$HOME/.config" ]; then
  print_message "${YELLOW}" "🔁" "Existing ~/.config is a symlink, removing it."
  rm "$HOME/.config"
elif [ -d "$HOME/.config" ]; then
  print_message "${YELLOW}" "📦" "Backing up existing ~/.config to $BACKUP_DIR"
  mv "$HOME/.config" "$BACKUP_DIR/"
fi

# Backup common dotfiles
for file in .zshrc .gitconfig .bashrc; do
  if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
    print_message "${YELLOW}" "📦" "Backing up existing $file to $BACKUP_DIR"
    mv "$HOME/$file" "$BACKUP_DIR/"
  elif [ -L "$HOME/$file" ]; then
    print_message "${YELLOW}" "🔗" "Removing existing symlink for $file"
    rm "$HOME/$file"
  fi
done

# Stow it all
print_message "${BLUE}" "🔗" "Stowing files from $(pwd) into ~"
stow -v -t ~ .

# Source the new .zshrc if using zsh
if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/usr/local/bin/zsh" ]; then
  print_message "${BLUE}" "🔄" "Sourcing new .zshrc"
  source "$HOME/.zshrc" 2>/dev/null || true
fi

print_message "${GREEN}" "✅" "Dotfiles installed successfully!"
print_message "${BLUE}" "📝" "Note: You may need to restart your terminal for all changes to take effect."
