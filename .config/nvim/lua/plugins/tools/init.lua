return {

	{ import = "plugins.tools" },

	{
		"rest-nvim/rest.nvim",
		enabled = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"antoinemadec/FixCursorHold.nvim",
		enabled = true,
		init = function()
			vim.g.cursorhold_updatetime = 1000
		end,
	},

	{
		"michaelb/sniprun",
		enabled = false,
		event = { "BufReadPost", "BufNewFile" },

		build = "sh ./install.sh",

		opts = { display = { "NvimNotify" } },
	},

	{
		"folke/zen-mode.nvim",

		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle zen-mode" },
		},

		opts = {},
	},

	{
		"razak17/tailwind-fold.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "html", "svelte", "astro", "vue", "javascriptreact", "typescriptreact", "php", "blade" },

		opts = { enabled = false },
	},
}
