# macOS Dotfiles

My personal dotfiles for macOS, managed with GNU Stow.

## Overview

This repository contains my personal configuration files (dotfiles) for various tools and applications I use on macOS. The repository structure mirrors my home directory, making it easy to understand where each file will be placed.

## What's Included

- `.zshrc`: Shell configuration with useful aliases and settings
- `.config/`: Configuration files for various tools
  - `nvim/`: Neovim configuration
  - `tmux/`: Tmux configuration
  - `gh/`: GitHub CLI configuration
  - `yazi/`: Yazi file manager configuration
- `.ssh/config`: SSH configuration (without private keys)
- `install.sh`: Installation script

## Installation

### Quick Setup (New Mac)

For a new Mac, you can use the setup script to install essential software and configure your environment:

1. Clone this repository:
   ```bash
   git clone https://github.com/JDIVE/macdots.git
   cd macdots
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

The setup script will:
- Install Homebrew (if not already installed)
- Install essential command-line tools and applications from the Brewfile
- Configure sensible macOS defaults
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
- Use GNU Stow to create symlinks from your home directory to the files in this repository

## Requirements

For the full setup:
- macOS 10.15 or later
- Internet connection
- Administrator privileges

For dotfiles only:
- GNU Stow: `brew install stow`

## Customization

The Brewfile contains all the software that will be installed. Feel free to edit it to add or remove packages according to your needs.

Feel free to fork this repository and customize it to your needs. The structure is designed to be intuitive and easy to modify.

## License

[MIT License](LICENSE)
