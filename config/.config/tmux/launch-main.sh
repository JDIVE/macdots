#!/bin/sh
# Tmux launcher for Ghostty
# This ensures the "main" session is properly initialized with all windows

# Set PATH to include Homebrew
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

SESSION="main"

# Check if session exists
if tmux has-session -t "$SESSION" 2>/dev/null; then
  # Session exists, just attach
  exec tmux attach-session -t "$SESSION"
else
  # Session doesn't exist, create it with all windows
  
  # Window 1: Terminal
  tmux new-session -d -s "$SESSION" -n "terminal"
  tmux send-keys -t "$SESSION:1" "cd ~" C-m
  
  # Window 2: Lyra (Claude Code AI Assistant)
  tmux new-window -t "$SESSION:2" -n "lyra"
  tmux send-keys -t "$SESSION:2" "cd ~ && lyra" C-m
  
  # Window 3: Editor (Neovim)
  tmux new-window -t "$SESSION:3" -n "editor"
  tmux send-keys -t "$SESSION:3" "cd ~ && nvim ." C-m
  
  # Window 4: Files (Yazi file manager)
  tmux new-window -t "$SESSION:4" -n "files"
  tmux send-keys -t "$SESSION:4" "cd ~ && yazi" C-m
  
  # Window 5: Scratch
  tmux new-window -t "$SESSION:5" -n "scratch"
  tmux send-keys -t "$SESSION:5" "cd ~" C-m
  
  # Window 6: System Monitor (btop)
  tmux new-window -t "$SESSION:6" -n "btop"
  tmux send-keys -t "$SESSION:6" "btop" C-m

  # Window 7: Codex
  tmux new-window -t "$SESSION:7" -n "codex"
  tmux send-keys -t "$SESSION:7" "cd ~/Lyra/.claude && codex" C-m

  # Select first window and attach
  tmux select-window -t "$SESSION:1"
  exec tmux attach-session -t "$SESSION"
fi
