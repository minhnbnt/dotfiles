local function open_find_file()
	local current_dir = vim.fn.expand("%:p")
	local stat = vim.loop.fs_stat(current_dir)

	if not stat or stat.type ~= "directory" then
		return
	end

	local ok, telescope = pcall(require, "telescope.builtin")

	if not ok then
		return
	end

	vim.api.nvim_buf_delete(0, { force = true })
	telescope.find_files()
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
			hijack_cursor = false,
			sync_root_with_cwd = true,
		},

		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
		branch = "v3.x",

		cmd = { "Neotree" },
		keys = {
			{ "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree toggle" },
		},

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "pynappo/nui.nvim", branch = "support-winborder" },
			"3rd/image.nvim",
		},

		opts = {
			enable_git_status = false,
			enable_diagnostics = false,

			sort_case_insensitive = true,
			sources = { "filesystem", "git_status", "document_symbols" },
			source_selector = {
				winbar = true,
				sources = {
					{ source = "filesystem", display_name = " 󰉓 File " },
					{ source = "git_status", display_name = " 󰊢 Git " },
					{ source = "document_symbols", display_name = "  Sym " },
				},
				content_layout = "center",
			},
			window = { width = 34 },
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
				},
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",

		keys = {
			{ "<leader>bp", "<cmd>Telescope buffers<cr>", desc = "Buffer Picker" },
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
				enabled = false,
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
				callback = open_find_file,
			})
		end,

		opts = {
			pickers = {
				find_files = { hidden = true, grouped = true },
				file_browser = { hidden = true, grouped = true },
			},
			defaults = {
				-- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--column",
					"--hidden",
					"--line-number",
					"--no-heading",
					"--no-ignore",
					"--smart-case",
					"--with-filename",
				},
			},
		},
	},
}
