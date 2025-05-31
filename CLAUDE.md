# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various development tools. The repository is organized with each tool having its own directory, and platform-specific installation scripts are provided.

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
- **nvim-config/**: Neovim configuration using Lua
  - Modular structure with separate files for options, keymaps, autocmds, and plugins
  - Uses lazy.nvim for plugin management with lock file for reproducibility
- **ghostty/**: Terminal emulator configuration
- **ideavim/**: Vim configuration for JetBrains IDEs
- **supercollider/**: Audio synthesis environment startup file
- **windows/**: Windows-specific configurations (NYAGOS shell)

### Installation Scripts
The installation scripts create symbolic links from the repository to the appropriate config locations:
- `install.sh`: Creates symlinks for Unix-like systems
- `install.bat`: Creates directory junctions and symlinks for Windows using `mklink`

Note: The install.sh script references a non-existent `.wezterm.lua` file that should be removed or the file should be added.

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

