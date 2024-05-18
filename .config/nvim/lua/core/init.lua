local function Lazy_init()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	-- stylua: ignore
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		vim.fn.system({	"git", "clone", "--branch=stable", "--filter=blob:none",
		                "git@github.com:folke/lazy.nvim.git", lazypath })
	end

	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup({

		spec = { import = "plugins" },

		concurrency = 10,

		git = {
			timeout = 500,
			url_format = "git@github.com:%s.git",
		},

		ui = { border = "rounded" },

		change_detection = { notify = false },
	})
end

if vim.loader then
	vim.loader.enable()
end

require("core.options")
require("core.autocmd")
require("core.keymaps")

Lazy_init()
