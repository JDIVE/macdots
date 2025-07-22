#!/usr/bin/env bash

echo "Setting up tmux plugins..."

# Install TPM if not already installed
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
else
    echo "TPM already installed"
fi

echo ""
echo "To complete the setup:"
echo "1. Start tmux: tmux"
echo "2. Press Ctrl+Space (prefix) followed by 'I' (capital i) to install plugins"
echo "3. Or run: ~/.config/tmux/plugins/tpm/bin/install_plugins"
echo ""
echo "If plugins still don't work:"
echo "- Make sure you're using the correct prefix (Ctrl+Space, not Ctrl+b)"
echo "- Try reloading config: Ctrl+Space + r"
echo "- Kill all tmux sessions and restart: tmux kill-server"