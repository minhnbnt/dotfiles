require("code_runner").setup({
	mode = "term",
	startinsert = false,
	term = {
		position = "bot", -- Position to open the terminal, this option is ignored if mode is tab
		size = 6, -- Window size, this option is ignored if tab is true
	},
	-- put here the commands by filetype
	filetype = {
		asm = {
			'cd "$dir" &&',
			"nasm -f elf64 -o $fileNameWithoutExt.o $fileName &&", -- compile with nasm
			"ld -o $fileNameWithoutExt $fileNameWithoutExt.o &&", -- link to create the executable
			"[[ ! -f input.txt ]] && ./$fileNameWithoutExt || {", -- if input.txt doesn't exist, run the program
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&", -- some message
			"./$fileNameWithoutExt < input.txt }", -- run the program with input.txt
		},
		c = {
			'cd "$dir" &&',
			"clang $fileName -lm -g3 -o $fileNameWithoutExt &&", -- -lm is for math.h, -g3 is for lldb
			"[[ ! -f input.txt ]] && ./$fileNameWithoutExt || {",
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"./$fileNameWithoutExt < input.txt }",
		},
		cpp = {
			'cd "$dir" &&',
			"clang++ $fileName -g3 -o $fileNameWithoutExt &&",
			"[[ ! -f input.txt ]] && ./$fileNameWithoutExt || {",
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"./$fileNameWithoutExt < input.txt }",
		},
		go = {
			'cd "$dir" &&',
			"[[ ! -f input.txt ]] && go run $fileName || {",
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"go run $fileName < input.txt }",
		},
		html = "cd $dir && live-server --open=$fileName",
		java = {
			'cd "$dir" && javac $fileName &&', -- compile with javac from jdk
			"[[ ! -f input.txt ]] && java $fileNameWithoutExt || {", -- run class file
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"java $fileNameWithoutExt < input.txt }",
		},
		javascript = {
			'cd "$dir" &&',
			"[[ ! -f input.txt ]] && node $fileName || {",
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"node $fileName < input.txt }",
		},
		lua = {
			'cd "$dir" &&',
			"[[ ! -f input.txt ]] && lua $fileName || {",
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"lua $fileName < input.txt }",
		},
		python = {
			'cd "$dir" &&',
			"[[ ! -f input.txt ]] && python3 $fileName || {",
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"python3 $fileName < input.txt }",
		},
		rust = {
			'cd "$dir" && rustc $fileName &&',
			"[[ ! -f input.txt ]] && ./$fileNameWithoutExt || {",
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"./$fileNameWithoutExt < input.txt }",
		},
		sh = {
			'cd "$dir" &&',
			"[[ ! -f input.txt ]] && bash $fileName || {",
			"echo 'Run with input.txt:' && cat input.txt && echo '------------' &&",
			"bash $fileName < input.txt }",
		},
	},
})
