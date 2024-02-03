local Plug = require("core.functions").plugin

local function get_command(compile, run)
	if compile == nil or compile == "" then
		compile = ""
	else
		compile = compile .. " && "
	end

	return {

		"ulimit -d 524288;", -- limit memory to 512MB
		'cd "$dir" && ' .. compile .. "if [[ -f input.txt ]];", -- check if input.txt exists
		'then cat input.txt && printf "Run with input.txt? [Y/n]: "; read answer;', -- ask if user wants to run with input.txt
		'while [[ $answer != [yYnN] ]]; do printf "Invalid option: "; read answer; done;', -- check if answer is valid
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
				c = get_command("cc $fileName -lm -o $fileNameWithoutExt", "./$fileNameWithoutExt"),
				cpp = get_command("c++ $fileName -o $fileNameWithoutExt", "./$fileNameWithoutExt"),
				cs = get_command("mcs $fileName", "mono $fileNameWithoutExt.exe"),
				go = get_command("go build $fileName", "./$fileNameWithoutExt"),
				html = 'cd "$dir" && live-server --open=$fileName',
				java = get_command("javac $fileName", "java $fileNameWithoutExt"),
				javascript = get_command(nil, "node $fileName"),
				lua = get_command(nil, "lua $fileName"),
				python = get_command(nil, "python3 -u $fileName"),
				rust = get_command("rustc $fileName", "./$fileNameWithoutExt"),
				sh = get_command(nil, "bash $fileName"),
				typescript = get_command("tsc $fileName", "node $fileNameWithoutExt.js"),
			},
		},
	}),

	Plug("rest-nvim/rest.nvim", {

		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
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

	Plug("michaelb/sniprun", {

		lazy = true,
		build = "sh ./install.sh",

		opts = { display = { "NvimNotify" } },
	}),

	Plug("lukas-reineke/indent-blankline.nvim", {

		main = "ibl",

		opts = function()
			vim.api.nvim_set_hl(0, "CurrScope", { fg = "#787f96" })

			--[[ local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level) ]]

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
	}),
}
