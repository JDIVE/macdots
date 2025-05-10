# Environment variables
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# Added by Windsurf - Next
export PATH="/Users/jamie/.codeium/windsurf/bin:$PATH"

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_SPACE      # Don't record commands that start with space
setopt HIST_IGNORE_DUPS       # Don't record duplicated commands
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching

# Useful aliases
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# List files
alias ls="ls -G"              # Colorize ls output
alias ll="ls -la"             # List all files in long format
alias la="ls -a"              # List all files
alias l="ls -lh"              # List in long format with human-readable sizes

# Git shortcuts
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --decorate --graph"

# System shortcuts
alias zshrc="$EDITOR ~/.zshrc"         # Quick edit zshrc
alias reload="source ~/.zshrc"         # Reload zshrc
alias brewup="brew update && brew upgrade && brew cleanup"  # Update Homebrew

# Docker/Colima shortcuts
alias dc="docker-compose"
alias dps="docker ps"
alias dimg="docker images"

# macOS specific
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"  # Remove .DS_Store files
