-- Neovim 設定のエントリポイント


-- module を利用するには lua ディレクトリに lua/hoge.lua のようにファイルを作成して
-- require("hoge") のように読み込みます

require("options")
require("plugins/lazy")
require("keymaps")
require("autocmds")

local nvim_lsp = require ("lspconfig")
local configs = require ("lspconfig.configs")
vim.api.nvim_create_autocmd ({ "BufNewFile", "BufRead" }, {
	pattern = { "*.dummygo" },
	callback = function ()
		-- filetype を "dummygo " に 設 定 す る
		vim.bo.filetype = "dummygo"
	end
})

if not configs.mylsp then
	-- 今 回 作 成 し た mylsp を lspconfig に 登 録 す る 。
	configs.mylsp={
		default_config={
			cmd={"mylsp"};
			filetypes={"dummygo"};
			-- root_dir=util.root_pattern(".git");
			init_options={
				command={"mylsp"};
			};
		};
	}
end

nvim_lsp.mylsp.setup{
	capabilities=capabilities,
}

-- for typos
nvim_lsp.typos_lsp.setup({
	init_options = {
		config = "~/.config/nvim/.typos.toml",
	}
})

-- for Swift
-- 参考: https://findy-code.io/engineer-lab/oshi-editor-the-uhooi
nvim_lsp.sourcekit.setup{
	cmd = {
		"sourcekit-lsp",
		"-Xswiftc",
		"-sdk",
		"-Xswiftc",
		"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator18.2.sdk",
		"-Xswiftc",
		"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.2.sdk",
		"-Xswiftc",
		"-target",
		"-Xswiftc",
		"aarch64-apple-ios18.2-simulator",
	}
}

-- for zls
-- zig と zls を PATH に追加しているので特に設定は不要
nvim_lsp.zls.setup {}
