return {

	"folke/noice.nvim",

	version = "*",
	event = "VeryLazy",

	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},

	opts = {
		cmdline = {
			enabled = true, -- enables the Noice cmdline UI
			format = {
				--search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
				--search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" },
			},
		},
		lsp = {
			progress = { enabled = false },
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			signature = { enabled = false },
		},
		presets = {
			-- you can enable a preset by setting it to true, or a table that will override the preset config
			-- you can also add custom presets that you can enable/disable with enabled=true
			bottom_search = false, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
		routes = {
			{
				filter = { find = "offset_encodings" },
				opts = { skip = true },
			},
			{
				filter = { find = "}" },
				opts = { skip = true },
			},
		},
		views = {
			cmdline_popup = {
				size = { width = "60%" },
				-- border = { style = "single" },
			},
		},
	},
}
