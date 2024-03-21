local function load(module)
	return function()
		require("plugins.ui." .. module)
	end
end

return {

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

	{
		"rcarriga/nvim-notify",
		lazy = true,
		config = load("notify"),
	},

	{
		"nvim-lualine/lualine.nvim",
		config = load("lualine"),
	},

	{
		"luukvbaal/statuscol.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = load("statuscol"),
	},

	{
		"folke/noice.nvim",

		enabled = true,
		version = "*",
		event = "VeryLazy",

		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},

		config = load("noice"),
	},

	{
		"akinsho/bufferline.nvim",
		lazy = false,

		keys = {
			{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Buffer Picker" },
		},

		version = "*",
		config = load("bufferline"),
	},
}
