local Plug = require("core.functions").plugin

local function load(module)
	require("plugins.dap." .. module)
end

return {

	Plug("mfussenegger/nvim-dap", {
		config = function()
			load("lldb-vscode")
			load("debugpy")
		end,
	}),

	Plug("rcarriga/nvim-dap-ui", {
		config = function()
			load("dapui")
		end,
	}),
}
