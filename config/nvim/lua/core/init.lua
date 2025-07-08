local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyrepo = "https://github.com/folke/lazy.nvim.git"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--branch=stable",
		"--filter=blob:none",
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})

		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

if vim.loader then
	vim.loader.enable()
end

require("core.options")
require("core.autocmd")
require("core.keymaps")

require("lazy").setup({

	spec = {
		{ import = "plugins" },
	},

	concurrency = 10,

	git = {
		timeout = 500,
	},

	checker = {
		enabled = true,
		notify = false,
	},

	ui = { border = "rounded" },

	change_detection = { notify = false },
})
