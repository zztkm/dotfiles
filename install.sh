#!/bin/sh

set -e

PWD=`pwd`

ln -sf "${PWD}/zsh/.zshrc" "$HOME/.zshrc"
ln -snf "${PWD}/nvim-config" "$HOME/.config/nvim"
ln -snf "${PWD}/ghostty" "$HOME/.config/ghostty"
ln -snf "${PWD}/zellij" "$HOME/.config/zellij"
ln -snf "${PWD}/copilot-tools" "$HOME/.config/copilot-tools"
# opencode config
mkdir -p "$HOME/.config/opencode"
ln -snf "${PWD}/opencode/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"
# karabiner
ln -snf "${PWD}/karabiner/windows_like_op.json" "$HOME/.config/karabiner/assets/complex_modifications/windows_like_op.json"
# wezterm
ln -snf "${PWD}/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
ln -snf "${PWD}/ideavim/.ideavimrc" "$HOME/.ideavimrc"
ln -snf "${PWD}/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -snf "${PWD}/tig/.tigrc" "$HOME/.tigrc"

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
