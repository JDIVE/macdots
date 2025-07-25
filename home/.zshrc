# Environment variables
export PATH="$HOME/.npm-global/bin:$PATH"

# Default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Tmux theme - Choose 'onedark' or 'nord' for your preferred theme
export TMUX_THEME="onedark" # Change to 'nord' if you prefer that theme

# FZF configuration
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"

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

# List files (using eza, a modern ls replacement)
alias ls="eza --color=auto"                # Modern ls with colors
alias ll="eza -la --git --icons"           # Long listing with git status and icons
alias la="eza -a --icons"                  # List all files with icons
alias l="eza -l --git --icons"             # Long format with git status and icons
alias lt="eza -T --icons --git-ignore"     # Tree view
alias lta="eza -Ta --icons"                # Tree view with hidden files
alias lg="eza -l --git --icons --git-ignore" # Long listing with git status

# Fallback to standard ls if eza is not available
if ! command -v eza &> /dev/null; then
  alias ls="ls -G"
  alias ll="ls -la"
  alias la="ls -a"
  alias l="ls -lh"
fi

# Git shortcuts
alias g="git"
alias gs="git status -sb"                  # Short status with branch info
alias ga="git add"
alias gaa="git add --all"                  # Add all changes
alias gc="git commit"
alias gcm="git commit -m"                  # Commit with message
alias gca="git commit --amend"             # Amend previous commit
alias gp="git push"
alias gpf="git push --force-with-lease"    # Safer force push
alias gl="git pull"
alias gf="git fetch --all --prune"         # Fetch and prune
alias gd="git diff"
alias gds="git diff --staged"              # Diff staged changes
alias gco="git checkout"
alias gcb="git checkout -b"                # Create and checkout new branch
alias gb="git branch"
alias gba="git branch -a"                  # List all branches
alias gbd="git branch -d"                  # Delete branch
alias gbD="git branch -D"                  # Force delete branch
alias glog="git log --oneline --decorate --graph"
alias gloga="git log --oneline --decorate --graph --all" # Show all branches
alias grb="git rebase"
alias gst="git stash"
alias gstp="git stash pop"
alias gsts="git stash show --text"

# System shortcuts
alias zshrc="$EDITOR ~/.zshrc"                                 # Quick edit zshrc
alias reload="source ~/.zshrc"                                 # Reload zshrc
alias brewup="brew update && brew upgrade && brew cleanup"     # Update Homebrew
alias path="echo $PATH | tr ':' '\\n'"                          # Print PATH in readable format
alias ports="sudo lsof -iTCP -sTCP:LISTEN -n -P"              # Show open ports
alias myip="curl -s https://api.ipify.org && echo"            # Show public IP address
alias localip="ipconfig getifaddr en0"                        # Show local IP address
alias c="clear"                                               # Clear terminal

# Docker shortcuts
alias dc="docker-compose"
alias dps="docker ps"
alias dpsa="docker ps -a"                                      # Show all containers
alias dimg="docker images"
alias drmi="docker rmi"                                        # Remove images
alias drmif="docker rmi -f"                                    # Force remove images
alias dstop="docker stop"                                      # Stop containers
alias drm="docker rm"                                          # Remove containers
alias dexec="docker exec -it"                                  # Execute command in container
alias dlogs="docker logs -f"                                   # Follow container logs

# Enhanced tools aliases
alias cat="bat --paging=never"                                 # Use bat instead of cat
alias preview="bat --color=always"                             # Preview files with syntax highlighting
alias top="btop"                                               # Better top
alias find="fd"                                                # Better find
# alias cd="z"                                                   # Use zoxide for better cd (commented out to avoid Claude Code issues)

# macOS specific
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder" # Flush DNS cache

# Quick folder navigation
alias dev="cd ~/Development"
alias docs="cd ~/Documents"
alias dl="cd ~/Downloads"

# Utility functions
# Create a new directory and enter it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract most know archives with one command
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Launch Claude Code inside ~/assistant, then pop back to where you were
assist() {
  (cd ~/assistant && claude "$@")
}

# Initialize fzf
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif command -v fzf &> /dev/null; then
  # Try to find fzf installation
  if [ -f /usr/local/opt/fzf/shell/completion.zsh ]; then
    source /usr/local/opt/fzf/shell/key-bindings.zsh
    source /usr/local/opt/fzf/shell/completion.zsh
  elif [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    source /opt/homebrew/opt/fzf/shell/completion.zsh
  fi
fi

# Conditional compinit initialization (skip for Warp Terminal)
if [[ "$TERM_PROGRAM" != "WarpTerminal" ]]; then
  autoload -Uz compinit
  if [ -n "$ZDOTDIR/.zcompdump" ]; then # Check if a zcompdump specific to ZDOTDIR exists
    compinit -i -d "$ZDOTDIR/.zcompdump"
  else
    compinit -i # Fallback to default zcompdump location if specific one not found
  fi
  # For more aggressive caching, consider:
  # compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump-$ZSH_VERSION"
fi

# ZSH Plugins via Homebrew
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
