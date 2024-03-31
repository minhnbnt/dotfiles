return {

	{
		"mfussenegger/nvim-dap",
		lazy = true,

		init = function()
			vim.fn.sign_define("DapBreakpoint", { text = "" })
			vim.fn.sign_define("DapStopped", { text = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "" })
			vim.fn.sign_define("DapLogPoint", { text = "" })
		end,

		config = function()
			require("plugins.dap.debugpy")
			require("plugins.dap.lldb-vscode")
		end,
	},

	{
		"rcarriga/nvim-dap-ui",

		dependencies = {
			"nvim-neotest/nvim-nio",
			{ "mfussenegger/nvim-dap", lazy = true },
		},

		cmd = "DapUi",

		keys = {
			{ "<leader>cd", "<cmd>DapUi toggle<cr>", desc = "Open Debugger" },
		},

		config = function()
			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			dap.set_log_level("ERROR")

			vim.api.nvim_create_user_command("DapUi", function(opts)
				dapui[opts.args]()
			end, {

				nargs = 1,
				complete = function()
					return { "toggle", "open", "close" }
				end,
			})

			dapui.setup({
				icons = {
					collapsed = "",
					current_frame = "",
					expanded = "",
				},
			})
		end,
	},
}
