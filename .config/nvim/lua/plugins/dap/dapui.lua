local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

--dap.set_log_level("TRACE")

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
