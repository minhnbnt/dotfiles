return {
	"folke/which-key.nvim",
	event = "VeryLazy",

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
			f = { name = "File" },
			c = { name = "Code" },
		}, { prefix = "<leader>" })
	end,
}
