#!/bin/sh
# Tmux session setup script for "main" session
# This runs via the session-created hook

SESSION="main"

# Check if the "main" session exists
tmux has-session -t "$SESSION" 2>/dev/null || exit 0

# Only run if it has exactly 1 window (meaning it was just created)
WINDOW_COUNT="$(tmux list-windows -t "$SESSION" 2>/dev/null | wc -l | tr -d ' ')"

if [ "$WINDOW_COUNT" -ne 1 ]; then
  exit 0  # Already set up
fi

# Rename first window to "terminal"
tmux rename-window -t $SESSION:1 "terminal"
tmux send-keys -t $SESSION:1 "cd ~" C-m

# Window 2: Lyra (Claude Code AI Assistant)
tmux new-window -t $SESSION:2 -n "lyra"
tmux send-keys -t $SESSION:2 "cd ~ && lyra" C-m

# Window 3: Editor (Neovim)
tmux new-window -t $SESSION:3 -n "editor"
tmux send-keys -t $SESSION:3 "cd ~ && nvim ." C-m

# Window 4: Files (Yazi file manager)
tmux new-window -t $SESSION:4 -n "files"
tmux send-keys -t $SESSION:4 "cd ~ && yazi" C-m

# Window 5: Scratch
tmux new-window -t $SESSION:5 -n "scratch"
tmux send-keys -t $SESSION:5 "cd ~" C-m

# Window 6: System Monitor (btop)
tmux new-window -t $SESSION:6 -n "btop"
tmux send-keys -t $SESSION:6 "btop" C-m

# Select first window
tmux select-window -t $SESSION:1
