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

" WSL での動作する
if system('uname -a | grep microsoft') != ''
  augroup myYank
	let g:clipboard = {
	            \   'name': 'WslClipboard',
	            \   'copy': {
	            \      '+': 'clip.exe',
	            \      '*': 'clip.exe',
	            \    },
	            \   'paste': {
	            \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	            \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	            \   },
	            \   'cache_enabled': 0,
	            \ }
endif

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

" for telekasten.nvim
call minpac#add('nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' })
call minpac#add('nvim-telescope/telescope.nvim')
call minpac#add('renerocksai/calendar-vim')
call minpac#add('renerocksai/telekasten.nvim')
" telescope settings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


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

set completeopt=menu,menuone,noselect

" lua settings
lua <<EOF
  vim.notify = require("notify")
  require("mason").setup()
  require("mason-lspconfig").setup()

  -- Set lualine
  require('lualine').setup()

  -- Set neogit
  require("neogit").setup()

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
  require('lspconfig')['vls'].setup {
    capabilities = capabilities
  }

	-- telekasten config
local home = vim.fn.expand("~/minecraft")
require('telekasten').setup({
    home = home,

    -- if true, telekasten will be enabled when opening a note within the configured home
    take_over_my_home = true,

    -- auto-set telekasten filetype: if false, the telekasten filetype will not be used
    --                               and thus the telekasten syntax will not be loaded either
    auto_set_filetype = true,

    -- dir names for special notes (absolute path or subdir name)
    dailies      = home .. '/' .. 'daily',
    weeklies     = home .. '/' .. 'weekly',
    templates    = home .. '/' .. 'templates',

    -- image (sub)dir for pasting
    -- dir name (absolute path or subdir name)
    -- or nil if pasted images shouldn't go into a special subdir
    image_subdir = "img",

    -- markdown file extension
    extension    = ".md",

    -- Generate note filenames. One of:
    -- "title" (default) - Use title if supplied, uuid otherwise
    -- "uuid" - Use uuid
    -- "uuid-title" - Prefix title by uuid
    -- "title-uuid" - Suffix title with uuid
    new_note_filename = "title",

    --[[ file UUID type
        - "rand"
        - string input for os.date()
        - or custom lua function that returns a string
    --]]
    uuid_type = "%Y%m%d%H%M",
    -- UUID separator
    uuid_sep = "-",

    -- if not nil, this string replaces spaces in the title when generating filenames
    filename_space_subst = nil,

    -- following a link to a non-existing note will create it
    follow_creates_nonexisting = true,
    dailies_create_nonexisting = true,
    weeklies_create_nonexisting = true,

    -- skip telescope prompt for goto_today and goto_thisweek
    journal_auto_open = false,

    -- template for new notes (new_note, follow_link)
    -- set to `nil` or do not specify if you do not want a template
    template_new_note = home .. '/' .. 'templates/new_note.md',

    -- template for newly created daily notes (goto_today)
    -- set to `nil` or do not specify if you do not want a template
    template_new_daily = home .. '/' .. 'templates/daily.md',

    -- template for newly created weekly notes (goto_thisweek)
    -- set to `nil` or do not specify if you do not want a template
    template_new_weekly= home .. '/' .. 'templates/weekly.md',

    -- image link style
    -- wiki:     ![[image name]]
    -- markdown: ![](image_subdir/xxxxx.png)
    image_link_style = "markdown",

    -- default sort option: 'filename', 'modified'
    sort = "filename",

    -- integrate with calendar-vim
    plug_into_calendar = true,
    calendar_opts = {
        -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
        weeknm = 4,
        -- use monday as first day of week: 1 .. true, 0 .. false
        calendar_monday = 1,
        -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
        calendar_mark = 'left-fit',
    },

    -- telescope actions behavior
    close_after_yanking = false,
    insert_after_inserting = true,

    -- tag notation: '#tag', ':tag:', 'yaml-bare'
    tag_notation = "yaml-bare",

    -- command palette theme: dropdown (window) or ivy (bottom panel)
    command_palette_theme = "ivy",

    -- tag list theme:
    -- get_cursor: small tag list at cursor; ivy and dropdown like above
    show_tags_theme = "ivy",

    -- when linking to a note in subdir/, create a [[subdir/title]] link
    -- instead of a [[title only]] link
    subdirs_in_links = true,

    -- template_handling
    -- What to do when creating a new note via `new_note()` or `follow_link()`
    -- to a non-existing note
    -- - prefer_new_note: use `new_note` template
    -- - smart: if day or week is detected in title, use daily / weekly templates (default)
    -- - always_ask: always ask before creating a note
    template_handling = "smart",

    -- path handling:
    --   this applies to:
    --     - new_note()
    --     - new_templated_note()
    --     - follow_link() to non-existing note
    --
    --   it does NOT apply to:
    --     - goto_today()
    --     - goto_thisweek()
    --
    --   Valid options:
    --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
    --              all other ones in home, except for notes/with/subdirs/in/title.
    --              (default)
    --
    --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
    --                    except for notes with subdirs/in/title.
    --
    --     - same_as_current: put all new notes in the dir of the current note if
    --                        present or else in home
    --                        except for notes/with/subdirs/in/title.
    new_note_location = "smart",

    -- should all links be updated when a file is renamed
    rename_update_links = true,

    vaults = {
        vault2 = {
            -- alternate configuration for vault2 here. Missing values are defaulted to
            -- default values from telekasten.
            -- e.g.
            -- home = "~/vaults/personal",
        },
    },

    -- how to preview media files
    -- "telescope-media-files" if you have telescope-media-files.nvim installed
    -- "catimg-previewer" if you have catimg installed
    media_previewer = "telescope-media-files",

    -- A customizable fallback handler for urls.
    follow_url_fallback = nil,
})
EOF

