return {

	{ import = "plugins.lsp" },

	{
		"ray-x/lsp_signature.nvim",
		event = { "BufReadPost", "BufNewFile" },

		opts = {
			bind = true,
			close_timeout = 500,
			max_height = 15,
			max_width = 80,
			always_trigger = true,
			handler_opts = { border = "rounded" },
			hint_prefix = " ",
		},
	},
}
