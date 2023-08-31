vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.input_method = "ibus"
--vim.g.input_method = "fcitx5"

-- Disable copilot ghost text
vim.g.copilot_enabled = false

local neovide = {
	neovide_transparency = 0.85,
	--neovide_padding_top = 35,
	--neovide_padding_left = 28,
	--neovide_padding_right = 28,
	--neovide_padding_bottom = 10,
}

local options = {

	--clipboard = "unnamedplus",

	showmode = false,
	number = true,
	relativenumber = true,
	numberwidth = 4,
	autoindent = true,
	tabstop = 2,
	shiftwidth = 2,
	smarttab = true,
	softtabstop = 2,
	expandtab = false,
	mouse = "a",
	title = true,
	undofile = true,
	completeopt = { "menuone", "noselect" },
	pumheight = 15,
	--updatetime = 3000,

	wrap = true,
	linebreak = true,
	--showbreak = "⤹",
	cmdheight = 0,

	guifont = "FiraCode Nerd Font Mono:h10.5",
	confirm = true,
	autochdir = true,
	ttyfast = true,
	--lazyredraw = true,
	cursorline = true,
	mousemoveevent = true,
	background = "dark",
}

vim.g.cursorhold_updatetime = 1000

for k, v in pairs(options) do
	vim.opt[k] = v
end

if vim.g.neovide then
	for k, v in pairs(neovide) do
		vim.g[k] = v
	end
end
