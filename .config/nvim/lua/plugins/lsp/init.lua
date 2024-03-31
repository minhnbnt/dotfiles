return {

	{ import = "plugins.lsp.cmp" },
	{ import = "plugins.lsp.copilot" },
	{ import = "plugins.lsp.null-ls" },
	{ import = "plugins.lsp.luasnip" },

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

		config = function()
			require("plugins.lsp.config")
		end,
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
}
