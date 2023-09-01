local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

--dap.set_log_level("TRACE")

vim.api.nvim_create_user_command("DapUiToggle", dapui.toggle, { nargs = 0 })
vim.api.nvim_create_user_command("DapUiClose", dapui.close, { nargs = 0 })
vim.api.nvim_create_user_command("DapUiOpen", dapui.open, { nargs = 0 })
vim.api.nvim_create_user_command("DapUi", function(opts)
	dapui[opts.args]()
end, {
	nargs = 1,
	complete = function()
		return { "toggle", "open", "close" }
	end,
})

vim.fn.sign_define("DapBreakpoint", { text = "" })
vim.fn.sign_define("DapStopped", { text = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "" })
vim.fn.sign_define("DapLogPoint", { text = "" })

dapui.setup({
	icons = {
		collapsed = "",
		current_frame = "",
		expanded = "",
	},
})
