vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

local base = {
    encoding = "utf-8",
    fileencoding = "utf-8",
    title = true,
    clipboard = "unnamedplus",
    cmdheight = 2,
    laststatus = 2,
    showcmd = true,
    -- completeopt = "menu,menuone,noselect", -- lazy.lua で設定しているのでここはコメントアウト
    mouse = "a",
    smartcase = true,
    smartindent = true,
    termguicolors = true,
    cursorline = false, -- 現在カーソルがあるラインをハイライトする
    number = true,
    ruler = true,
    wrap = true,
    guifont = "Cica",
}

local search = {
    ignorecase = true,
    smartcase = true,
}

local editing = {
    shiftwidth = 4,
    tabstop = 4,
    expandtab = true,
    autoindent = true,
    backspace = "indent,eol,start",
    wrapscan = true,
}

options = {base, search, editing}

for i, option in ipairs(options) do
    for k, v in pairs(option) do
    	vim.opt[k] = v
    end
end

-- fixeol しないようにする
vim.opt.fixeol = false

