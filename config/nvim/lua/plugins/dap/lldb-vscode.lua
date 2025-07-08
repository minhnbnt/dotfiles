local dap = require("dap")

dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-dap",
	name = "lldb",
}

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

			local return_code = { compile:close() }

			if return_code[3] == 0 then
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

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c
