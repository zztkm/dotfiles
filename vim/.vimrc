" 基本設定
set number
set ruler
set nocursorline
set showcmd
set showmatch
set laststatus=2
set cmdheight=2
set wildmenu
set wildmode=list:longest,full
set title
set guifont=Cica

" インデント設定
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" 検索設定
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan

" エンコーディング
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,sjis
set fileformats=unix,dos,mac

" 日本語入力設定
set ambiwidth=double  " 全角文字の幅を2に固定
set formatoptions+=mM " 日本語の行の連結時に空白を入力しない
set display+=lastline " 長い行も表示
set wrap              " 行を折り返す
set linebreak        " 単語の途中で改行しない

" IME設定
if has('multi_byte_ime') || has('xim')
  " 挿入モード終了時にIMEをオフ
  set iminsert=0
  set imsearch=0
  " 挿入モードでのデフォルトのIME状態
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

" その他
set clipboard=unnamedplus
set backspace=indent,eol,start
set hidden
set noswapfile
set nobackup
set noundofile
set mouse=a
set scrolloff=5
set nofixeol
set termguicolors

" キーマッピング
" let mapleader = " "
" nnoremap <leader>w :w<CR>
" nnoremap <leader>q :q<CR>
" nnoremap <leader>h :nohl<CR>

" 見た目
syntax enable
filetype plugin indent on

" WSL yank support
if has('wsl')
    let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
    if executable(s:clip)
        augroup WSLYank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
        augroup END
    endif
endif

" Normally this if-block is not needed, because `:set nocp` is done
" automatically when .vimrc is found. However, this might be useful
" when you execute `vim -u .vimrc` from the command line.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})
" これはエラーになっちゃった、option らしいのでコメントアウトで対応する
" call minpac#add('junegunn/fzf', { 'do': { -> fzf#install() } })
call minpac#add('junegunn/fzf.vim')

" Load the plugins right now. (optional)
"packloadall

" keymaps for fzf
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>

