#!/bin/sh

set -e

PWD=`pwd`

ln -sf "${PWD}/.zshrc" "$HOME/.zshrc"
ln -snf "${PWD}/nvim-config" "$HOME/.config/nvim"
ln -snf "${PWD}/ghostty" "$HOME/.config/ghostty"
ln -snf "${PWD}/.config/zellij" "$HOME/.config/zellij"
# .wezterm.lua を $HOME にリンク
ln -snf "${PWD}/.config/.wezterm.lua" "$HOME/.wezterm.lua"
ln -snf "${PWD}/ideavim/.ideavimrc" "$HOME/.ideavimrc"
ln -snf "${PWD}/.tmux.conf" "$HOME/.tmux.conf"

