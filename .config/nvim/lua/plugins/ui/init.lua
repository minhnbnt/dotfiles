local function load(module)
	return function()
		require("plugins.ui." .. module)
	end
end

return {

	{ "nvim-tree/nvim-web-devicons" },

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = { untracked = { text = "╏" } },
			preview_config = { border = "rounded" },
		},
	},

	{ "rcarriga/nvim-notify", config = load("notify") },

	{ "nvim-lualine/lualine.nvim", config = load("lualine") },

	{ "luukvbaal/statuscol.nvim", config = load("statuscol") },

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

		version = "*",
		config = load("bufferline"),
	},
}
