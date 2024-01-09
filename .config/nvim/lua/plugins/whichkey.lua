local M = require("core.functions").create_plug("folke/which-key.nvim")

M.event = "VeryLazy"

M.opts = {
	window = { border = "rounded" },
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "-", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
}

M.init = function()
	local ok, wk = pcall(require, "which-key")

	if not ok then
		return
	end

	wk.register({

		c = {

			name = "Code",

			r = { "<cmd>:RunCode<cr>", "RunCode" },
		},

		f = {

			name = "File",

			b = { "<cmd>:Telescope file_browser hidden=true grouped=true<cr>", "File Browser" },
			f = { "<cmd>:Telescope find_files hidden=true<cr>", "Find File" },
			r = { "<cmd>:Telescope oldfiles<cr>", "Open Recent File" },
			t = { "<cmd>:NvimTreeToggle<cr>", "Toggle File Tree" },
		},
	}, { prefix = "<leader>" })
end

return M
