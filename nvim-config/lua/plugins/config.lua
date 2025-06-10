-- 参考: https://zenn.dev/nazo6/articles/c2f16b07798bab
-- LSPサーバアタッチ時の処理
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(ctx)
-- 		-- note: open_float は <C-W>d がデフォルトでマッピングされているのでそれを使う
-- 		local set = vim.keymap.set
-- 		set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
-- 		set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
-- 		set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
-- 		set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
-- 		set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
-- 		set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
-- 		set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
-- 		set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { buffer = true })
-- 		set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
-- 		set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
-- 		set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
-- 		set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
-- 		set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { buffer = true })
-- 		set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { buffer = true })
-- 	end,
-- })

-- プラグインの設定
require("mason").setup()
require("mason-lspconfig").setup()

-- lspのハンドラーに設定
capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- lspの設定後に追加
vim.opt.completeopt = "menu,menuone,noselect"

local cmp = require"cmp"
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
		--{ name = "copilot" },
		{ name = "nvim_lsp" },
	}, {
		{ name = "buffer" },
		{ name = "emoji" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = 'buffer' },
	})
})


-- CopilotChat の設定
-- local chat = require("CopilotChat")
-- chat.setup({
-- 	window = {
-- 		layout = "float",
-- 		relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
-- 		border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
-- 		width = 0.8, -- fractional width of parent
-- 		height = 0.6, -- fractional height of parent
-- 		row = nil, -- row position of the window, default is centered
-- 		col = nil, -- column position of the window, default is centered
-- 		title = 'Copilot Chat', -- title of chat window
-- 		footer = nil, -- footer of chat window
-- 		zindex = 1, -- determines if window is on top or below other floating windows
-- 	},
-- })


-- scnvim (SuperCollider 用設定)
-- local scnvim = require "scnvim"
-- local map = scnvim.map
-- local map_expr = scnvim.map_expr
-- scnvim.setup({
--   sclang = {
--     cmd = 'C:/Program Files/SuperCollider-3.13.0/sclang.exe'
--   },
--   keymaps = {
--     ['<M-e>'] = map('editor.send_line', {'i', 'n'}),
--     ['<C-e>'] = {
--       map('editor.send_block', {'i', 'n'}),
--       map('editor.send_selection', 'x'),
--     },
--     ['<CR>'] = map('postwin.toggle'),
--     ['<M-CR>'] = map('postwin.toggle', 'i'),
--     ['<M-L>'] = map('postwin.clear', {'n', 'i'}),
--     ['<C-k>'] = map('signature.show', {'n', 'i'}),
--     ['<F12>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
--     ['<leader>st'] = map('sclang.start'),
--     ['<leader>sk'] = map('sclang.recompile'),
--     ['<F1>'] = map_expr('s.boot'),
--     ['<F2>'] = map_expr('s.meter'),
--   },
--   editor = {
--     highlight = {
--       color = 'IncSearch',
--     },
--   },
--   postwin = {
--     float = {
--       enabled = true,
--     },
--   },
-- })

