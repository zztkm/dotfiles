# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various development tools. Each tool has its own directory, and platform-specific installation scripts are provided.

## Installation Commands

### Unix/Linux/macOS
```bash
./install.sh
```

### Windows
```batch
install.bat
```

## Architecture & Structure

### Directory Organization
- **bin/**: Executable shell scripts (linked to `~/.local/bin`)
- **copilot-tools/**: Claude CLI tool configuration
- **ghostty/**: Ghostty terminal emulator configuration
- **ideavim/**: Vim configuration for JetBrains IDEs
- **karabiner/**: Karabiner-Elements key remapping rules
- **nvim-config/**: Neovim configuration using Lua
  - Modular structure with separate files for options, keymaps, autocmds, and plugins
  - Uses lazy.nvim for plugin management with lock file for reproducibility
- **opencode/**: OpenCode configuration
- **supercollider/**: Audio synthesis environment startup file
- **tig/**: Tig (Git TUI) configuration
- **tmux/**: Tmux terminal multiplexer configuration
- **vim/**: Vim configuration
- **wezterm/**: WezTerm terminal emulator configuration
- **windows/**: Windows-specific configurations (NYAGOS shell)
- **zellij/**: Zellij terminal multiplexer configuration
- **zsh/**: Zsh shell configuration

### Installation Scripts
The installation scripts create symbolic links from the repository to the appropriate config locations:
- `install.sh`: Creates symlinks for Unix-like systems
- `install.bat`: Creates directory junctions and symlinks for Windows using `mklink`

### Neovim Plugin Management
- Plugin manager: lazy.nvim
- Plugins defined in `nvim-config/lua/plugins/list.lua`
- Lock file: `nvim-config/lazy-lock.json` for reproducible installs
- To update plugins: Open Neovim and use lazy.nvim's built-in commands

### Language Server Protocol (LSP) Setup
The Neovim configuration uses:
- mason.nvim for LSP server management
- nvim-lspconfig for LSP configuration
- Configured servers include Swift, Zig, and typos-lsp
