local function load(module)
	return function()
		require("plugins.ui." .. module)
	end
end

return {

	{ "nvim-tree/nvim-web-devicons" },

	{
		"rcarriga/nvim-notify",
		enabled = true,
		config = load("notify"),
	},

	{
		"folke/noice.nvim",
		version = "*",
		event = "VeryLazy",
		enabled = true,

		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = load("noice"),
	},

	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		config = load("lualine"),
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		enabled = true,
		config = load("bufferline"),
	},

	{
		"luukvbaal/statuscol.nvim",
		enabled = true,
		config = load("statuscol"),
	},

	{
		"lewis6991/gitsigns.nvim",
		enabled = true,
		opts = {},
	},
}
