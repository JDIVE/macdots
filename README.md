# macOS Dotfiles

My personal dotfiles for macOS, managed with GNU Stow. This repository provides a comprehensive setup for a new Mac with modern command-line tools and productivity applications.

## Overview

This repository contains my personal configuration files (dotfiles) for various tools and applications I use on macOS. The repository is organized into "stow packages" (like `home`, `config`, `ssh`) that mirror the structure of your home directory, making it easy to manage symlinks with GNU Stow.

## What's Included

### Configuration Files
- `home/.zshrc`: Enhanced shell configuration with:
  - Modern command-line tool aliases (eza, bat, fd, etc.)
  - Extensive Git aliases and configurations
  - Docker shortcuts
  - Utility functions (extract, mkcd, weather, etc.)
  - Tool initializations (zoxide, fzf)
- `config/`: (Stored in `macdots/config/`) Configuration files for various tools:
  - `nvim/`: Neovim configuration
  - `tmux/`: Tmux configuration with plugins
  - `gh/`: GitHub CLI configuration
  - `yazi/`: Yazi file manager configuration
- `ssh/config`: (Stored in `macdots/ssh/config`) SSH configuration (without private keys)

### Scripts
- `install.sh`: Dotfiles installation script with:
  - Automatic backup of existing configurations
  - GNU Stow integration for symlink management of specific packages (`home`, `config`, `ssh`)
  - Colorized output and error handling
- `setup.sh`: Complete Mac setup script that:
  - Installs Homebrew
  - Sets up all software from Brewfile
  - Configures macOS defaults
  - Runs the dotfiles installation

### Package Management
- `Brewfile`: Curated list of software organized by category:
  - Modern command-line tools (bat, eza, ripgrep, fd, etc.)
  - Development tools (node, python, lua, etc.)
  - Container tools (Docker Desktop)
  - Applications (Arc, VS Code, Warp, etc.)
  - Productivity tools (Raycast, Notion, etc.)

## Installation

### Quick Setup (New Mac)

For a new Mac, you can use the setup script to install essential software and configure your environment:

1. Clone this repository:
   ```bash
   git clone https://github.com/JDIVE/macdots.git
   cd macdots
   ```

2. Run the setup script:
   **Note:** This script requires superuser privileges to install system-wide tools and configure certain macOS settings. Please run it with `sudo`.
   ```bash
   sudo ./setup.sh
   ```

The setup script will:
- Install Homebrew (if not already installed)
- Install essential command-line tools and applications from the Brewfile
- Configure sensible macOS defaults
- Set up Git with your name and email (interactive prompt)
- Install Arc browser extensions (Bitwarden and Raycast Companion)
- Set up your dotfiles using the install.sh script

### Dotfiles Only

If you only want to install the dotfiles without setting up software:

1. Clone this repository:
   ```bash
   git clone https://github.com/JDIVE/macdots.git
   cd macdots
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

The install script will:
- Back up any existing configuration files
- Use GNU Stow to create symlinks from your home directory to the files within the `home`, `config`, and `ssh` packages in this repository

## Requirements

### For the full setup:
- macOS 10.15 or later
- Internet connection
- Administrator privileges

### For dotfiles only:
- GNU Stow: `brew install stow`

## Key Features

### Modern Command Line Tools
This dotfiles repository integrates many modern replacements for traditional Unix tools:

| Traditional Tool | Modern Replacement | Description |
|------------------|-------------------|-------------|
| `ls` | `eza` | Modern, colorized file listing with Git integration |
| `cat` | `bat` | Syntax highlighting and Git integration |
| `find` | `fd` | Faster and simpler syntax |
| `grep` | `ripgrep` | Faster and respects .gitignore |
| `cd` | `zoxide` | Smarter directory navigation that learns your habits |
| `top` | `btop` | Interactive resource monitor |
| `man` | `tldr` | Simplified, practical command examples |
| `diff` | `git-delta` | Better diffs with syntax highlighting |

### Enhanced Git Experience
- Comprehensive Git aliases for common operations
- Integration with `lazygit` for terminal UI
- Better diffs with `git-delta`
- Improved Git status information in prompts and file listings

### Docker Integration
- Docker Desktop for Mac
- Useful Docker aliases for common operations
- Docker Compose support

### Arc Browser Enhancement
- Automated installation of essential extensions:
  - Bitwarden: Password manager
  - Raycast Companion: Integration with Raycast launcher
- Smart installation that respects Homebrew installation order
- Easy to customize with your preferred extensions

## Customization

The repository is designed to be easily customizable:

- **Brewfile**: Edit to add or remove software packages
- **home/.zshrc**: Modify aliases and functions to suit your workflow
- **setup.sh**: Adjust macOS defaults to your preferences

Feel free to fork this repository and customize it to your needs. The stow package structure (`home/`, `config/`, `ssh/`) mirrors your home directory, making it intuitive to understand and modify.

## Usage Tips

### Useful Aliases and Functions

| Alias/Function | Description |
|----------------|-------------|
| `mkcd <dir>` | Create a directory and cd into it |
| `extract <file>` | Extract any archive file |
| `weather [location]` | Show weather forecast |
| `myip` | Show your public IP address |
| `localip` | Show your local IP address |
| `brewup` | Update Homebrew and all packages |
| `lg` | Launch lazygit terminal UI |
| `lt` | List files in tree view |
| `cat <file>` | View file with syntax highlighting |
| `help <command>` | Show simplified help for a command |

### Git Workflow

The Git aliases are designed to streamline common workflows:

```bash
# Quick status check
gs

# Add changes and commit
ga .
gcm "Your commit message"

# Push changes
gp

# Create and switch to a new branch
gcb feature/new-feature

# Interactive rebase
grb -i main
```

### Docker Commands

```bash
# List running containers
dps

# Execute command in container
dexec container_name bash

# Follow container logs
dlogs container_name
```

## Acknowledgments

This dotfiles repository was inspired by and borrows from:

- [Modern Unix Tools](https://github.com/ibraheemdev/modern-unix)
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)

## License

[MIT License](LICENSE)
