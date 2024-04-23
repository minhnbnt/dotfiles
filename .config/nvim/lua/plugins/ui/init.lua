return {

	{ import = "plugins.ui.bufferline" },
	{ import = "plugins.ui.lualine" },
	{ import = "plugins.ui.noice" },
	{ import = "plugins.ui.notify" },
	{ import = "plugins.ui.statuscol" },

	{ "nvim-tree/nvim-web-devicons", lazy = true },

	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },

		opts = {
			signs = { untracked = { text = "╏" } },
			preview_config = { border = "rounded" },
		},
	},
}
