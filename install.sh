#!/usr/bin/env bash

set -euo pipefail

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

# Backup common dotfiles (if they exist directly in ~ and are not symlinks)
# We'll primarily let stow handle conflicts, but good to back up direct files if they exist and would be overwritten.
# .zshrc and .gitattributes are now in the 'home' stow package.
for file_in_home in .zshrc .gitattributes; do # Add other files here if they are top-level in 'home' package
  if [ -f "$HOME/$file_in_home" ] && [ ! -L "$HOME/$file_in_home" ]; then
    print_message "${YELLOW}" "📦" "Backing up existing $file_in_home to $BACKUP_DIR"
    mv "$HOME/$file_in_home" "$BACKUP_DIR/"
  elif [ -L "$HOME/$file_in_home" ]; then
    print_message "${YELLOW}" "🔗" "Removing existing symlink for $file_in_home"
    rm "$HOME/$file_in_home"
  fi
done

# For other files not explicitly in stow packages that might have been previously backed up:
for other_file in .gitconfig .bashrc; do # Add other files here if necessary
  if [ -f "$HOME/$other_file" ] && [ ! -L "$HOME/$other_file" ]; then
    print_message "${YELLOW}" "📦" "Backing up existing $other_file to $BACKUP_DIR"
    mv "$HOME/$other_file" "$BACKUP_DIR/"
  elif [ -L "$HOME/$other_file" ]; then
    print_message "${YELLOW}" "🔗" "Removing existing symlink for $other_file"
    rm "$HOME/$other_file"
  fi
done

# Stow it all
STOW_PACKAGES=(home config ssh) # .config will be treated as 'config' by stow
print_message "${BLUE}" "🔗" "Stowing packages: ${STOW_PACKAGES[*]} from $(pwd) into ~"
stow -v -t ~ "${STOW_PACKAGES[@]}"

# Source the new .zshrc if using zsh
if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/usr/local/bin/zsh" ]; then
  print_message "${BLUE}" "🔄" "Sourcing new .zshrc"
  # shellcheck disable=SC1090
  source "$HOME/.zshrc" 2>/dev/null || true
fi

print_message "${GREEN}" "✅" "Dotfiles installed successfully!"
print_message "${BLUE}" "📝" "Note: You may need to restart your terminal for all changes to take effect."
