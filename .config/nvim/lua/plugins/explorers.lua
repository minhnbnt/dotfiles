return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		enabled = true,

		dependencies = {

			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",

			{
				"ahmedkhalf/project.nvim",
				config = function()
					require("project_nvim").setup()
				end,
			},

			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && "
					.. "cmake --build build --config Release && "
					.. "cmake --install build --prefix build",
			},
		},

		init = function()
			require("telescope").load_extension("file_browser", "projects")
		end,

		opts = {
			defaults = {
				-- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			},
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		enabled = true,

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
			respect_buf_cwd = true,
			update_cwd = true,
			hijack_cursor = false,
			sync_root_with_cwd = true,
		},

		init = function()
			vim.api.nvim_create_autocmd({ "QuitPre" }, {
				callback = function()
					vim.cmd("NvimTreeClose")
				end,
			})
		end,
	},
}
