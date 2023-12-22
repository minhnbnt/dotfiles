local Plug = require("core.functions").plugin

local function open_file_browser()
	local current_dir = vim.fn.expand("%:p")
	local stat = vim.loop.fs_stat(current_dir)

	if stat and stat.type == "directory" then
		vim.api.nvim_buf_delete(0, { force = true })
		vim.cmd(":Telescope file_browser hidden=true grouped=true")
	end
end

return {

	Plug("nvim-tree/nvim-tree.lua", {

		version = "*",
		lazy = false,

		opts = {
			sort_by = "case_sensitive",
			update_focused_file = {
				enable = true,
				update_cwd = true,
			},
			view = {
				width = 30,
				side = "left",
			},
			hijack_directories = {
				enable = false,
			},
			respect_buf_cwd = true,
			update_cwd = true,
			hijack_cursor = false,
			sync_root_with_cwd = true,
		},

		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			vim.api.nvim_create_autocmd({ "QuitPre" }, {
				callback = function()
					vim.cmd("NvimTreeClose")
				end,
			})
		end,
	}),

	Plug("nvim-telescope/telescope.nvim", {

		branch = "0.1.x",

		dependencies = {

			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",

			{
				"ahmedkhalf/project.nvim",
				main = "project_nvim",
				opts = {},
			},

			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && "
					.. "cmake --build build --config Release && "
					.. "cmake --install build --prefix build",
			},
		},

		init = function()
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = open_file_browser,
			})

			require("telescope").load_extension("file_browser", "fzy_native", "projects")
		end,

		opts = {
			defaults = {
				-- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			},
		},
	}),
}
