local Plug = require("core.functions").plugin

local function load(module)
	return function()
		require("plugins.ui." .. module)
	end
end

return {

	{ "nvim-tree/nvim-web-devicons" },

	Plug(
		"lewis6991/gitsigns.nvim",
		{ opts = {
			_extmark_signs = false,
			preview_config = { border = "rounded" },
		} }
	),

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
