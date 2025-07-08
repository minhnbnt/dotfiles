return {

	"echasnovski/mini.comment",
	version = "*",
	event = { "BufReadPost", "BufNewFile" },

	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			opts = { enable_autocmd = false },
		},
	},

	opts = {
		options = {
			custom_commentstring = function()
				local comment_str = require("ts_context_commentstring.internal").calculate_commentstring()
				return comment_str or vim.bo.commentstring
			end,
		},
	},
}
