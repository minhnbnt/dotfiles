local function load(module)
	require("plugins.dap." .. module)
end

return {

	{
		"mfussenegger/nvim-dap",

		config = function()
			load("lldb-vscode")
			load("debugpy")
		end,
	},

	{
		"rcarriga/nvim-dap-ui",

		config = function()
			load("dapui")
		end,
	},
}
