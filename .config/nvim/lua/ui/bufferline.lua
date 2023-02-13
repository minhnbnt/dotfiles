require("bufferline").setup({
	options = {
		mode = "Buffers", -- set to "tabs" to only show tabpages instead
		close_command = "Bdelete %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "Bdelete %d", -- can be a string | function, see "Mouse actions"
		numbers = "none",
		indicator = {
			icon = "┃", -- this should be omitted if indicator style is not 'icon'
			style = "none",
		},
		modified_icon = "●",
		max_name_length = 18,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		truncate_names = true, -- whether or not tab names should be truncated
		tab_size = 18,
		diagnostics = "none",
		diagnostics_update_in_insert = false,
		-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			return "(" .. count .. ")"
		end,
		-- NOTE: this will be called a lot so don't do any heavy processing here        end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				separator = true,
				highlight = "PanelHeading",
			},
			{
				filetype = "packer",
				text = "Packer",
				highlight = "PanelHeading",
				padding = 1,
			},
		},
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		separator_style = "slant",
		show_buffer_close_icons = true,
		show_buffer_icons = true,
		show_close_icon = false,
		highlights = {
			fill = {
				guifg = { attribute = "fg", highlight = "" },
				guibg = { attribute = "bg", highlight = "StatusLineNC" },
			},
			background = {
				guifg = { attribute = "fg", highlight = "" },
				guibg = { attribute = "bg", highlight = "StatusLine" },
			},
			buffer_visible = {
				gui = "",
				guifg = { attribute = "fg", highlight = "" },
				guibg = { attribute = "bg", highlight = "" },
			},
			buffer_selected = {
				gui = "",
				guifg = { attribute = "fg", highlight = "" },
				guibg = { attribute = "bg", highlight = "" },
			},
			separator = {
				guifg = { attribute = "bg", highlight = "" },
				guibg = { attribute = "bg", highlight = "StatusLine" },
			},
			separator_selected = {
				guifg = { attribute = "fg", highlight = "Special" },
				guibg = { attribute = "bg", highlight = "" },
			},
			separator_visible = {
				guifg = { attribute = "fg", highlight = "" },
				guibg = { attribute = "bg", highlight = "StatusLineNC" },
			},
			close_button = {
				guifg = { attribute = "fg", highlight = "" },
				guibg = { attribute = "bg", highlight = "StatusLine" },
			},
			close_button_selected = {
				guifg = { attribute = "fg", highlight = "" },
				guibg = { attribute = "bg", highlight = "" },
			},
			close_button_visible = {
				guifg = { attribute = "fg", highlight = "" },
				guibg = { attribute = "bg", highlight = "" },
			},
		},
	},
})
