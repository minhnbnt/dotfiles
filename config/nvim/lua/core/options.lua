vim.g.input_method = ""

local neovide = {
	neovide_transparency = 0.85,
	--neovide_padding_top = 35,
	--neovide_padding_left = 28,
	--neovide_padding_right = 28,
	--neovide_padding_bottom = 10,
}

local options = {

	-- clipboard = "unnamedplus",

	showmode = false,
	number = true,
	relativenumber = true,
	numberwidth = 1,
	autoindent = true,
	tabstop = 2,
	shiftwidth = 2,
	softtabstop = 2,
	mouse = "a",
	title = true,
	undofile = true,
	completeopt = { "menuone", "noselect" },
	pumheight = 15,
	updatetime = 3000,

	wrap = true,
	linebreak = true,
	--showbreak = "⤹",
	cmdheight = 0,

	termguicolors = true,
	guifont = "FiraCode Nerd Font Mono:h10.5",
	confirm = true,
	autochdir = true,
	ttyfast = true,
	--lazyredraw = true,
	cursorline = true,
	mousemoveevent = true,
	background = "dark",

	fillchars = {
		foldopen = "-",
		foldsep = "┆",
		foldclose = "+",
	},
}

for k, v in vim.iter(options) do
	vim.opt[k] = v
end

if vim.g.neovide then
	for k, v in pairs(neovide) do
		vim.g[k] = v
	end
end
