local enabled = require("handle").enabled_plugins

local M = {}

function M.create_plug(plugin)
	local result = { plugin }

	if not vim.tbl_contains(enabled, plugin) then
		result.enabled = false
	end

	return result
end

function M.plugin(plugin, config)
	local head = M.create_plug(plugin)
	return vim.tbl_extend("keep", head, config)
end

return M
