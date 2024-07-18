return {

	{ import = "plugins.ui" },

	{ "nvim-tree/nvim-web-devicons", lazy = true },

	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},

	{
		"lewis6991/gitsigns.nvim",
		version = "*",
		event = { "BufReadPost", "BufNewFile" },

		opts = {
			signs = { untracked = { text = "╏" } },
			preview_config = { border = "rounded" },
		},
	},
}
