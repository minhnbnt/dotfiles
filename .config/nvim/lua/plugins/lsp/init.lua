local function load(module)
	return function()
		require("plugins.lsp." .. module)
	end
end

return {

	{
		"nvimdev/lspsaga.nvim",
		event = { "BufReadPost", "BufNewFile" },

		keys = {

			{ "<leader>gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto Definition" },
			{ "<leader>gt", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto Type Definition" },

			{ "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },
		},

		opts = {
			symbol_in_winbar = { enable = false },
			lightbulb = { enable = false },
			rename = {
				in_select = false,
				keys = { quit = "<esc>" },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },

		dependencies = {
			"p00f/clangd_extensions.nvim",
			"mfussenegger/nvim-jdtls",
			"ranjithshegde/ccls.nvim",
		},

		config = load("config"),
	},

	{
		"mrcjkb/rustaceanvim",
		version = "*",
		ft = { "rust" },
	},

	{
		"ray-x/lsp_signature.nvim",
		enabled = true,

		opts = {
			bind = true,
			max_height = 15,
			max_width = 80,
			always_trigger = true,
			handler_opts = { border = "rounded" },
			hint_prefix = " ",
		},
	},

	{
		"L3MON4D3/LuaSnip",
		lazy = true,

		dependencies = {
			"rafamadriz/friendly-snippets",
			"honza/vim-snippets",
		},

		version = "*",
		build = "make install_jsregexp",
		config = load("luasnip"),
	},

	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPost", "BufNewFile" },

		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},

		config = load("null-ls"),
	},

	{
		"zbirenbaum/copilot.lua",
		enabled = false,

		cmd = "Copilot",
		event = "InsertEnter",

		dependencies = { "zbirenbaum/copilot-cmp" },
		config = load("copilot"),
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },

		config = load("cmp"),

		dependencies = {
			--"onsails/lspkind.nvim",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"octaltree/cmp-look",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			--"hrsh7th/cmp-calc",
			--"f3fora/cmp-spell",
			--"hrsh7th/cmp-emoji",
			"saadparwaiz1/cmp_luasnip",
			"quangnguyen30192/cmp-nvim-tags",
			"ray-x/cmp-treesitter",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			--"hrsh7th/cmp-omni",
			--"hrsh7th/cmp-nvim-lsp-signature-help",
			--"hrsh7th/cmp-copilot",
			--"tzachar/cmp-ai",
			--[[ {
				"tzachar/cmp-tabnine",
				build = "./install.sh",
			}, ]]
			--"SirVer/ultisnips",
			--"quangnguyen30192/cmp-nvim-ultisnips",
			--"dcampos/nvim-snippy",
			--"dcampos/cmp-snippy",
		},
	},
}
