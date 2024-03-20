local separator_color = "#565970"
local inactive_bg = "#232634"
local active_buffer = "#99d1db"

require("bufferline").setup({
	options = {
		numbers = "none",
		get_element_icon = function(opt)
			-- element consists of { filetype: string, path: string, extension: string, directory: string }
			-- This can be used to change how bufferline fetches the icon for an element e.g. a buffer or a tab.
			local ok, devicons = pcall(require, "nvim-web-devicons")

			if not ok then
				return
			end

			local ft, icons = opt.filetype, devicons.get_icons()
			local icon, hl = devicons.get_icon_by_filetype(ft, { default = false })
			local icon_name = devicons.get_icon_name_by_filetype(ft) or opt.extension

			local function get_name()
				if icon_name ~= nil and icons[icon_name] ~= nil then
					return icons[icon_name].name
				end
				return "Default"
			end

			-- there are lots of filetypes, so I just set opening filetype for highlight
			vim.api.nvim_set_hl(0, "BufferLineDevIcon" .. get_name(), { link = "BufferLineBackground" })
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
		separator_style = "slant",
		show_buffer_close_icons = true,
		show_buffer_icons = true,
		show_close_icon = false,

		custom_areas = {
			right = function()
				local always_visible = false

				local symbols = { error = " ", warn = " ", info = " ", hint = " " }
				local keys = { "error", "warn", "info", "hint" }

				local link = {
					error = "DiagnosticError",
					warn = "DiagnosticWarn",
					info = "DiagnosticInfo",
					hint = "DiagnosticHint",
				}

				local result = {}
				local item_inserted = 0
				local severity = vim.diagnostic.severity

				local stat = {
					error = #vim.diagnostic.get(0, { severity = severity.ERROR }),
					warn = #vim.diagnostic.get(0, { severity = severity.WARN }),
					info = #vim.diagnostic.get(0, { severity = severity.INFO }),
					hint = #vim.diagnostic.get(0, { severity = severity.HINT }),
				}

				for _, key in pairs(keys) do
					local text = symbols[key] .. stat[key] .. " "
					if always_visible or stat[key] > 0 then
						item_inserted = item_inserted + 1
					else
						text = ""
					end
					table.insert(result, { text = text, link = link[key] })
				end

				if item_inserted > 0 then
					table.insert(result, 1, { text = " ", link = "BufferLineSeparatorSelected" })
				end

				return result
			end,
		},
	},

	highlights = {
		background = {
			fg = "NONE",
			bg = inactive_bg,
		},
		close_button = {
			fg = "NONE",
			bg = inactive_bg,
		},
		fill = {
			fg = "NONE",
			bg = separator_color,
		},
		buffer_selected = {
			fg = active_buffer,
			italic = false,
		},
		duplicate = {
			bg = inactive_bg,
		},
		modified = {
			bg = inactive_bg,
		},
		separator = {
			fg = separator_color,
			bg = inactive_bg,
		},
		separator_selected = {
			fg = separator_color,
		},
		separator_visible = {
			fg = separator_color,
		},
		pick = {
			bg = inactive_bg,
			italic = false,
		},
		trunc_marker = {
			fg = "NONE",
			bg = separator_color,
		},
	},
})
