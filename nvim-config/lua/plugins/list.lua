-- lazy.nvim に読み込ませるプラグイン一覧

local plugins = {
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight-moon]])
		end,
	},
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make'
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{ "lambdalisue/fern.vim" },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{},
	{ "TimUntersberger/neogit" },
	{ "bronson/vim-trailing-whitespace" },
	{ "L3MON4D3/LuaSnip" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-emoji" },
	{ "saadparwaiz1/cmp_luasnip" },
	{
		-- この plugin で利用する gopls は mason でインストールしない
		"ray-x/go.nvim",
		dependencies = {  -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = {"CmdlineEnter"},
		ft = {"go", 'gomod'},
		build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
  				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function ()
			require("copilot_cmp").setup()
		end
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
		},
	},
}

return plugins
