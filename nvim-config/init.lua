-- Neovim 設定のエントリポイント

-- minpac のブートストラップ
local function ensure_minpac()
  local minpac_path = vim.fn.stdpath('data')..'/site/pack/minpac/opt/minpac'
  if vim.fn.empty(vim.fn.glob(minpac_path)) > 0 then
    vim.fn.system({'git', 'clone', 'https://github.com/k-takata/minpac.git', minpac_path})
    vim.cmd [[packadd minpac]]
  else
    vim.cmd [[packadd minpac]]
  end
end

-- minpac を確実にロード
ensure_minpac()

-- minpac の初期化とプラグイン設定
vim.cmd [[
  function! PackInit() abort
    packadd minpac
    
    call minpac#init()
    call minpac#add('k-takata/minpac', {'type': 'opt'})
    
    " プラグイン追加
    call minpac#add('junegunn/fzf')
    call minpac#add('junegunn/fzf.vim')
  endfunction
  
  " 独自コマンドを定義
  command! PackUpdate call PackInit() | call minpac#update()
  command! PackClean  call PackInit() | call minpac#clean()
  command! PackStatus packadd minpac | call minpac#status()
]]

-- module を利用するには lua ディレクトリに lua/hoge.lua のようにファイルを作成して
-- require("hoge") のように読み込みます

require("options")
-- require("plugins/lazy")
require("keymaps")
-- require("autocmds")

