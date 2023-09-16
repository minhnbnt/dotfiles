local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- stylua: ignore
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({	"git", "clone", "--branch=stable", "--filter=blob:none",
	                "git@github.com:folke/lazy.nvim.git", lazypath })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({

	spec = {
		{ import = "plugins" },
	},

	defaults = {

		lazy = false,
		version = false,
	},
})
