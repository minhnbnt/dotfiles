local dap, dapui = require("dap"), require("dapui")
dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			local compile
			local path, type = vim.fn.expand("%:p:h"), vim.bo.filetype
			local name, without_ext = vim.fn.expand("%:t"), vim.fn.expand("%:t:r")
			local command = {
				c = "clang -lm -g3 ",
				cpp = "clang++ -g3 ",
				rust = "rustc -g ",
			}
			if command[type] ~= nil then
				vim.cmd("w")
				compile = assert(
					io.popen('cd "' .. path .. '" && ' .. command[type] .. name .. " -o " .. without_ext .. " 2>&1")
				)
			end
			local output = compile:read("*all")
			compile:close()
			if output ~= "" then
				vim.notify(output, vim.log.levels.ERROR, { title = "Compilation Error" })
				return
			else
				return vim.fn.expand("%:p:r")
			end
		end,
		cwd = "${workspaceFolder}",
		env = function()
			local variables = {}
			for k, v in pairs(vim.fn.environ()) do
				table.insert(variables, string.format("%s=%s", k, v))
			end
			return variables
		end,
		stopOnEntry = false,
		runInTerminal = true,
		args = {},
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

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
vim.api.nvim_create_user_command("DapUiOpen", function()
	dapui.open()
end, { nargs = 0 })
vim.api.nvim_create_user_command("DapUiClose", function()
	dapui.close()
end, { nargs = 0 })
vim.api.nvim_create_user_command("DapUiToggle", function()
	dapui.toggle()
end, { nargs = 0 })

vim.fn.sign_define("DapBreakpoint", { text = "" })
vim.fn.sign_define("DapStopped", { text = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ" })
vim.fn.sign_define("DapBreakpointRejected", { text = "" })
vim.fn.sign_define("DapLogPoint", { text = "" })

dapui.setup({
	controls = {
		element = "repl",
		enabled = true,
		icons = {
			disconnect = "",
			pause = "",
			play = "",
			run_last = "",
			step_back = "",
			step_into = "",
			step_out = "",
			step_over = "",
			terminate = "",
		},
	},
	element_mappings = {},
	expand_lines = true,
	floating = {
		border = "single",
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	force_buffers = true,
	icons = {
		collapsed = "",
		current_frame = "",
		expanded = "",
	},
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.25 },
				{ id = "breakpoints", size = 0.25 },
				{ id = "stacks", size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			position = "left",
			size = 40,
		},
		{
			elements = {
				{ id = "repl", size = 0.5 },
				{ id = "console", size = 0.5 },
			},
			position = "bottom",
			size = 10,
		},
	},
	mappings = {
		edit = "e",
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		repl = "r",
		toggle = "t",
	},
	render = {
		indent = 1,
		max_value_lines = 100,
	},
})
