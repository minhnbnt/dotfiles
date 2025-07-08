-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("v", "<leader>y", '"+y', {
	noremap = true,
	silent = true,
	desc = "Yank to clipboard",
})

keymap("n", "<leader>p", '"+p', {
	noremap = true,
	silent = true,
	desc = "Paste from clipboard",
})

keymap("v", "<BS>", "<Del>", opts)
keymap("v", "<C-S-c>", '"+ygv', { noremap = true })
keymap("t", "<esc>", "<C-\\><C-n>", term_opts)

-- Undo, Redo
--keymap("", "<C-z>", ":undo<CR>", opts)
keymap("", "<C-y>", "<cmd>:redo<CR>", opts)

-- Save
keymap("", "<C-s>", "<cmd>:w<CR>", opts)

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
