-- Do not source the default filetype.vim
vim.g.did_load_filetypes = 1

-- In init.lua or filetype.nvim's config file
require("filetype").setup({
	overrides = {
		extensions = {
			-- Set the filetype of *.pn files to potion
			--pn = "potion",
		},
	},
})
