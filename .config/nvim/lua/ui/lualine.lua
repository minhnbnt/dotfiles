local copilot_active = false

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
		elseif client.name == "copilot" then
			copilot_active = true -- for later
		end
	end
	local display = {}
	for i = 1, 2 do -- insert first 2 servers
		if attached[i] ~= nil then
			table.insert(display, attached[i])
		end
	end
	if #attached > 3 then -- show 2 servers + "more"
		return table.concat(display, ", ") .. " + " .. #attached - 2 .. " more"
	else
		if attached[3] ~= nil then
			table.insert(display, attached[3])
		end -- show all servers
		return table.concat(display, ", ")
	end
end

local function file_ext()
	local filename = vim.fn.expand("%:t")
	local ft = filename:match("[^.]+$")
	local map = {
		cpp = "c++",
		cc = "c++",
		cxx = "c++",
		csharp = "c#",
		css = "CSS",
		html = "HTML",
		h = "header",
		hh = "header",
		hpp = "header",
		hxx = "header",
		["h++"] = "header",
		json = "JSON",
		jsonc = "JSON comments",
		py = "python",
		txt = "text",
		sh = "shell",
		yaml = "YAML",
	}
	if map[ft] then
		return map[ft]
	elseif ft then
		return ft
	else
		return ""
	end
end

local config = {
	options = {
		-- disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = "auto",
		padding = 1, -- padding between components
	},
	sections = {
		lualine_a = {},
		lualine_b = {
			{
				function() -- show identation level
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
				color = { fg = "#373737" },
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
		return function()
			return vim.fn.winwidth(0) > widths[index]
		end
	end,
}

ins.left({
	function() -- :)))
		if vim.fn.winwidth(0) < 115 then -- adjust identation
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

ins.left({
	function()
		if copilot_active then
			return ""
		else
			return ""
		end
	end,
	color = { fg = "#28f5fc" },
	cond = conditions.hide_in_width(1),
	padding = { left = 1, right = 0 },
})

ins.left({
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

ins.left({
	"filetype",
	icon_only = true,
})

ins.left({
	function() -- filetype
		return vim.bo.filetype
	end,
	cond = conditions.hide_in_width(2),
	padding = { left = 0, right = 1 },
	fmt = function(str)
		return str:gsub("^%l", string.upper)
	end,
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
		if vim.fn.winwidth(0) > 115 or vim.api.nvim_get_mode().mode == "n" or vim.o.showmode then
			return ""
		else
			return vim.api.nvim_get_mode().mode
		end
	end,
	color = { gui = "bold" },
	padding = { left = 1, right = 0 },
})

ins.left({
	function()
		if vim.bo.modified then
			return "●" -- file modified
		elseif vim.bo.modifiable == false then
			return "" -- read-only
		else
			return "" -- normal
		end
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

ins.right({
	server_name,
	icon = "",
	color = { fg = "#72edcc" },
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
	color = { fg = "#eb6750" },
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
