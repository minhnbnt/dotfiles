local Plug = require("core.functions").plugin

return {

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
			require("telescope").load_extension("file_browser", "fzy_native", "projects")
		end,

		opts = {
			defaults = {
				-- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			},
		},
	}),

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
}
