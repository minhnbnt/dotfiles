if vim.g.vscode then
	require("vscbootstrap")
else
	require("options")
	require("plug")
end

-- used for testing
--[[
local function start()
	return require("packer").startup(function(use)
		
		use("wbthomason/packer.nvim")
	end)
end

start()
]]
