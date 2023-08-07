vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
--vim.g.input_method = "ibus"
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

vim.api.nvim_create_autocmd({ "BufEnter", "WinResized" }, {
	callback = function()
		local excluded_ft = { "python" }
		local ft = { "html", "xhtml", "xml", "typescriptreact", "javascriptreact" }
		vim.cmd("se tabstop=4 shiftwidth=4 softtabstop=4")
		if vim.fn.winwidth(0) < 100 or vim.tbl_contains(ft, vim.bo.filetype) then
			vim.cmd("se tabstop=2 shiftwidth=2 softtabstop=2")
		end
		if vim.tbl_contains(excluded_ft, vim.bo.filetype) then
			vim.cmd("se tabstop=4 shiftwidth=4 softtabstop=4")
		end
		local ok, ident = pcall(require, "indent_blankline")
		if ok then
			ident.refresh()
		end
	end,
})

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

keymap("v", "<BS>", "<Del>", opts)
keymap("v", "<C-S-c>", '"+ygv', { noremap = true })
keymap("v", "<RightMouse>", "<C-><C-g>gv<cmd>:popu! PopUp<cr>", opts)
keymap("t", "<esc>", "<C-\\><C-n>", term_opts)

-- Undo, Redo
--keymap("", "<C-z>", ":undo<CR>", opts)
keymap("", "<C-y>", ":redo<CR>", opts)

-- Save
keymap("", "<C-s>", ":w<CR>", opts)

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

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

local IMOff, IMOn = function() end, function() end

if vim.g.input_method == "ibus" and io.open("/usr/bin/ibus", "r") ~= nil then
	IMOff = function()
		vim.g.im_prev_engine = io.popen("ibus engine", "r"):read("*all")
		os.execute("ibus engine BambooUs")
	end
	IMOn = function()
		os.execute("ibus engine " .. vim.g.im_prev_engine)
		local current_engine = io.popen("ibus engine", "r"):read("*all")
		if current_engine ~= "BambooUs" then
			vim.g.im_prev_engine = current_engine
		end
	end
end

if vim.g.input_method == "fcitx5" and io.open("/usr/bin/fcitx5", "r") ~= nil then
	IMOff = function()
		vim.g.im_prev_engine = io.popen("fcitx5-remote -n", "r"):read("*all")
		os.execute("fcitx5-remote -g keyboard-us")
	end
	IMOn = function()
		os.execute("fcitx5-remote -g " .. vim.g.im_prev_engine)
		local current_engine = io.popen("fcitx5-remote -n", "r"):read("*all")
		if current_engine ~= "keyboard-us" then
			vim.g.im_prev_engine = current_engine
		end
	end
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
	pattern = { "/", "?" },
	callback = IMOn,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	pattern = { "/", "?" },
	callback = IMOff,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "VimLeave" }, {
	callback = IMOn,
})
vim.api.nvim_create_autocmd({ "InsertLeave", "VimEnter" }, {
	callback = IMOff,
})

for k, v in pairs(options) do
	vim.opt[k] = v
end

if vim.g.neovide then
	for k, v in pairs(neovide) do
		vim.g[k] = v
	end
end
