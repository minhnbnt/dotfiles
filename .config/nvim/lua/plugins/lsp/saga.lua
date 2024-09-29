return {

	"nvimdev/lspsaga.nvim",
	event = { "BufReadPost", "BufNewFile" },

	keys = {
		{ "<leader>gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto Definition" },
		{ "<leader>gt", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto Type Definition" },

		{ "<leader>sr", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },
		{ "<leader>sc", "<cmd>Lspsaga code_action<cr>", desc = "LSP Code Action" },
	},

	opts = {
		symbol_in_winbar = { enable = false },
		lightbulb = { enable = false },
		code_action = {
			show_server_name = true,
			keys = { quit = "<esc>" },
		},
		rename = {
			in_select = false,
			keys = { quit = "<esc>" },
		},
	},
}
