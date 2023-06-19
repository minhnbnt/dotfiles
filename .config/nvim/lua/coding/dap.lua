local dap, dapui = require("dap"), require("dapui")

dap.configurations.c = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			local compile
			local path, type = '"' .. vim.fn.expand("%:p:h") .. '"', vim.bo.filetype
			local name, without_ext = vim.fn.expand("%:t"), vim.fn.expand("%:t:r")
			local command = {
				c = "clang -lm -g3", -- -lm for math.h
				cpp = "clang++ -g3",
				rust = "rustc -g",
			}
			if command[type] ~= nil then
				vim.cmd("w") -- Save file
				local cmd = { "cd", path, "&&", command[type], name, "-o", without_ext, "2>&1" }
				compile = assert(io.popen(table.concat(cmd, " "), "r")) -- compile
			end
			local output = compile:read("*all")
			compile:close()
			if output ~= "" then
				vim.notify(output, vim.log.levels.ERROR, { title = "Compilation Error" })
			else -- Compile success
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

dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",
		name = "Launch file",

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		program = function()
			vim.cmd("w")
			return vim.fn.expand("%:p")
		end,
		console = "integratedTerminal",
		pythonPath = function()
			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			else
				return "/usr/bin/python"
			end
		end,
	},
}

dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
	name = "lldb",
}

dap.adapters.python = function(cb, config)
	if config.request == "attach" then
		---@diagnostic disable-next-line: undefined-field
		local port = (config.connect or config).port
		---@diagnostic disable-next-line: undefined-field
		local host = (config.connect or config).host or "127.0.0.1"
		cb({
			type = "server",
			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
			host = host,
			options = { source_filetype = "python" },
		})
	else
		cb({
			type = "executable",
			command = "/usr/bin/python",
			args = { "-m", "debugpy.adapter" },
			options = { source_filetype = "python" },
		})
	end
end

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

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
		mappings = { close = { "q", "<Esc>" } },
	},
	force_buffers = true,
	icons = {
		collapsed = "",
		current_frame = "",
		expanded = "",
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
