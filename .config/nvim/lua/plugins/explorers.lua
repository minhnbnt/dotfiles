local function open_file_browser()
	local current_dir = vim.fn.expand("%:p")
	local stat = vim.loop.fs_stat(current_dir)

	if not stat or stat.type ~= "directory" then
		return
	end

	local ok, telescope = pcall(require, "telescope")

	if not ok then
		return
	end

	local file_browser = telescope.extensions.file_browser

	if not file_browser then
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
		cmd = { "NvimTreeOpen", "NvimTreeToggle" },

		keys = {
			{ "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "Nvim Tree" },
		},

		version = "*",

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
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",

		keys = {
			{ "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
			{ "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
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
