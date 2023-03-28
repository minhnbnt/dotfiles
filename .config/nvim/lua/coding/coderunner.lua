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
		c = 'cd "$dir" && clang $fileName -lm -o $fileNameWithoutExt && ./$fileNameWithoutExt',
		cpp = 'cd "$dir" && clang++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
		go = "cd $dir && go run $fileName",
		html = "cd $dir && live-server --open=$fileName",
		java = 'cd "$dir" && javac $fileName && java $fileNameWithoutExt',
		javascript = "node",
		lua = "lua",
		nasm = 'cd "$dir" && nasm -f elf64 -o $fileNameWithoutExt.o $fileName && ld -o $fileNameWithoutExt $fileNameWithoutExt.o && ./$fileNameWithoutExt',
		python = "python3 -u",
		rust = "cd $dir && rustc $fileName && ./$fileNameWithoutExt",
		sh = "cd $dir && sh $fileName",
	},
	--[[
	project = {
		["~/code"] = {
			name = "For exam",
			file_name = "main.c",
			description = "Project with program use input file",
			command = "cd $dir && clang $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt < input.txt",
		},
	},
  ]]
})
