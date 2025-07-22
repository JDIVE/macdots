# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS that provides a clean, modern configuration system for command-line tools and development environments. It uses GNU Stow for symlink management and emphasizes modern CLI tools over traditional Unix utilities.

## Key Commands

### Setup and Installation
```bash
# Automated setup (recommended)
./scripts/install-brew-packages.sh    # Install Homebrew packages
./scripts/setup-dotfiles.sh          # Create symlinks with stow
./scripts/setup-git.sh               # Configure Git user settings
./scripts/install-tmux-plugins.sh    # Set up tmux plugins

# Manual setup (alternative)
brew bundle                          # Install packages from Brewfile
stow home config ssh                 # Create symlinks manually
```

### Development Workflow

There are no traditional build/test commands as this is a dotfiles repository. When modifying configurations:

1. Edit files directly in their stow package directories (home/, config/, ssh/)
2. Run `stow -R <package>` to restow if you've made structural changes
3. Source `.zshrc` after changes: `source ~/.zshrc`

### Testing Changes
- For shell configuration changes: Open a new terminal or run `source ~/.zshrc`
- For Neovim changes: Restart Neovim or run `:Lazy sync` for plugin updates
- For tmux changes: Reload config with `Ctrl+Space r` or restart tmux
- For tmux plugins: Install TPM first with `./scripts/install-tmux-plugins.sh`, then press `Ctrl+Space I` in tmux

## Architecture and Structure

The repository follows a stow-based package structure:

```
macdots/
├── home/          # Files that go directly in ~/
├── config/        # Files that go in ~/.config/
├── ssh/           # SSH configuration
├── scripts/       # Utility scripts for setup and maintenance
└── Brewfile       # Declarative package management
```

### Key Configuration Files
- `home/.zshrc` - Main shell configuration with aliases, functions, and tool initialization
- `config/nvim/` - LazyVim-based Neovim configuration
- `config/tmux/tmux.conf` - Tmux configuration with plugin support
- `Brewfile` - All packages managed through Homebrew

### Modern Tool Replacements
This repository uses modern alternatives to traditional Unix tools:
- `eza` instead of `ls`
- `bat` instead of `cat`
- `fd` instead of `find`
- `ripgrep` instead of `grep`
- `btop` instead of `top/htop`

## Important Notes

- The project uses Zsh as the default shell
- All package installations should be added to the Brewfile
- Shell aliases and functions are defined in home/.zshrc
- The repository is designed for macOS only
- Stow must be run from the repository root directory
- Tmux plugins are installed to `~/.config/tmux/plugins/` (not `~/.tmux/plugins/`)
- The tmux prefix key is `Ctrl+Space` (ensure macOS input source switching is disabled)