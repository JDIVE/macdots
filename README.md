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

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/macdots.git
   cd macdots
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

The script will:
- Back up any existing configuration files
- Use GNU Stow to create symlinks from your home directory to the files in this repository

## Requirements

- GNU Stow: `brew install stow`

## Customization

Feel free to fork this repository and customize it to your needs. The structure is designed to be intuitive and easy to modify.

## License

[MIT License](LICENSE)
