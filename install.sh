#!/bin/sh

set -e

PWD=`pwd`

ln -snf "${PWD}/nvim-config" "$HOME/.config/nvim"
# .wezterm.lua を $HOME にリンク
ln -snf "${PWD}/.config/.wezterm.lua" "$HOME/.wezterm.lua"

ln -snf "${PWD}/ideavim/.ideavimrc" "$HOME/.ideavimrc"

