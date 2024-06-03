return {

	"nvimdev/lspsaga.nvim",
	event = { "BufReadPost", "BufNewFile" },

	keys = {
		{ "<leader>gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto Definition" },
		{ "<leader>gt", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto Type Definition" },

		{ "<leader>sr", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },
	},

	opts = {
		symbol_in_winbar = { enable = false },
		lightbulb = { enable = false },
		rename = {
			in_select = false,
			keys = { quit = "<esc>" },
		},
	},
}
