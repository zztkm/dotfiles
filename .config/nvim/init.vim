" requirements
" nerd-fonts
" 	https://github.com/ryanoasis/nerd-fonts#font-installation
" 	if you use iTerm2
" 	https://zenn.dev/hisasann/articles/e8e6b17bf9faab#iterm2%E3%81%AEnon-ascii-font%E3%82%92%E6%8C%87%E5%AE%9A%E3%81%99%E3%82%8B
" silicon
" 	https://github.com/segeljakt/vim-silicon
" let mapleader = "\<Space>"

set mouse=a
set clipboard=unnamed

set termguicolors

" font
set guifont=Cica

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
set shiftwidth=4
" タブの画面上での幅
set tabstop=4
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を非表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title

if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

" color settings
" call minpac#add('EdenEast/nightfox.nvim')
call minpac#add('folke/tokyonight.nvim')
colorscheme tokyonight-moon

" いろんなやつが依存してる
call minpac#add('nvim-lua/plenary.nvim')

" for denops
call minpac#add('vim-denops/denops.vim')
"call minpac#add('kat0h/bufpreview.vim', {'do': 'silent! !deno task prepare'})
call minpac#add('zztkm/bufpreview.vim', {'do': 'silent! !deno task prepare', 'branch': 'feat-mermaid'})

" for telekasten.nvim
call minpac#add('nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' })
call minpac#add('nvim-telescope/telescope.nvim')

" tree viewer
call minpac#add('lambdalisue/fern.vim')

" quickfix
call minpac#add('kevinhwang91/nvim-bqf')

" look
call minpac#add('nvim-lualine/lualine.nvim')
call minpac#add('kyazdani42/nvim-web-devicons')
call minpac#add('rcarriga/nvim-notify')

call minpac#add('folke/todo-comments.nvim')

" for lang
call minpac#add('ollykel/v-vim')

" doc generate
call minpac#add('kkoomen/vim-doge', { 'do': 'packloadall! | call doge#install()'})

" git
call minpac#add('TimUntersberger/neogit')
call minpac#add('sindrets/diffview.nvim')
call minpac#add('lewis6991/gitsigns.nvim')

" util
call minpac#add('bronson/vim-trailing-whitespace')
call minpac#add('tyru/open-browser.vim')
call minpac#add('iamcco/markdown-preview.nvim', {'do': 'packloadall! | call mkdp#util#install()'})
call minpac#add('segeljakt/vim-silicon')

" lsp
call minpac#add('williamboman/mason.nvim')
call minpac#add('williamboman/mason-lspconfig.nvim')
call minpac#add('neovim/nvim-lspconfig')

call minpac#add('neovim/nvim-lspconfig')
call minpac#add('hrsh7th/cmp-nvim-lsp')
call minpac#add('hrsh7th/cmp-buffer')
call minpac#add('hrsh7th/cmp-path')
call minpac#add('hrsh7th/cmp-cmdline')
call minpac#add('hrsh7th/cmp-emoji')
call minpac#add('hrsh7th/nvim-cmp')
call minpac#add('hrsh7th/cmp-vsnip')
call minpac#add('hrsh7th/vim-vsnip')

" GitHub Copilot
call minpac#add('github/copilot.vim')
" copilot のプラグインを切り替えることを検討中
" call minpac#add('zbirenbaum/copilot.lua')
call minpac#add('nvim-lua/plenary.nvim')
call minpac#add('CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' })
let g:copilot_filetypes = {'markdown': v:true,'yaml': v:true, 'vlang': v:true}


set completeopt=menu,menuone,noselect

" lua settings
lua <<EOF
  vim.notify = require("notify")

  -- Set todo-comments
  require("CopilotChat").setup {
	  debug = true,
  }

  -- Set lualine
  require('lualine').setup()

  -- Set neogit
  require("neogit").setup()

  -- Set gitsigns
  require("gitsigns").setup()

  -- Set todo-comments
  require("todo-comments").setup()

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      { name = 'emoji' },
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
      }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require('lspconfig')['vimls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['gopls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['rust_analyzer'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['v_analyzer'].setup {
    capabilities = capabilities
  }

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
	function (server_name)
		require("lspconfig")[server_name].setup {
			on_attach = on_attach
		}
	end,
}

-- バッファ保存時に goimports を実行する
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  end
})
EOF

" key map
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>zf :lua require('telekasten').find_notes()<CR>
nnoremap <leader>zd :lua require('telekasten').find_daily_notes()<CR>
nnoremap <leader>zg :lua require('telekasten').search_notes()<CR>
nnoremap <leader>zz :lua require('telekasten').follow_link()<CR>

" WSL での動作する
if has('wsl')
  augroup myYank
	let g:clipboard = {
	            \   'name': 'WslClipboard',
	            \   'copy': {
	            \      '+': 'win32yank.exe -i',
	            \      '*': 'win32yank.exe -i',
	            \    },
	            \   'paste': {
	            \      '+': 'win32yank.exe -o',
	            \      '*': 'win32yank.exe -o',
	            \   },
	            \   'cache_enabled': 1,
	            \ }
	let g:mkdp_browser='wsl-open'

  call minpac#add('wakatime/vim-wakatime')
endif

