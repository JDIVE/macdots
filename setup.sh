#!/bin/bash

# setup.sh - Initial setup script for a new Mac
# This script installs essential software and configures the system
# IMPORTANT: This script should NOT be run with sudo

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

# Check if script is being run with sudo and exit if it is
if [ "$(id -u)" -eq 0 ]; then
  print_message "${RED}" "❌" "This script should NOT be run with sudo or as root!"
  print_message "${YELLOW}" "⚠️" "Running with sudo can cause permission issues with your dotfiles."
  print_message "${YELLOW}" "⚠️" "Please run this script as your normal user. The script will ask for sudo"
  print_message "${YELLOW}" "⚠️" "password only when necessary for specific commands."
  exit 1
fi

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to run commands that require sudo
run_with_sudo() {
  local command_str=$1
  local description=$2
  
  print_message "${YELLOW}" "🔒" "The following operation requires sudo: $description"
  print_message "${YELLOW}" "🔒" "You may be prompted for your password."
  
  sudo bash -c "$command_str"
  
  if [ $? -eq 0 ]; then
    print_message "${GREEN}" "✅" "Successfully completed: $description"
  else
    print_message "${RED}" "❌" "Failed to complete: $description"
  fi
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

  # Finder: ensure sidebar is visible
  defaults write com.apple.finder ShowSidebar -bool true

  # Finder: allow text selection in Quick Look
  defaults write com.apple.finder QLEnableTextSelection -bool true

  # Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Finder: use Column view by default (clmv=Column, Nlsv=List, icnv=Icon, Flwv=Cover Flow/Gallery)
  defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

  # Finder: disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Finder: show the ~/Library folder
  chflags nohidden ~/Library

  # Finder: show the /Volumes folder
  sudo chflags nohidden /Volumes

  # Finder: disable window animations and Get Info animations
  defaults write com.apple.finder DisableAllAnimations -bool true

  # Set new Finder windows to open to the home folder
  # PfHm = Home folder, PfDe = Desktop, PfDo = Documents, PfAF = All My Files, Pfనె = Recents
  # For other specific folders: PfLo = Path to folder, NewWindowTargetPath = file:///path/to/folder/
  defaults write com.apple.finder NewWindowTarget -string "PfHm"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

  print_message "${BLUE}" "⌨️" "Configuring keyboard and trackpad..."
  # Disable the "Are you sure you want to open this application?" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Trackpad: enable tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true # For Bluetooth trackpads
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 # For built-in trackpads and Magic Mouse

  # Trackpad: enable three finger drag
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

  # Faster key repeat
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

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
  # Increase window resize speed for Cocoa applications
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

  # Disable automatic termination of inactive apps
  defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

  # Disable Notification Center and remove the menu bar icon
  launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

  print_message "${GREEN}" "✅" "User-level macOS defaults set successfully"
}

# Function to set up system-level macOS defaults (requires sudo)
setup_system_macos_defaults() {
  print_message "${BLUE}" "⚙️" "Setting up system-level macOS defaults..."
  print_message "${YELLOW}" "🔒" "Some of these operations require sudo privileges."
  print_message "${YELLOW}" "🔒" "You may be prompted for your password."

  # Finder: show all volumes
  run_with_sudo "chflags nohidden /Volumes" "Unhide /Volumes directory"

  print_message "${BLUE}" "🔋" "Configuring power management..."
  # Disable machine sleep while charging
  run_with_sudo "pmset -c sleep 0" "Disable sleep while charging"

  # Set machine sleep to 5 minutes on battery
  run_with_sudo "pmset -b sleep 5" "Set sleep time on battery"

  # Set standby delay to 24 hours (default is 1 hour)
  run_with_sudo "pmset -a standbydelay 86400" "Set standby delay"

  # Never go into computer sleep mode
  run_with_sudo "systemsetup -setcomputersleep Off > /dev/null" "Disable computer sleep mode"

  # Disable hibernation (speeds up entering sleep mode)
  run_with_sudo "pmset -a hibernatemode 0" "Disable hibernation mode"

  # Remove the sleep image file to save disk space
  run_with_sudo "rm -f /private/var/vm/sleepimage && touch /private/var/vm/sleepimage && chflags uchg /private/var/vm/sleepimage" "Configure sleep image file"

  # Disable the sound effects on boot
  run_with_sudo "nvram SystemAudioVolume=\" \"" "Disable boot sound"

  # Time Machine snapshots management removed - command no longer supported in recent macOS versions

  print_message "${GREEN}" "✅" "System-level macOS defaults set successfully"
}

# Combined function to set up all macOS defaults
setup_macos_defaults() {
  # First set user-level defaults (no sudo needed)
  setup_user_macos_defaults
  
  # Then set system-level defaults (with sudo)
  setup_system_macos_defaults
  
  print_message "${BLUE}" "🔄" "Restarting affected applications..."
  # Restart affected applications
  for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Mail" "Messages" "Photos" "Safari" "SystemUIServer" \
    "Terminal"; do
    killall "${app}" &> /dev/null
  done
}

# Install Arc browser extensions
install_arc_extensions() {
  print_message "${BLUE}" "🧩" "Setting up Arc browser extensions..."

  # Check if Arc is installed (check both standard and Homebrew locations)
  if [ ! -d "/Applications/Arc.app" ] && [ ! -d "$(brew --prefix)/Caskroom/arc" ]; then
    print_message "${YELLOW}" "⚠️" "Arc browser is not installed. Skipping extension setup."
    return
  fi

  # Wait a moment to ensure Arc has completed its first-run setup
  print_message "${BLUE}" "⏳" "Waiting for Arc to complete initialization..."
  sleep 3

  # Arc extensions directory
  ARC_EXTENSIONS_DIR="$HOME/Library/Application Support/Arc/User Data/Default/Extensions"

  # Create extensions directory if it doesn't exist
  mkdir -p "$ARC_EXTENSIONS_DIR"

  # Function to install an extension from Chrome Web Store
  install_extension() {
    local extension_id=$1
    local extension_name=$2

    print_message "${BLUE}" "🔄" "Installing $extension_name..."

    # Check if extension is already installed
    if [ -d "$ARC_EXTENSIONS_DIR/$extension_id" ]; then
      print_message "${GREEN}" "✅" "$extension_name is already installed."
      return
    fi

    # Create a temporary directory
    local temp_dir=$(mktemp -d)

    # Download the extension from Chrome Web Store
    curl -L "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=100.0.4896.127&acceptformat=crx2,crx3&x=id%3D$extension_id%26installsource%3Dondemand%26uc" -o "$temp_dir/extension.crx"

    # Create extension directory
    mkdir -p "$ARC_EXTENSIONS_DIR/$extension_id"

    # Unzip the extension
    unzip -q "$temp_dir/extension.crx" -d "$ARC_EXTENSIONS_DIR/$extension_id"

    # Clean up
    rm -rf "$temp_dir"

    print_message "${GREEN}" "✅" "$extension_name installed successfully."
  }

  # List of essential extensions to install
  # Format: "extension_id extension_name"
  extensions=(
    "nngceckbapebfimnlniiiahkandclblb Bitwarden"
    "hoomijgfioaodagdlhjfmllddfgkhioh Raycast Companion"
  )

  # Install each extension
  for extension in "${extensions[@]}"; do
    extension_id=$(echo $extension | cut -d' ' -f1)
    extension_name=$(echo $extension | cut -d' ' -f2-)
    install_extension "$extension_id" "$extension_name"
  done

  print_message "${GREEN}" "✅" "Arc browser extensions setup complete."
  print_message "${YELLOW}" "📝" "Note: You may need to restart Arc browser for all extensions to take effect."
}

# Function to install global npm packages
install_npm_globals() {
  print_message "${BLUE}" "📦" "Installing global npm packages..."

  if ! command_exists npm; then
    print_message "${RED}" "❌" "npm is not installed. Skipping global npm package installation."
    print_message "${YELLOW}" "💡" "Ensure Node.js is installed via Homebrew (e.g., 'brew install node')."
    return 1
  fi

  # Install Claude Code CLI
  print_message "${BLUE}" "💻" "Installing Claude Code CLI (@anthropic-ai/claude-code)..."
  if npm list -g --depth=0 | grep -q '@anthropic-ai/claude-code'; then
    print_message "${GREEN}" "✅" "Claude Code CLI is already installed."
  else
    if npm install -g @anthropic-ai/claude-code; then
      print_message "${GREEN}" "✅" "Claude Code CLI installed successfully."
    else
      print_message "${RED}" "❌" "Failed to install Claude Code CLI."
    fi
  fi

  # Add other global npm packages here if needed in the future
  # Example:
  # print_message "${BLUE}" "📦" "Installing another-package..."
  # if ! npm list -g --depth=0 | grep -q 'another-package'; then
  #   npm install -g another-package
  # fi

  print_message "${GREEN}" "✅" "Global npm package installation complete."
}

# Configure Git user settings
configure_git() {
  print_message "${BLUE}" "🔧" "Configuring Git settings..."

  # Check if Git is installed
  if ! command -v git &> /dev/null; then
    print_message "${YELLOW}" "⚠️" "Git is not installed. Skipping Git configuration."
    return
  fi

  # Check if Git user name is already configured
  current_name=$(git config --global user.name || echo "")
  current_email=$(git config --global user.email || echo "")

  if [[ -n "$current_name" && -n "$current_email" ]]; then
    print_message "${BLUE}" "ℹ️" "Current Git configuration:"
    print_message "${BLUE}" "ℹ️" "Name: $current_name"
    print_message "${BLUE}" "ℹ️" "Email: $current_email"

    read -p "Do you want to update your Git configuration? (y/n): " -n 1 -r UPDATE_GIT
    echo

    if [[ ! $UPDATE_GIT =~ ^[Yy]$ ]]; then
      print_message "${GREEN}" "✅" "Keeping existing Git configuration."
      return
    fi
  fi

  # Prompt for Git user name and email
  print_message "${BLUE}" "👤" "Please enter your Git user information:"
  read -p "Name: " git_name
  read -p "Email: " git_email

  # Validate input
  if [[ -z "$git_name" || -z "$git_email" ]]; then
    print_message "${RED}" "❌" "Name and email cannot be empty. Git configuration skipped."
    return
  fi

  # Configure Git
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"

  # Configure additional useful Git settings
  git config --global init.defaultBranch main
  git config --global pull.rebase false
  git config --global core.editor "nvim"

  print_message "${GREEN}" "✅" "Git configured successfully."
  print_message "${BLUE}" "ℹ️" "Name: $git_name"
  print_message "${BLUE}" "ℹ️" "Email: $git_email"
}

# Main function to run the setup
main() {
  print_message "${BLUE}" "🚀" "Starting setup for a new Mac..."
  print_message "${YELLOW}" "ℹ️" "This script will use sudo only for specific commands that require it."
  print_message "${YELLOW}" "ℹ️" "You will be prompted for your password when necessary."

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
  read -p "Configure Git user settings? (y/n): " -n 1 -r CONFIGURE_GIT
  echo
  read -p "Install Arc browser extensions? (y/n): " -n 1 -r INSTALL_ARC_EXTENSIONS
  echo

  # Install selected components
  [[ $INSTALL_SOFTWARE =~ ^[Yy]$ ]] && install_software
  [[ $SETUP_MACOS =~ ^[Yy]$ ]] && setup_macos_defaults
  [[ $CONFIGURE_GIT =~ ^[Yy]$ ]] && configure_git

  # Install npm globals if software installation was chosen (as Node.js would be installed then)
  if [[ $INSTALL_SOFTWARE =~ ^[Yy]$ ]]; then
    install_npm_globals
  fi

  # Install Arc extensions after software installation to ensure Arc is installed
  if [[ $INSTALL_SOFTWARE =~ ^[Yy]$ && $INSTALL_ARC_EXTENSIONS =~ ^[Yy]$ ]]; then
    print_message "${BLUE}" "ℹ️" "Installing Arc extensions after software installation..."
    install_arc_extensions
  elif [[ $INSTALL_ARC_EXTENSIONS =~ ^[Yy]$ ]]; then
    install_arc_extensions
  fi

  # Run the dotfiles install script (never with sudo)
  print_message "${BLUE}" "🔗" "Setting up dotfiles..."
  ./install.sh

  # Set up SSH directory with correct permissions
  print_message "${GREEN}" "🔒" "Ensuring SSH directory exists with correct permissions..."
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

  # Ensure the stowed SSH config has correct permissions
  if [ -f "$HOME/.ssh/config" ]; then
    print_message "${GREEN}" "🔒" "Setting permissions for ~/.ssh/config..."
    chmod 600 ~/.ssh/config
  fi

  print_message "${GREEN}" "🎨" "Configuring macOS defaults..."
  # Close any open System Preferences panes, to prevent them from overriding settings we're about to change
  osascript -e 'tell application "System Settings" to quit'

  # Configure Dock settings using dockutil (after applications are installed by Brewfile)
  print_message "${GREEN}" "⚓" "Configuring Dock..."
  if command -v dockutil &> /dev/null; then
    dockutil --remove all --no-restart
    dockutil --add '/Applications/Notion.app' --no-restart # User specified
    dockutil --add '/Applications/Notion Mail.app' --no-restart # User specified
    dockutil --add '/Applications/Notion Calendar.app' --no-restart # User specified
    dockutil --add '/Applications/Arc.app' --no-restart
    dockutil --add '/Applications/Claude.app' --no-restart # User specified
    dockutil --add '/System/Applications/Music.app' --no-restart # User specified
    dockutil --add '/Applications/Superwhisper.app' --no-restart # User specified
    dockutil --add '/Applications/Warp.app' --no-restart # User specified
    dockutil --add '/Applications/Reader.app' --no-restart # User specified (Readwise Reader)
    dockutil --add '/Applications/Visual Studio Code.app' --no-restart # User specified
    dockutil --add '/Applications/Linear.app' --no-restart # User specified (Linear)
    dockutil --add '/Applications/Windsurf Next.app' --no-restart # User specified
    # Add Downloads folder. Add other folders/stacks as needed.
    dockutil --add '~/Downloads' --view grid --display folder --sort dateadded --no-restart
   
    killall Dock
  else
    print_message "${RED}" "⚠️" "dockutil not found. Skipping Dock configuration."
  fi

  print_message "${GREEN}" "🎉" "macOS setup complete!"
  print_message "${YELLOW}" "📝" "Note: Some changes may require a restart to take effect."
}

# Run the main function
main
