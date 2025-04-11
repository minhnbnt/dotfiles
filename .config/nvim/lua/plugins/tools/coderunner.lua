local function get_command(compile, run)
	return function()
		local file_dir = vim.fn.expand("%:p:h")

		local input_path = file_dir .. "/input.txt"
		local run_with_input = false

		if vim.fn.filereadable(input_path) == 1 then
			local user_answer = vim.fn.input("Run with " .. input_path .. "? [Y/n]: ", "y")

			if not vim.tbl_contains({ "y", "n" }, user_answer) then
				return nil
			end

			run_with_input = user_answer == "y"
		end

		local command
		if compile == nil then
			command = run
		else
			command = compile .. " && " .. run
		end

		if run_with_input then
			command = command .. " < '" .. input_path .. "'"
		end

		command = "cd $dir && " .. command

		return command
	end
end

local function get_root(patterns)
	local ok, lsp = pcall(require, "lspconfig")

	if not ok then
		return nil
	end

	return lsp.util.root_pattern(unpack(patterns))(vim.loop.cwd())
end

return {

	{
		"CRAG666/code_runner.nvim",
		event = { "BufReadPost", "BufNewFile" },

		keys = {
			{ "<leader>cr", "<cmd>RunCode<cr>", desc = "Run Code" },
		},

		opts = {
			startinsert = false,
			term = {
				size = 6, -- Window size, this option is ignored if tab is true
			},

			filetype = {
				asm = get_command(
					"nasm -f elf64 $fileName && ld -o $fileNameWithoutExt $fileNameWithoutExt.o",
					"./$fileNameWithoutExt"
				),
				c = get_command("cc $fileName -lm -o $fileNameWithoutExt", "./$fileNameWithoutExt"),
				cpp = get_command("c++ $fileName -o $fileNameWithoutExt", "./$fileNameWithoutExt"),
				cs = get_command("mcs $fileName", "mono $fileNameWithoutExt.exe"),
				go = function()
					local root_dir = get_root({ "go.mod" })

					if root_dir == nil then
						return get_command("go build $fileName", "./$fileNameWithoutExt")()
					end

					return "cd " .. root_dir .. " && go run . $end"
				end,
				html = 'cd "$dir" && live-server --open=$fileName',
				java = get_command("javac $fileName", "java $fileNameWithoutExt"),
				javascript = function()
					return get_command(nil, "node $fileName")()
				end,
				lua = get_command(nil, "lua $fileName"),
				python = get_command(nil, "python3 -u $fileName"),
				rust = function()
					local root_dir = get_root({ "Cargo.toml", "rust-project.json" })

					if root_dir == nil then
						return get_command("rustc $fileName", "./$fileNameWithoutExt")()
					end

					return "cd " .. root_dir .. " && cargo run $end"
				end,
				sh = get_command(nil, "bash $fileName"),
				typescript = get_command("tsc $fileName", "node $fileNameWithoutExt.js"),
			},
		},
	},
}
