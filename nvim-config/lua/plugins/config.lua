-- LspAttach キーマップ（LSP がバッファにアタッチされた時に設定）
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		local set = vim.keymap.set
		set("n", "gD", vim.lsp.buf.declaration, { buffer = true })
		set("n", "gd", vim.lsp.buf.definition, { buffer = true })
		set("n", "K", vim.lsp.buf.hover, { buffer = true })
		set("n", "gi", vim.lsp.buf.implementation, { buffer = true })
		set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = true })
		set("n", "<space>D", vim.lsp.buf.type_definition, { buffer = true })
		set("n", "<space>rn", vim.lsp.buf.rename, { buffer = true })
		set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = true })
		set("n", "gr", vim.lsp.buf.references, { buffer = true })
	end,
})

return {
	-- fzf
	{ "junegunn/fzf" },
	{ "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },

	-- misc
	{ "bronson/vim-trailing-whitespace" },

	-- LSP インフラ
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim", config = true },
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = true,
	},

	-- 補完
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-emoji",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			vim.opt.completeopt = "menu,menuone,noselect"
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}, {
					{ name = "buffer" },
					{ name = "emoji" },
				}),
			})
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
		end,
	},

	-- Flutter / Dart LSP（dartls は lspconfig で設定しないこと）
	{
		"zztkm/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = true,
	},
}

