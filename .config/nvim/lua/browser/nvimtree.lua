require("nvim-tree").setup({
	sort_by = "case_sensitive",
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	view = {
		width = 30,
		side = "left",
	},
	respect_buf_cwd = true,
	update_cwd = true,
	hijack_cursor = false,
	sync_root_with_cwd = true,
	renderer = {
		root_folder_modifier = ":t",
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	filters = {
		dotfiles = false,
	},
})

vim.api.nvim_create_autocmd("BufEnter", {
	command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
	nested = true,
})

vim.api.nvim_create_autocmd({ "QuitPre" }, {
	callback = function()
		vim.cmd("NvimTreeClose")
	end,
})
