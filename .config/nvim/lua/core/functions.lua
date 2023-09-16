local enabled = require("plugged").enabled

local M = {}

function M.create_plug(plugin)
	local rtn = { plugin }

	if not vim.tbl_contains(enabled, plugin) then
		rtn.enabled = false
	end

	return rtn
end

function M.plugin(plugin, config)
	local head = M.create_plug(plugin)
	return vim.tbl_extend("keep", head, config)
end

return M
