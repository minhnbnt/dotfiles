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
	updatetime = 3000,

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

vim.cmd([[
    vnoremap <BS>                               <DEL>
    vnoremap <RightMouse>                       <C-\><C-g>gv<cmd>:popup! PopUp<cr>
	tnoremap <esc>                              <C-\><C-N>

    aunmenu PopUp
    nnoremenu <silent> PopUp.NvimTree           :NvimTreeToggle <cr>
    nnoremenu <silent> PopUp.Open\ File         :Telescope file_browser hidden=true grouped=true<cr>
    nnoremenu <silent> PopUp.Format\ code       :lua vim.lsp.buf.format()<cr>
	nnoremenu <silent> PopUp.Find\ File         :Telescope find_files hidden=true<cr>
    nnoremenu <silent> PopUp.Toggle\ DAP\ UI    :DapUi toggle<cr>
    vnoremenu PopUp.Cut                         "+x
    vnoremenu PopUp.Copy                        "+ygv
    anoremenu PopUp.Paste                       "+gP
    vnoremenu PopUp.Paste                       "+P
    vnoremenu PopUp.Delete                      "_x
    nnoremenu PopUp.Select\ all                 gg0vG$
    vnoremenu PopUp.Select\ all                 gg0oG$
    inoremenu PopUp.Select\ all                 <C-Home><C-O>vG$
    nnoremenu PopUp.Find                        /
]])
