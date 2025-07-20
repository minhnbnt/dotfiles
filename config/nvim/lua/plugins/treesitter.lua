return {

	{
		"HiPhish/rainbow-delimiters.nvim",
		main = "rainbow-delimiters.setup",
		event = { "BufReadPost", "BufNewFile" },

		opts = {

			query = {
				html = "rainbow-parens",
				javascript = "rainbow-parens",
				svelte = "rainbow-parens",
				tsx = "rainbow-parens",
			},

			highlight = {
				"RainbowDelimiterYellow",
				"RainbowDelimiterPink",
				"RainbowDelimiterBlue",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = { max_lines = 3 },
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },

		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-refactor",
			{ "windwp/nvim-ts-autotag", opts = {} },
		},

		main = "nvim-treesitter.configs",

		init = function()
			vim.filetype.add({
				pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
			})
		end,

		opts = {
			-- A list of parser names, or "all"
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"c_sharp",
				"dockerfile",
				"go",
				"groovy",
				"html",
				"hyprlang",
				"java",
				"javascript",
				"kdl",
				"kotlin",
				"lua",
				"markdown",
				"nix",
				"printf",
				"python",
				"rust",
				"scss",
				"svelte",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"yaml",
			},
			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = true,
			-- List of parsers to ignore installing (for "all")
			ignore_install = { "" },
			---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
			-- parser_install_dir = "/some/path/to/store/parsers",
			-- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

			autopairs = { enable = true },
			highlight = {
				-- `false` will disable the whole extension
				enable = true,
				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				disable = function()
					return false
				end,
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = true,
			},
			refactor = {
				highlight_definitions = {
					enable = true,
					-- Set to false if you have an `updatetime` of ~100.
					clear_on_cursor_move = true,
				},
			},
		},
	},
}
