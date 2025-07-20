# macOS Dotfiles

My personal dotfiles for macOS, managed with GNU Stow. This is a lean repository focused on essential configuration files and modern command-line tools.

## Overview

This repository contains my personal configuration files (dotfiles) for various tools and applications I use on macOS. The repository is organized into "stow packages" (like `home`, `config`, `ssh`) that mirror the structure of your home directory, making it easy to manage symlinks with GNU Stow.

## What's Included

### Configuration Files

- `home/.zshrc`: Enhanced shell configuration with:
  - Modern command-line tool aliases (eza, bat, fd, etc.)
  - Extensive Git aliases and configurations
  - Docker shortcuts
  - Utility functions (extract, mkcd, weather, etc.)
  - Tool initializations (fzf)
  - Shell enhancements (zsh-autosuggestions, zsh-syntax-highlighting)
- `config/`: (Stored in `macdots/config/`) Configuration files for various tools:
  - `nvim/`: Neovim configuration
  - `tmux/`: Tmux configuration with plugins
  - `gh/`: GitHub CLI configuration
  - `yazi/`: Yazi file manager configuration
- `ssh/config`: (Stored in `macdots/ssh/config`) SSH configuration (without private keys)

### Package Management

- `Brewfile`: Curated list of software organized by category:
  - Core command-line tools (bat, btop, curl, eza, fd, fzf, gh, jq, neovim, ripgrep, stow, tmux, wget, yq)
  - Shell enhancements (zsh-autosuggestions, zsh-syntax-highlighting)
  - Development tools (node, uv, tree-sitter)
  - Container tools (Docker Desktop, docker-compose)
  - Applications (Visual Studio Code, Warp, Zed, Google Chrome)
  - Productivity tools (Raycast, ChatGPT, Claude, Google Drive, Discord)
  - Fonts (Fira Code, JetBrains Mono, Hack Nerd Font)

## Quick Setup

Get started with three simple steps:

1. **Clone repo** → `git clone https://github.com/JDIVE/macdots.git \u0026\u0026 cd macdots`
2. **Install packages** → `brew bundle`
3. **Deploy dotfiles** → `stow home config ssh`

**Note**: For further system automation (macOS defaults, application settings, etc.), an external AI setup agent will handle further customizations.

## Manual Installation (Detailed)

If you prefer to understand each step:

### Prerequisites

1. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```

2. **Homebrew**:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **GNU Stow**:
   ```bash
   brew install stow
   ```

### Deploy Configuration

```bash
# Clone the repository
git clone https://github.com/JDIVE/macdots.git
cd macdots

# Install software dependencies
brew bundle install

# Create symlinks for dotfiles
stow home config ssh
```

## Note

Deleted scripts like `setup.sh` and `install.sh` can be copied or adapted from the repository history if needed.

## Requirements

- macOS 10.15 or later
- Internet connection
- GNU Stow: `brew install stow`
- Homebrew (for installing software dependencies)

## Key Features

### Modern Command Line Tools

This dotfiles repository integrates many modern replacements for traditional Unix tools:

| Traditional Tool | Modern Replacement | Description |
|------------------|-------------------|-------------|
| `ls` | `eza` | Modern, colorized file listing with Git integration |
| `cat` | `bat` | Syntax highlighting and Git integration |
| `find` | `fd` | Faster and simpler syntax |
| `grep` | `ripgrep` | Faster and respects .gitignore |
| `top` | `btop` | Interactive resource monitor |
| `python pip` | `uv` | Extremely fast Python package installer and resolver |
|| `curl/wget` | `curl/wget` | HTTP/file transfer tools |

### Enhanced Git Experience

- Comprehensive Git aliases for common operations
- GitHub CLI integration with `gh`
- JSON/YAML processing with `jq` and `yq`
- Fuzzy finding with `fzf`
- Improved Git status information in prompts and file listings

### Docker Integration

- Docker Desktop for Mac
- Useful Docker aliases for common operations
- Docker Compose support

### Development Environment

- **Visual Studio Code**: Primary code editor with extensions
- **Neovim**: Terminal-based text editor with modern configuration
- **Warp**: Modern terminal with AI features (preview version)
- **Zed**: Fast, collaborative code editor (preview version)
- **Tmux**: Terminal multiplexer for session management
- **Tree-sitter**: Advanced syntax highlighting and code parsing
- **Node.js**: JavaScript runtime for development

### Productivity Applications

- **Raycast**: Powerful launcher and productivity tool
- **ChatGPT**: OpenAI desktop application for AI assistance
- **Claude**: Anthropic AI assistant desktop application
- **Google Chrome**: Web browser
- **Google Drive**: Cloud storage integration
- **Discord**: Communication and community platform

## Customization

The repository is designed to be easily customizable:

- **Brewfile**: Edit to add or remove software packages
- **home/.zshrc**: Modify aliases and functions to suit your workflow
- **Configuration files**: Edit any dotfiles in the `home/`, `config/`, or `ssh/` directories to suit your preferences

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
| `lt` | List files in tree view |
| `cat <file>` | View file with syntax highlighting |

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
