-- Neovim 設定のエントリポイント


-- module を利用するには lua ディレクトリに lua/hoge.lua のようにファイルを作成して
-- require("hoge") のように読み込みます

require("options")
require("plugins/lazy")
require("keymaps")
require("autocmds")

