return {

	{ import = "plugins.lsp.cmp" },
	{ import = "plugins.lsp.copilot" },
	{ import = "plugins.lsp.null-ls" },
	{ import = "plugins.lsp.luasnip" },
	{ import = "plugins.lsp.config" },

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
		"mrcjkb/rustaceanvim",
		version = "*",
		ft = { "rust" },
	},

	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",

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
