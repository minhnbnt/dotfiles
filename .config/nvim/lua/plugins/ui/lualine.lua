local M = { "nvim-lualine/lualine.nvim" }

local function server_name()
	local len = 25 -- more than max length of server name

	local buf_ft = vim.bo.filetype
	local clients = vim.lsp.get_active_clients()

	if next(clients) == nil then
		return ""
	end

	local function get_attached_names(client)
		local filetypes = client.config.filetypes or {}

		if not vim.tbl_contains(filetypes, buf_ft) then
			return {}
		end

		if client.name ~= "null-ls" then
			return { client.name }
		end

		local attached_names = {}
		local sources = require("null-ls").get_sources()

		for _, source in ipairs(sources) do
			if vim.tbl_get(source.filetypes, buf_ft) then
				table.insert(attached_names, source.name)
			end
		end

		return attached_names
	end

	local attached = {} -- list of attached servers

	for _, client in ipairs(clients) do
		local attached_names = get_attached_names(client)
		vim.list_extend(attached, attached_names)
	end

	table.sort(attached)

	local result = table.concat(attached, ", ")

	if result:len() > len then
		result = result:sub(1, len - 3) .. "..."
	end

	if #attached > 1 then
		result = "[" .. result .. "]"
	end

	return result
end

local ident_level = {

	function()
		local chars = { "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█" }
		local tab_width = vim.api.nvim_buf_get_option(0, "tabstop")
		return chars[tab_width] or "█"
	end,

	color = { bg = "#363A4F" },
	padding = 0,
}

local position = {

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
}

local file_status = {
	"filename",
	file_status = true, -- displays file status (readonly status, modified status)
	path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
	symbols = {
		modified = "●", -- Text to show when the file is modified.
		readonly = "", -- Text to show when the file is non-modifiable or readonly.
	}, -- Text to show for new created file before first writing
	padding = { left = 2, right = 1 },
}

local cursor_pos = {
	function()
		local line = vim.fn.line(".")
		local col = vim.fn.virtcol(".")
		return ("%d:%-1d"):format(line, col)
	end,
	padding = { left = 1, right = 2 },
}

M.opts = {
	sections = {
		lualine_a = {},
		lualine_b = { ident_level },
		lualine_y = {},
		lualine_z = { position },

		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		lualine_c = { file_status },
		lualine_x = { cursor_pos },
	},
}

local ins, conditions = {}, {}

function ins.left(component)
	table.insert(M.opts.sections.lualine_c, component)
end

function ins.right(component)
	table.insert(M.opts.sections.lualine_x, component)
end

function conditions.buffer_not_empty()
	return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
end

function conditions.check_git_workspace()
	local filepath = vim.fn.expand("%:p:h")
	local gitdir = vim.fn.finddir(".git", filepath .. ";")
	return gitdir and #gitdir > 0 and #gitdir < #filepath
end

function conditions.hide_in_width(index)
	local widths = { 115, 100, 95, 88, 78, 75, 70, 67, 55, 40 }
	local width = widths[index] or 0 -- fallback to 0
	return function()
		return vim.fn.winwidth(0) > width
	end
end

local function noice_command()
	local ok, noice = pcall(require, "noice")

	if not ok then
		return
	end

	return {

		noice.api.status.command.get,

		cond = function() -- combine 2 conditions
			local has_command = noice.api.status.command.has
			local hide_in_width = conditions.hide_in_width(10)
			return hide_in_width() and has_command()
		end,
	}
end

ins.left({
	function()
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
	"filetype",
	icon_only = true,
	padding = { left = 1, right = 0 },
})

ins.left({

	"bo:filetype",
	cond = conditions.hide_in_width(2),

	color = function()
		local buf = vim.api.nvim_get_current_buf()
		local ts = vim.treesitter.highlighter.active[buf]

		if ts and not vim.tbl_isempty(ts) then
			return { fg = "#85edb5" }
		end

		return {}
	end,

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
	"%=",
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

ins.right(noice_command())

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

M.opts.options = {
	-- disable sections and component separators
	component_separators = "",
	section_separators = "",
	padding = 1, -- padding between components
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

return M
