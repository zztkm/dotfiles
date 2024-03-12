#!/bin/sh

set -e

PWD=`pwd`

ln -snf "${PWD}/.config/nvim" "$HOME/.config/nvim"
# .wezterm.lua を $HOME にリンク
ln -snf "${PWD}/.config/.wezterm.lua" "$HOME/.wezterm.lua"

