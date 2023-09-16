local Plug = require("core.functions").plugin

local function get_command(compile, run)
	compile = compile or ""

	return {

		"ulimit -d 524288;", -- limit memory to 512MB
		'cd "$dir" && ' .. compile .. "if [[ -f input.txt ]];", -- check if input.txt exists
		'then cat input.txt && read -p "Run with input.txt? [Y/n]: " answer;', -- ask if user wants to run with input.txt
		'while [[ $answer != [yYnN] ]]; do read -p "Invalid option: " answer; done;', -- check if answer is valid
		"clear; if [[ $answer == [yY] ]]; then " .. run .. " < input.txt;", -- run with input.txt
		"else " .. run .. "; fi; else " .. run .. "; fi", -- run without input.txt
	}
end

return {

	Plug("CRAG666/code_runner.nvim", {

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
				c = get_command("clang $fileName -lm -o $fileNameWithoutExt", "./$fileNameWithoutExt"),
				cpp = get_command("clang++ $fileName -o $fileNameWithoutExt", "./$fileNameWithoutExt"),
				go = get_command("go build $fileName", "./$fileNameWithoutExt"),
				html = 'cd "$dir" && live-server --open=$fileName',
				java = get_command(nil, "java -cp . $fileName"),
				javascript = get_command(nil, "node $fileName"),
				lua = get_command(nil, "lua $fileName"),
				python = get_command(nil, "python $fileName"),
				rust = get_command("rustc $fileName", "./$fileNameWithoutExt"),
				sh = get_command(nil, "bash $fileName"),
				typescript = get_command("tsc $fileName", "node $fileNameWithoutExt.js"),
			},
		},
	}),

	Plug("windwp/nvim-autopairs", {

		event = "InsertEnter",
		opts = {},
	}),

	{
		"antoinemadec/FixCursorHold.nvim",
		enabled = true,
		init = function()
			vim.g.cursorhold_updatetime = 1000
		end,
	},

	Plug("numToStr/Comment.nvim", { opts = {}, lazy = false }),

	Plug("lukas-reineke/indent-blankline.nvim", {

		opts = {
			show_trailing_blankline_indent = false,
			show_first_indent_level = true,
			use_treesitter = true,

			context_patterns = {
				"class",
				"return",
				"function",
				"method",
				"^if",
				"^while",
				"jsx_element",
				"^for",
				"^object",
				"^table",
				"block",
				"arguments",
				"if_statement",
				"else_clause",
				"jsx_element",
				"jsx_self_closing_element",
				"try_statement",
				"catch_clause",
				"import_statement",
				"operation_type",
			},

			show_current_context = true,
			show_current_context_start = false,
			show_end_of_line = true,
			space_char_blankline = " ",
		},
	}),
}
