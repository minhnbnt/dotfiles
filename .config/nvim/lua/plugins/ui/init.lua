local Plug = require("core.functions").plugin

local function load(module)
	return function()
		require("plugins.ui." .. module)
	end
end

return {

	{ "nvim-tree/nvim-web-devicons" },

	Plug("lewis6991/gitsigns.nvim", {

		opts = {
			signs = { untracked = { text = "╏" } },
			preview_config = { border = "rounded" },
		},
	}),

	Plug("folke/which-key.nvim", {

		event = "VeryLazy",

		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,

		opts = {
			window = { border = "rounded" },
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "-", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
			},
		},
	}),

	Plug("rcarriga/nvim-notify", { config = load("notify") }),

	Plug("nvim-lualine/lualine.nvim", { config = load("lualine") }),

	Plug("luukvbaal/statuscol.nvim", { config = load("statuscol") }),

	Plug("folke/noice.nvim", {

		version = "*",
		event = "VeryLazy",

		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},

		config = load("noice"),
	}),

	Plug("akinsho/bufferline.nvim", {

		version = "*",
		config = load("bufferline"),
	}),
}
