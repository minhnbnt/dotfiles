local server_name = function()
	local msg = ""
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return msg
	end
	-- null-ls clients
	--[[
  local function null_ls_client_names()
    local sources = require("null-ls").sources
    local available = sources.get_available(buf_ft)
    local registered ={}
    for _, source in ipairs(available) do
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        table.insert(registered[method], source.name)
      end
    end
  end
  ]]
	-- return clients
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end
	return msg
end

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

local config = {
	options = {
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = "auto",
		padding = 1,
	},
	sections = {
		lualine_a = {},
		lualine_b = {
			{
				function()
					local chars = { "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█" }
					local tab_width = vim.api.nvim_buf_get_option(0, "tabstop")
					local ratio = tab_width / 8
					local index = math.ceil(ratio * #chars)
					if tab_width > 8 then
						return "█"
					else
						return chars[index]
					end
				end,
				color = { bg = "#373737" },
				padding = 0,
			},
		},
		lualine_y = {
			{
				function()
					local current_line = vim.fn.line(".")
					local total_lines = vim.fn.line("$")
					--local chars = { " ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
					local chars = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " }
					local line_ratio = current_line / total_lines
					local index = math.ceil(line_ratio * #chars)
					return chars[index]
				end,
				color = { bg = "#373737" },
				padding = 0,
			},
		},
		lualine_z = {},
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
					return string.format("%d:%-1d", col, line)
				end,
				padding = { left = 1, right = 2 },
			},
		},
		lualine_y = {},
		lualine_z = {},
	},
}

local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

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
		return function()
			return vim.fn.winwidth(0) > widths[index]
		end
	end,
}
-- :)))
ins_left({
	function()
		if vim.fn.winwidth(0) < 115 then
			vim.cmd("se tabstop=2 shiftwidth=2 softtabstop=2")
		else
			vim.cmd("se tabstop=4 shiftwidth=4 softtabstop=4")
		end
		return ""
	end,
})

ins_left({
	function()
		return " "
	end,
	padding = 0,
})

ins_left({
	"fileformat",
	cond = conditions.hide_in_width(6),
})

ins_left({
	function()
		local b = vim.api.nvim_get_current_buf()
		if next(vim.treesitter.highlighter.active[b]) then
			return ""
		end
	end,
	color = { fg = "#62a544" },
	cond = conditions.hide_in_width(1),
	padding = { left = 1, right = 0 },
})

ins_left({
	"filetype",
	icon_only = true,
})

ins_left({
	"filetype",
	icon = nil,
	icons_enabled = false,
	cond = conditions.hide_in_width(2),
	padding = { left = 0, right = 1 },
	fmt = function(str)
		return (str:gsub("^%l", string.upper))
	end,
})

ins_left({
	"encoding", -- option component same as encoding in viml
	fmt = string.upper,
	cond = conditions.hide_in_width(5),
})

ins_left({
	"filesize",
	cond = conditions.hide_in_width(7),
})

ins_left({
	function()
		if vim.fn.winwidth(0) > 115 or vim.api.nvim_get_mode().mode == "n" or vim.o.showmode then
			return ""
		else
			return vim.api.nvim_get_mode().mode
		end
	end,
	color = { gui = "bold" },
	padding = { left = 1, right = 0 },
})

ins_left({
	function()
		if vim.bo.modified then
			return "●"
		elseif vim.bo.modifiable == false then
			return ""
		else
			return ""
		end
	end,
	color = { fg = "#ce9178" },
	padding = { left = 1, right = 0 },
})

ins_left({
	"filename",
	file_status = false,
	path = 0,
})
ins_left({
	function()
		return "%="
	end,
	padding = 0,
})

ins_left({
	function()
		if vim.o.showmode then
			return ""
		else
			local mode_code = vim.api.nvim_get_mode().mode
			if Mode[mode_code] == nil then
				return mode_code
			end
			return Mode[mode_code]
		end
	end,
	color = { gui = "bold" },
	cond = conditions.hide_in_width(1),
})
--[[
ins_left({
	function()
		if not rawget(vim, "lsp") then
			return ""
		end

		local Lsp = vim.lsp.util.get_progress_messages()[1]

		if vim.o.columns < 120 or not Lsp then
			return ""
		end

		local msg = Lsp.message or ""
		local percentage = Lsp.percentage or 0
		local title = Lsp.title or ""
		local spinners = { "", "" }
		local ms = vim.loop.hrtime() / 1000000
		local frame = math.floor(ms / 120) % #spinners
		local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

		return ("%#St_LspProgress#" .. content) or ""
	end,
})
]]
ins_right({
	server_name,
	icon = "",
	color = { fg = "#72edcc" },
	cond = conditions.hide_in_width(2),
})

ins_right({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	--sections = { "error", "warn", "info", "hint" },
	--symbols = { error = " ", warn = " ", info = " ", hint = " " },
	sections = { "error", "warn", "info" },
	symbols = { error = " ", warn = " ", info = " " },
	cond = conditions.hide_in_width(7),
	colored = true,
	update_in_insert = false,
	always_visible = function()
		if server_name() == "" or server_name() == "null-ls" then
			return false
		else
			return true
		end
	end,
})

ins_right({
	"branch",
	icons_enabled = true,
	icon = "",
	cond = conditions.hide_in_width(3),
	color = { fg = "#eb6750" },
})

ins_right({
	"diff",
	colored = true,
	symbols = { added = "+ ", modified = "~ ", removed = "- " },
	source = nil,
	cond = conditions.hide_in_width(8),
})

ins_right({
	"searchcount",
	cond = conditions.hide_in_width(10),
})

ins_right({
	function()
		local line = vim.fn.line(".")
		local col = vim.fn.virtcol(".")
		return string.format("%d:%-1d", line, col)
	end,
})

ins_right({
	function()
		return " "
	end,
	padding = 0,
})

require("lualine").setup(config)
