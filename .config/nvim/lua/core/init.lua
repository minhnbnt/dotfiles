local function Lazy_init()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	-- stylua: ignore
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({	"git", "clone", "--branch=stable", "--filter=blob:none",
		                "git@github.com:folke/lazy.nvim.git", lazypath })
	end

	vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

	require("lazy").setup({

		concurrency = 10,

		spec = {
			{ import = "plugins" },
		},

		git = { timeout = 300 },
		ui = { border = "rounded" },
	})
end

require("core.options")
require("core.autocmd")
require("core.keymaps")

Lazy_init()
