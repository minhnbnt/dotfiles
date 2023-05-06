--local copilot_active = false

local server_name = function()
	local attached = {} -- list of attached servers
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return ""
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			if client.name == "null-ls" then -- null-ls clients
				local sources = require("null-ls").get_sources()
				for _, source in ipairs(sources) do
					if source.filetypes[buf_ft] ~= nil then
						table.insert(attached, source.name)
					end
				end
			else -- regular lsp clients
				table.insert(attached, client.name)
			end
			--elseif client.name == "copilot" then
			--	copilot_active = true -- for later
		end
	end
	local display = {}
	for i = 1, 2 do -- insert first 2 servers
		if attached[i] ~= nil then
			table.insert(display, attached[i])
		else -- no more servers
			break
		end
	end
	if #attached > 3 then -- show 2 servers + "more"
		return table.concat(display, ", ") .. " + " .. #attached - 2 .. " more"
	elseif attached[3] ~= nil then
		table.insert(display, attached[3])
	end -- show all servers
	return table.concat(display, ", ")
end

local filetype = function() -- just copy from lualine
	local lualine_require = require("lualine_require")
	local modules = lualine_require.lazy_require({
		highlight = "lualine.highlight",
		utils = "lualine.utils.utils",
	})
	local M = lualine_require.require("lualine.component"):extend()

	local default_options = {
		colored = true,
		icon_only = false,
	}

	function M:init(options)
		M.super.init(self, options)
		self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
		self.icon_hl_cache = {}
	end

	function M.update_status()
		local ft = vim.fn.expand("%:e") -- my edit
		if ft == "" then
			ft = vim.bo.filetype or ""
		end
		return modules.utils.stl_escape(ft)
	end

	function M:apply_icon()
		if not self.options.icons_enabled then
			return
		end

		local icon, icon_highlight_group
		local ok, devicons = pcall(require, "nvim-web-devicons")
		if ok then
			icon, icon_highlight_group = devicons.get_icon(vim.fn.expand("%:t"))
			if icon == nil then
				icon, icon_highlight_group = devicons.get_icon_by_filetype(vim.bo.filetype)
			end

			if icon == nil and icon_highlight_group == nil then
				icon = ""
				icon_highlight_group = "DevIconDefault"
			end
			if self.options.colored then
				local highlight_color = modules.utils.extract_highlight_colors(icon_highlight_group, "fg")
				if highlight_color then
					local default_highlight = self:get_default_hl()
					local icon_highlight = self.icon_hl_cache[highlight_color]
					if
						not icon_highlight or not modules.highlight.highlight_exists(icon_highlight.name .. "_normal")
					then
						icon_highlight = self:create_hl({ fg = highlight_color }, icon_highlight_group)
						self.icon_hl_cache[highlight_color] = icon_highlight
					end

					icon = self:format_hl(icon_highlight) .. icon .. default_highlight
				end
			end
		else
			ok = vim.fn.exists("*WebDevIconsGetFileTypeSymbol")
			if ok ~= 0 then
				icon = vim.fn.WebDevIconsGetFileTypeSymbol()
			end
		end

		if not icon then
			return
		end

		if self.options.icon_only then
			self.status = icon
		elseif type(self.options.icon) == "table" and self.options.icon.align == "right" then
			self.status = self.status .. " " .. icon
		else
			self.status = icon .. " " .. self.status
		end
	end

	return M
end

local config = {
	options = {
		-- disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = {
			normal = {
				a = { fg = "#303446", bg = "#1E66F5" },
				b = { fg = "#1E66F5", bg = "#414559" },
				c = { fg = "#E6E9EF", bg = "#181825" },
			},
			insert = {
				a = { fg = "#303446", bg = "#40A02B" },
				b = { fg = "#40A02B", bg = "#414559" },
				c = { fg = "#E6E9EF", bg = "#181825" },
			},
			visual = {
				a = { fg = "#303446", bg = "#DF8E1D" },
				b = { fg = "#DF8E1D", bg = "#414559" },
				c = { fg = "#E6E9EF", bg = "#181825" },
			},
			command = {
				a = { fg = "#303446", bg = "#EA76CB" },
				b = { fg = "#EA76CB", bg = "#414559" },
				c = { fg = "#E6E9EF", bg = "#181825" },
			},
			replace = {
				a = { fg = "#303446", bg = "#E64553" },
				b = { fg = "#E64553", bg = "#414559" },
				c = { fg = "#E6E9EF", bg = "#181825" },
			},
			terminal = {
				a = { fg = "#303446", bg = "#8839EF" },
				b = { fg = "#8839EF", bg = "#414559" },
				c = { fg = "#E6E9EF", bg = "#181825" },
			},
		},
		padding = 1, -- padding between components
	},
	sections = {
		lualine_a = {},
		lualine_b = {
			{
				function() -- show identation level
					local chars = { "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█" }
					local tab_width = vim.api.nvim_buf_get_option(0, "tabstop")
					if tab_width > 8 then
						return "█"
					end
					return chars[tab_width]
				end,
				color = { bg = "#363A4F" },
				padding = 0,
			},
		},
		lualine_y = {},
		lualine_z = {
			{
				function() -- show current position in file
					local current_line = vim.fn.line(".")
					local total_lines = vim.fn.line("$")
					--local chars = { " ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
					local chars = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " }
					local line_ratio = current_line / total_lines
					local index = math.ceil(line_ratio * #chars)
					return chars[index]
				end,
				color = { fg = "#363A4F" },
				padding = 0,
			},
		},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
				symbols = {
					modified = "●", -- Text to show when the file is modified.
					readonly = "", -- Text to show when the file is non-modifiable or readonly.
				}, -- Text to show for new created file before first writting
				padding = { left = 2, right = 1 },
			},
		},
		lualine_x = {
			{
				function()
					local line = vim.fn.line(".")
					local col = vim.fn.virtcol(".")
					return string.format("%d:%-1d", line, col)
				end,
				padding = { left = 1, right = 2 },
			},
		},
		lualine_y = {},
		lualine_z = {},
	},
}

local ins = {
	left = function(component) -- insert left
		table.insert(config.sections.lualine_c, component)
	end,
	right = function(component) -- insert right
		table.insert(config.sections.lualine_x, component)
	end,
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
	hide_in_width = function(index)
		local widths = { 115, 100, 95, 88, 78, 75, 70, 67, 55, 40 }
		local width = widths[index] or 0 -- fallback to 0
		return function()
			return vim.fn.winwidth(0) > width
		end
	end,
}

ins.left({
	function() -- :)))
		local ft = { "htm", "html", "xhtml", "xml" }
		if vim.fn.winwidth(0) < 115 or vim.tbl_contains(ft, vim.bo.filetype) then
			vim.cmd("se tabstop=2 shiftwidth=2 softtabstop=2")
		else
			vim.cmd("se tabstop=4 shiftwidth=4 softtabstop=4")
		end
		return " "
	end,
	padding = 0,
})

ins.left({
	"fileformat",
	cond = conditions.hide_in_width(6),
})

--[[ins.left({
	function()
		if copilot_active then
			return ""
		end
		return ""
	end,
	color = { fg = "#04A5E5" },
	cond = conditions.hide_in_width(1),
	padding = { left = 1, right = 0 },
})]]
ins.left({
	function()
		local b = vim.api.nvim_get_current_buf()
		if next(vim.treesitter.highlighter.active[b]) then
			return ""
		end
		return ""
	end,
	color = { fg = "#5ea64e" },
	cond = conditions.hide_in_width(1),
	padding = { left = 1, right = 0 },
})

--[[ins.left(function()
	local name, ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
	local icon, hl = require("nvim-web-devicons").get_icon(name, ext, { default = false })
	return {
		function()
			if icon then
				return icon
			end
			return ""
		end,
		color = { fg = hl },
	}
end)]]
ins.left({
	filetype(),
	icon_only = true,
})

ins.left({
	function() -- filetype name
		local icon = require("nvim-web-devicons").get_icons()
		local name, ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
		if icon[ext] then
			return icon[ext].name
		elseif icon[name] then
			return icon[name].name
		else
			return vim.bo.filetype:gsub("^%l", string.upper)
		end
	end,
	cond = conditions.hide_in_width(2),
	padding = { left = 0, right = 1 },
})

ins.left({
	"encoding",
	fmt = string.upper,
	cond = conditions.hide_in_width(5),
})

ins.left({
	"filesize",
	cond = conditions.hide_in_width(7),
})

--[[ins.left({
	function()
		if vim.fn.winwidth(0) > 115 or vim.api.nvim_get_mode().mode == "n" or vim.o.showmode then
			return ""
		end
		return vim.api.nvim_get_mode().mode
	end,
	color = { gui = "bold" },
	padding = { left = 1, right = 0 },
})]]
ins.left({
	function()
		if vim.bo.modified then
			return "●" -- file modified
		elseif vim.bo.modifiable == false then
			return "" -- read-only
		end
		return "" -- normal
	end,
	color = { fg = "#ce9178" },
	padding = { left = 1, right = 0 },
})

ins.left({
	"filename",
	file_status = false,
	path = 0,
})

ins.left({
	function()
		return "%="
	end,
	padding = 0,
})

ins.left({
	function()
        -- stylua: ignore
        local Mode = {
            ['n']     = '',
            ['niI']   = '',
            ['niR']   = '',
            ['niV']   = '',
            ['nt']    = '',
            ['ntT']   = '',
            ['no']    = '-- OPERATOR PENDING --',
            ['nov']   = '-- OPERATOR PENDING --',
            ['noV']   = '-- OPERATOR PENDING --',
            ['no\22'] = '-- OPERATOR PENDING --',
            ['v']     = '-- VISUAL --',
            ['vs']    = '-- VISUAL --',
            ['V']     = '-- VISUAL LINE --',
            ['Vs']    = '-- VISUAL LINE --',
            ['\22']   = '-- VISUAL BLOCK --',
            ['\22s']  = '-- VISUAL BLOCK --',
            ['s']     = '-- SELECT --',
            ['S']     = '-- SELECT LINE --',
            ['\19']   = '-- SELECT BLOCK --',
            ['i']     = '-- INSERT --',
            ['ic']    = '-- INSERT --',
            ['ix']    = '-- INSERT --',
            ['R']     = '-- REPLACE --',
            ['Rc']    = '-- REPLACE --',
            ['Rx']    = '-- REPLACE --',
            ['Rv']    = '-- VISUAL REPLACE --',
            ['Rvc']   = '-- VISUAL REPLACE --',
            ['Rvx']   = '-- VISUAL REPLACE --',
            ['c']     = '-- COMMAND --',
            ['cv']    = '-- EX --',
            ['ce']    = '-- EX --',
            ['r']     = '-- REPLACE --',
            ['rm']    = '-- MORE --',
            ['r?']    = '-- CONFIRM --',
            ['!']     = '-- SHELL --',
            ['t']     = '-- TERMINAL --',
        }
		if vim.o.showmode then
			return ""
		end
		local mode_code = vim.api.nvim_get_mode().mode
		if Mode[mode_code] == nil then
			return mode_code
		end
		return Mode[mode_code]
	end,
	color = { gui = "bold" },
	cond = conditions.hide_in_width(1),
})

ins.right({
	server_name,
	icon = "",
	color = { fg = "#5be3c8" },
	cond = conditions.hide_in_width(2),
})

ins.right({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	--sections = { "error", "warn", "info", "hint" },
	--symbols = { error = " ", warn = " ", info = " ", hint = " " },
	sections = { "error", "warn", "info" },
	symbols = { error = " ", warn = " ", info = " " },
	cond = conditions.hide_in_width(7),
	colored = true,
	update_in_insert = false,
	always_visible = false,
})

ins.right({
	"branch",
	icons_enabled = true,
	icon = "",
	cond = conditions.hide_in_width(3),
	color = { fg = "#FE640B" },
})

ins.right({
	"diff",
	colored = true,
	symbols = { added = "+ ", modified = "~ ", removed = "- " },
	source = nil,
	cond = conditions.hide_in_width(8),
})

ins.right({
	"searchcount",
	cond = conditions.hide_in_width(10),
})

ins.right({
	require("noice").api.status.command.get,
	cond = function() -- combine 2 conditions
		local has_command = require("noice").api.status.command.has
		local hide_in_width = conditions.hide_in_width(10)
		return hide_in_width() and has_command()
	end,
})

ins.right({
	function()
		local line = vim.fn.line(".")
		local col = vim.fn.virtcol(".")
		return string.format("%d:%-1d", line, col)
	end,
})

ins.right({
	function()
		return " "
	end,
	padding = 0,
})

require("lualine").setup(config)
