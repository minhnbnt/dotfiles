local function load(module)
	require("plugins.dap." .. module)
end

return {
	{
		"mfussenegger/nvim-dap",
		enabled = true,

		config = function()
			load("lldb-vscode")
			load("debugpy")
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		enabled = true,

		config = function()
			load("dapui")
		end,
	},
}
