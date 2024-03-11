local function get_command(compile, run)
	return function()
		local file_dir = vim.fn.expand("%:p:h")

		local input_path = file_dir .. "/input.txt"
		local run_with_input

		if vim.fn.filereadable(input_path) == 1 then
			local user_answer = vim.fn.input("Run with " .. input_path .. "? [Y/n]: ", "y")

			while not vim.tbl_contains({ "y", "n" }, user_answer) do
				user_answer = vim.fn.input("Invalid input [y/n]: ", "y")
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

return {

	{
		"CRAG666/code_runner.nvim",

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
					local root_dir = require("lspconfig").util.root_pattern("go.mod")(vim.loop.cwd())

					if root_dir == nil then
						return get_command("go build $fileName", "./$fileNameWithoutExt")()
					end

					return "cd " .. root_dir .. " && go run . $end"
				end,
				html = 'cd "$dir" && live-server --open=$fileName',
				java = get_command("javac $fileName", "java $fileNameWithoutExt"),
				javascript = function()
					local root_dir =
						require("lspconfig").util.root_pattern("tsconfig.json", "package.json", "jsconfig.json")(
							vim.loop.cwd()
						)

					if root_dir == nil then
						return get_command(nil, "node $fileName")()
					end

					return "cd " .. root_dir .. " && bun run $end"
				end,
				lua = get_command(nil, "lua $fileName"),
				python = get_command(nil, "python3 -u $fileName"),
				rust = function()
					local root_dir =
						require("lspconfig").util.root_pattern("Cargo.toml", "rust-project.json")(vim.loop.cwd())

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

	{
		"rest-nvim/rest.nvim",
		enabled = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"antoinemadec/FixCursorHold.nvim",
		enabled = true,
		init = function()
			vim.g.cursorhold_updatetime = 1000
		end,
	},

	{ "numToStr/Comment.nvim", opts = {}, lazy = false },

	{
		"michaelb/sniprun",

		build = "sh ./install.sh",

		opts = { display = { "NvimNotify" } },
	},

	{
		"folke/zen-mode.nvim",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle zen-mode" },
		},
		opts = {},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",

		opts = function()
			vim.api.nvim_set_hl(0, "CurrScope", { fg = "#787f96" })

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

			return {

				indent = { char = "│" },
				scope = {
					highlight = { "CurrScope" },
					enabled = true,
					show_start = false,
					show_end = false,
				},
			}
		end,
	},
}
