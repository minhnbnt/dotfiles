require("bufferline").setup({
	options = {
		mode = "Buffers", -- set to "tabs" to only show tabpages instead
		themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
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
		get_element_icon = function(opt)
			-- element consists of { filetype: string, path: string, extension: string, directory: string }
			-- This can be used to change how bufferline fetches the icon
			-- for an element e.g. a buffer or a tab.
			-- e.g.
			local devicon = require("nvim-web-devicons")
			local filename, ext = vim.fn.expand("%:t"), opt.extension
			local icon, hl = devicon.get_icon_by_filetype(opt.extension, { default = false })
			local icons = devicon.get_icons()
			-- some extra logic to set highlight group
			local name = function()
				if icons[ext] then -- filetype
					return icons[ext].name
				elseif icons[filename] then -- filename
					return icons[filename].name
				else -- if no icon is found, return the default
					return "Default"
				end
			end
			-- there are lots of filetypes, so I just set opening filetype for highlight
			vim.api.nvim_set_hl(0, "BufferLineDevIcon" .. name(), { link = "BufferLineBackground" })
			-- for open multiple files at once, I couldn't find a way to set highlight for each filetype :(
			return icon, hl -- like normal
		end,
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
			delay = 0,
			reveal = { "close" },
		},
		color_icons = true, -- whether or not to add the filetype icon highlights
		separator_style = "slant",
		show_buffer_close_icons = true,
		show_buffer_icons = true,
		show_close_icon = false,
	},
})
