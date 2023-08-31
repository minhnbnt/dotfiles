return {

	"nvim-treesitter/nvim-treesitter",
	version = "*",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-refactor",
		"windwp/nvim-ts-autotag",
		"HiPhish/nvim-ts-rainbow2",
		--"mrjones2014/nvim-ts-rainbow",
	},

	config = function()
		local rainbow = require("ts-rainbow")

		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all"
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"html",
				"java",
				"javascript",
				"lua",
				"python",
				"rust",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,
			-- List of parsers to ignore installing (for "all")
			ignore_install = { "" },
			---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
			-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

			autopairs = {
				enable = true,
			},
			autotag = {
				enable = true,
			},
			highlight = {
				-- `false` will disable the whole extension
				enable = true,
				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				disable = { "" },
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = true,
			},
			rainbow = {
				enable = false,
				-- disable = { "htm", "html", "xhtml", "xml" }, -- list of languages you want to disable the plugin for
				extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				--colors = { "#dfcf1d", "#ea76cb", "#1E66F5" }, -- table of hex strings
				strategy = rainbow.strategy["local"],
				query = "rainbow-parens",
				hlgroups = { "TSRainbowYellow", "TSRainbowViolet", "TSRainbowBlue" },
				-- termcolors = {} -- table of colour name strings
			},
			refactor = {
				highlight_definitions = {
					enable = true,
					-- Set to false if you have an `updatetime` of ~100.
					clear_on_cursor_move = true,
				},
			},
		})

		vim.api.nvim_set_hl(0, "TSRainbowYellow", { fg = "#dfcf1d" })
		vim.api.nvim_set_hl(0, "TSRainbowViolet", { fg = "#ea76cb" })
		vim.api.nvim_set_hl(0, "TSRainbowBlue", { fg = "#5480f7" })
	end,
}
