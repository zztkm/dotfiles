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

-- Swift 向けの LSP を設定
nvim_lsp.sourcekit.setup{
	cmd = {
		'sourcekit-lsp',
		'-Xswiftc',
		'-sdk',
		'-Xswiftc',
		-- '`xcrun --sdk iphonesimulator --show-sdk-path`',
		'/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator17.5.sdk',
		'-Xswiftc',
		'-target',
		'-Xswiftc',
		-- 'x86_64-apple-ios`xcrun --sdk iphonesimulator --show-sdk-platform-version`-simulator',
		'x86_64-apple-ios17.5-simulator',
	},
}

-- for typescript
nvim_lsp.tsserver.setup {
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" }
}

-- for Biome
nvim_lsp.biome.setup{}

