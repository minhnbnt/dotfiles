return {

	"folke/which-key.nvim",
	event = "VeryLazy",

	keys = {

		{ "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
		{ "<leader>bb", "<cmd>bprevious<cr>", desc = "Backward Buffer" },
	},

	opts = {
		window = { border = "rounded" },
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "-", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
	},

	init = function()
		require("which-key").register({
			b = { name = "Buffer" },
			c = { name = "Code" },
			f = { name = "File" },
			g = { name = "Goto" },
			l = { name = "LSP" },
		}, { prefix = "<leader>" })
	end,
}
