local function open_file_browser()
	local ok, telescope = pcall(require, "telescope")

	if not ok then
		return
	end

	local file_browser = telescope.extensions.file_browser

	if not file_browser then
		return
	end

	local current_dir = vim.fn.expand("%:p")
	local stat = vim.loop.fs_stat(current_dir)

	if not stat or stat.type ~= "directory" then
		return
	end

	vim.api.nvim_buf_delete(0, { force = true })

	file_browser.file_browser({
		path = current_dir,
		grouped = true,
		hidden = true,
	})
end

return {

	{
		"nvim-tree/nvim-tree.lua",

		keys = {
			{ "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "Nvim Tree" },
		},

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
				callback = require("nvim-tree.api").tree.close,
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",

		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
			{ "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
		},

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

				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--no-ignore",
				},
			},
		},
	},
}
