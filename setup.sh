#!/bin/bash

# setup.sh - Initial setup script for a new Mac
# This script installs essential software and configures the system

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

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to install Homebrew if not already installed
install_homebrew() {
  if ! command_exists brew; then
    print_message "${BLUE}" "🍺" "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH based on chip architecture
    if [[ $(uname -m) == "arm64" ]]; then
      print_message "${BLUE}" "📝" "Adding Homebrew to PATH for Apple Silicon..."
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      print_message "${BLUE}" "📝" "Adding Homebrew to PATH for Intel Mac..."
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    print_message "${GREEN}" "✅" "Homebrew is already installed"
  fi
}

# Install software using Homebrew and Brewfile
install_software() {
  print_message "${BLUE}" "🍺" "Installing software from Brewfile..."

  # Update Homebrew
  brew update

  # Install from Brewfile
  brew bundle

  print_message "${GREEN}" "✅" "Software installation complete"
}

# Set up macOS defaults
setup_macos_defaults() {
  print_message "${BLUE}" "⚙️" "Setting up macOS defaults..."

  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Finder: allow text selection in Quick Look
  defaults write com.apple.finder QLEnableTextSelection -bool true

  # Disable the "Are you sure you want to open this application?" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Trackpad: enable tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Faster key repeat
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Save screenshots to Downloads folder
  mkdir -p "${HOME}/Downloads/Screenshots"
  defaults write com.apple.screencapture location -string "${HOME}/Downloads/Screenshots"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"

  # Restart affected applications
  for app in "Finder" "Dock" "SystemUIServer"; do
    killall "${app}" &> /dev/null
  done

  print_message "${GREEN}" "✅" "macOS defaults configured"
}

# Main function to run the setup
main() {
  print_message "${BLUE}" "🚀" "Starting setup for a new Mac..."

  # Install Xcode Command Line Tools if not already installed
  if ! xcode-select -p &> /dev/null; then
    print_message "${BLUE}" "🛠️" "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait for Xcode CLI tools to be installed
    print_message "${YELLOW}" "⏳" "Waiting for Xcode Command Line Tools to complete installation..."
    print_message "${YELLOW}" "⏳" "Please complete the installation prompt then press Enter to continue..."
    read -r
  else
    print_message "${GREEN}" "✅" "Xcode Command Line Tools are already installed"
  fi

  # Install Homebrew
  install_homebrew

  # Ask user which components to install
  print_message "${BLUE}" "❓" "Which components would you like to install?"

  read -p "Install software (command line tools and applications)? (y/n): " -n 1 -r INSTALL_SOFTWARE
  echo
  read -p "Configure macOS defaults? (y/n): " -n 1 -r SETUP_MACOS
  echo

  # Install selected components
  [[ $INSTALL_SOFTWARE =~ ^[Yy]$ ]] && install_software
  [[ $SETUP_MACOS =~ ^[Yy]$ ]] && setup_macos_defaults

  # Run the dotfiles install script
  print_message "${BLUE}" "🔗" "Setting up dotfiles..."
  ./install.sh

  print_message "${GREEN}" "🎉" "Setup complete! Your Mac is now configured with your preferred settings and software."
  print_message "${YELLOW}" "📝" "Note: Some changes may require a restart to take effect."
}

# Run the main function
main
