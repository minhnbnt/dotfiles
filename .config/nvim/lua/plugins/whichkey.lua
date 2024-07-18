return {

	"folke/which-key.nvim",
	event = "VeryLazy",

	opts = {

		setup = {
			win = { border = "rounded" },
			height = { min = 4, max = 10 },
			padding = { 0, 0 },
		},

		keys = {
			{ "<leader>b", group = "Buffer" },
			{ "<leader>c", group = "Code" },
			{ "<leader>f", group = "File" },
			{ "<leader>g", group = "Goto" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>s", group = "Saga" },
		},
	},

	config = function(_, opts)
		local wk = require("which-key")

		wk.setup(opts.setup)
		wk.add(opts.keys)
	end,
}
