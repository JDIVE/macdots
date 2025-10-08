#!/bin/sh
# Tmux session setup script for "main" session
# This runs once when the session is first created

SESSION="main"

# Check if session already exists
tmux has-session -t $SESSION 2>/dev/null
if [ $? -eq 0 ]; then
  exit 0  # Session exists, nothing to do
fi

# Create session with first window
tmux new-session -d -s $SESSION -n "editor"

# Create additional windows
tmux new-window -t $SESSION:2 -n "terminal"
tmux new-window -t $SESSION:3 -n "projects"
tmux new-window -t $SESSION:4 -n "dotfiles"

# Set working directories for each window
tmux send-keys -t $SESSION:1 "cd ~" C-m
tmux send-keys -t $SESSION:2 "cd ~" C-m
tmux send-keys -t $SESSION:3 "cd ~/projects" C-m
tmux send-keys -t $SESSION:4 "cd ~/macdots" C-m

# Select first window
tmux select-window -t $SESSION:1
