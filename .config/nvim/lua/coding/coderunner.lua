require("code_runner").setup({
	mode = "term",
	term = {
		--  Position to open the terminal, this option is ignored if mode is tab
		position = "bot",
		-- window size, this option is ignored if tab is true
		size = 4,
	},
	-- put here the commands by filetype
	filetype = {
		nasm = "nasm -f elf64 -o $fileNameWithoutExt.o $fileName && ld -o $fileNameWithoutExt $fileNameWithoutExt.o && ./$fileNameWithoutExt",
		cpp = 'cd "$dir" && clang++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
		c = 'cd "$dir" && clang $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
		java = 'cd "$dir" && javac $fileName && java $fileNameWithoutExt',
		rust = "cd $dir && rustc $fileName && ./$fileNameWithoutExt",
		html = "cd $dir && live-server --open=$fileName",
		sh = "cd $dir && sh $fileName",
		python = "python3 -u",
		javascript = "node",
		lua = "lua",
	},
	project = {
		--[[["~/Templates"] = {
			name = "For exam",
			description = "Project with program use input file",
			command = "deno run --allow-net",
		},]]
	},
})
