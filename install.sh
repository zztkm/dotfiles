#!/bin/sh

set -e

PWD=`pwd`

ln -sf "${PWD}/.zshrc" "$HOME/.zshrc"
ln -snf "${PWD}/nvim-config" "$HOME/.config/nvim"
ln -snf "${PWD}/ghostty" "$HOME/.config/ghostty"
ln -snf "${PWD}/.config/zellij" "$HOME/.config/zellij"
ln -snf "${PWD}/copilot-tools" "$HOME/.config/copilot-tools"
# opencode config
mkdir -p "$HOME/.config/opencode"
ln -snf "${PWD}/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"
# .wezterm.lua を $HOME にリンク
ln -snf "${PWD}/.config/.wezterm.lua" "$HOME/.wezterm.lua"
ln -snf "${PWD}/ideavim/.ideavimrc" "$HOME/.ideavimrc"
ln -snf "${PWD}/.tmux.conf" "$HOME/.tmux.conf"
ln -snf "${PWD}/.tigrc" "$HOME/.tigrc"

# Create ~/.local/bin if it doesn't exist
mkdir -p "$HOME/.local/bin"

# Symlink executable scripts from bin/ directory
for script in "${PWD}/bin"/*; do
  if [ -f "$script" ]; then
    script_name=$(basename "$script")
    ln -sf "$script" "$HOME/.local/bin/$script_name"
    chmod +x "$HOME/.local/bin/$script_name"
  fi
done
