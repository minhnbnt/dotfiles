return {

	{ import = "plugins.tools" },

	{
		"LunarVim/bigfile.nvim",

		opts = {
			features = {
				"indent_blankline",
				"lsp",
				"treesitter",
				"vimopts",
			},
			pattern = function(bufnr, _)
				local file_contents = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
				local file_length = #file_contents
				return file_length > 5000
			end,
		},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
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
