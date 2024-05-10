return {

	"folke/which-key.nvim",
	event = "VeryLazy",

	opts = {

		setup = { window = { border = "rounded" } },

		register = {
			["<leader>"] = {
				b = { name = "Buffer" },
				c = { name = "Code" },
				f = { name = "File" },
				g = { name = "Goto" },
				l = { name = "LSP" },
				s = { name = "Saga" },
			},
		},
	},

	config = function(_, opts)
		local wk = require("which-key")

		for prefix, keys in pairs(opts.register) do
			wk.register(keys, { prefix = prefix })
		end

		wk.setup(opts.setup)
	end,
}
