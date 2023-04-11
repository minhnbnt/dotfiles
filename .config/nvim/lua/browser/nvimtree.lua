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

-- nvim-tree is also there in modified buffers so this function filter it out
local modifiedBufs = function(bufs)
	local t = 0
	for k, v in pairs(bufs) do
		if v.name:match("NvimTree_") == nil then
			t = t + 1
		end
	end
	return t
end

vim.api.nvim_create_autocmd("BufEnter", {
	command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
	nested = true,
})

vim.api.nvim_create_autocmd("BufEnter", {
	nested = true,
	callback = function()
		if
			#vim.api.nvim_list_wins() == 1
			and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
			and modifiedBufs(vim.fn.getbufinfo({ bufmodified = 1 })) == 0
		then
			vim.cmd("quit")
		end
	end,
})
