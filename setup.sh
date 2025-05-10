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

  print_message "${BLUE}" "🔍" "Configuring Finder preferences..."
  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Finder: allow text selection in Quick Look
  defaults write com.apple.finder QLEnableTextSelection -bool true

  # Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Finder: use list view by default
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Finder: disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Finder: show the ~/Library folder
  chflags nohidden ~/Library

  # Finder: show the /Volumes folder
  sudo chflags nohidden /Volumes

  # Finder: disable window animations and Get Info animations
  defaults write com.apple.finder DisableAllAnimations -bool true

  print_message "${BLUE}" "⌨️" "Configuring keyboard and trackpad..."
  # Disable the "Are you sure you want to open this application?" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Trackpad: enable tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Trackpad: enable three finger drag
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

  # Faster key repeat
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Disable automatic capitalization
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

  # Disable smart dashes
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  # Disable automatic period substitution
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

  # Disable smart quotes
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

  print_message "${BLUE}" "🖥️" "Configuring system UI and behavior..."
  # Save screenshots to Downloads folder
  mkdir -p "${HOME}/Downloads/Screenshots"
  defaults write com.apple.screencapture location -string "${HOME}/Downloads/Screenshots"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"

  # Disable screenshot preview thumbnails
  defaults write com.apple.screencapture show-thumbnail -bool false

  # Enable subpixel font rendering on non-Apple LCDs
  defaults write NSGlobalDomain AppleFontSmoothing -int 2

  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # Expand print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Disable the "Are you sure you want to open this application?" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable Resume system-wide
  defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

  print_message "${BLUE}" "🚀" "Configuring Dock..."
  # Set the icon size of Dock items
  defaults write com.apple.dock tilesize -int 48

  # Change minimize/maximize window effect
  defaults write com.apple.dock mineffect -string "scale"

  # Minimize windows into their application's icon
  defaults write com.apple.dock minimize-to-application -bool true

  # Enable spring loading for all Dock items
  defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

  # Show indicator lights for open applications in the Dock
  defaults write com.apple.dock show-process-indicators -bool true

  # Don't animate opening applications from the Dock
  defaults write com.apple.dock launchanim -bool false

  # Speed up Mission Control animations
  defaults write com.apple.dock expose-animation-duration -float 0.1

  # Don't automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true

  # Make Dock icons of hidden applications translucent
  defaults write com.apple.dock showhidden -bool true

  # Don't show recent applications in Dock
  defaults write com.apple.dock show-recents -bool false

  # Set Dock position to left
  defaults write com.apple.dock orientation -string "left"

  print_message "${BLUE}" "🔒" "Configuring security and privacy..."
  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # Disable the crash reporter
  defaults write com.apple.CrashReporter DialogType -string "none"

  # Disable shadow in screenshots
  defaults write com.apple.screencapture disable-shadow -bool true

  print_message "${BLUE}" "🌐" "Configuring Safari..."
  # Privacy: don't send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

  # Show the full URL in the address bar
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

  # Enable Safari's debug menu
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  # Enable the Develop menu and the Web Inspector
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

  # Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  print_message "${BLUE}" "⚡" "Configuring performance and energy settings..."
  # Disable sudden motion sensor (not needed for SSDs)
  sudo pmset -a sms 0

  # Disable hibernation (speeds up entering sleep mode)
  sudo pmset -a hibernatemode 0

  # Remove the sleep image file to save disk space
  sudo rm -f /private/var/vm/sleepimage
  # Create a zero-byte file instead
  sudo touch /private/var/vm/sleepimage
  # Make sure it can't be rewritten
  sudo chflags uchg /private/var/vm/sleepimage

  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "

  # Increase window resize speed for Cocoa applications
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

  # Speed up wake from sleep to 24 hours from an hour
  # http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
  sudo pmset -a standbydelay 86400

  # Disable local Time Machine snapshots
  sudo tmutil disablelocal

  print_message "${BLUE}" "🧹" "Configuring cleanup and maintenance..."
  # Disable the "Are you sure you want to open this application?" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable Notification Center and remove the menu bar icon
  launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

  # Disable automatic termination of inactive apps
  defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Disable smart quotes and smart dashes
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  print_message "${BLUE}" "🔄" "Restarting affected applications..."
  # Restart affected applications
  for app in "Finder" "Dock" "SystemUIServer" "Safari" "Activity Monitor" "cfprefsd"; do
    killall "${app}" &> /dev/null
  done

  print_message "${GREEN}" "✅" "macOS defaults configured"
  print_message "${YELLOW}" "⚠️" "Note: Some of these changes require a logout/restart to take effect."
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
