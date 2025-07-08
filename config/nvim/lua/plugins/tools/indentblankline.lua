return {

	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",

	opts = function()
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

		return {

			indent = { char = "│" },
			scope = {
				highlight = { "CurrScope" },
				enabled = true,
				show_start = false,
				show_end = false,
			},
		}
	end,
}
