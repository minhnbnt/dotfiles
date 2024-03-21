local function load(module)
	require("plugins.dap." .. module)
end

return {

	{
		"mfussenegger/nvim-dap",
		lazy = true,

		config = function()
			load("lldb-vscode")
			load("debugpy")
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		cmd = "DapUi",

		keys = {
			{ "<leader>cd", "<cmd>DapUi toggle<cr>", desc = "Open Debugger" },
		},

		config = function()
			load("dapui")
		end,
	},
}
