local function server_name()
	local len = 20 -- more than max length of server name
	local attached = {} -- list of attached servers
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return ""
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.tbl_contain(filetypes, buf_ft) then
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
		elseif client.name == "copilot" then
			vim.b.copilot_active = true -- for later
		end
	end
	local displays, not_displayed = {}, #attached
	while true do -- shorten names until they fit
		local server = table.remove(attached, 1)
		not_displayed = not_displayed - 1
		table.insert(displays, server)
		if not_displayed == 1 then
			-- i don't want to see + 1 more
			table.insert(displays, attached[1])
			break -- displays = attached
		end
		local str = table.concat(displays, ", ")
		if str:len() > len then -- if too long
			return str .. " + " .. not_displayed .. " more"
		end
	end
	-- without more
	return table.concat(displays, ", ")
end

local filetype = require("lualine.components.filetype")

function filetype.update_status()
	local modules = require("lualine_require").lazy_require({
		highlight = "lualine.highlight",
		utils = "lualine.utils.utils",
	})
	local ft = vim.fn.expand("%:e")
	if ft == "" then
		ft = vim.bo.filetype or ""
	end
	return modules.utils.stl_escape(ft)
end

local config = {
	sections = {
		lualine_a = {},
		lualine_y = {},
		lualine_b = {
			{
				function() -- show identation level
					local chars = { "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█" }
					local tab_width = vim.api.nvim_buf_get_option(0, "tabstop")
					return chars[tab_width] or "█"
				end,
				color = { bg = "#363A4F" },
				padding = 0,
			},
		},
		lualine_z = {
			{
				function() -- show current position in file
					local current_line = vim.fn.line(".")
					local total_lines = vim.fn.line("$")
					-- local chars = { " ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
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
	function() --[[
		local ft = { "html", "xhtml", "xml", "typescriptreact", "javascriptreact" }
		if vim.fn.winwidth(0) < 115 or vim.tbl_contains(ft, vim.bo.filetype) then
			vim.cmd("se tabstop=2 shiftwidth=2 softtabstop=2")
		else
			vim.cmd("se tabstop=4 shiftwidth=4 softtabstop=4")
		end ]]
		return " "
	end,
	padding = 0,
})

ins.left({
	"fileformat",
	cond = conditions.hide_in_width(6),
})

ins.left({
	function()
		if vim.b.copilot_active then
			return ""
		end
		return ""
	end,
	color = { fg = "#04A5E5" },
	cond = conditions.hide_in_width(1),
	padding = { left = 1, right = 0 },
})

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

ins.left({
	filetype,
	icon_only = true,
})

ins.left({
	function() -- filetype name
		return vim.bo.filetype
	end,
	cond = conditions.hide_in_width(2),
	fmt = function(str)
		return str:gsub("^%l", string.upper)
	end,
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
	"mode",
	fmt = function(str)
		-- stylua: ignore
		local map = {
			["O-PENDING"] = "OPERATOR PENDING",
			["V-BLOCK"]   = "VISUAL BLOCK",
			["V-LINE"]    = "VISUAL LINE",
			["V-REPLACE"] = "VISUAL REPLACE",
			["S-BLOCK"]   = "SELECT BLOCK",
			["S-LINE"]    = "SELECT LINE",
		}
		local mode = map[str] or str
		if mode == "NORMAL" then
			return ""
		end
		return "-- " .. mode .. " --"
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
	sections = { "error", "warn", "info", "hint" },
	symbols = { error = " ", warn = " ", info = " ", hint = " " },
	-- sections = { "error", "warn", "info" },
	-- symbols = { error = " ", warn = " ", info = " " },
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

local has_noice, noice = pcall(require, "noice")

if has_noice then
	ins.right({
		noice.api.status.command.get,
		cond = function() -- combine 2 conditions
			local has_command = noice.api.status.command.has
			local hide_in_width = conditions.hide_in_width(10)
			return hide_in_width() and has_command()
		end,
	})
end

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

config.options = {
	-- disable sections and component separators
	component_separators = "",
	section_separators = "",
	padding = 1, -- padding between components
	refresh = { statusline = 5000 },
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
}

require("lualine").setup(config)
