require("code_runner").setup({
	mode = "term",
	startinsert = false,
	term = {
		position = "bot", -- Position to open the terminal, this option is ignored if mode is tab
		size = 6, -- Window size, this option is ignored if tab is true
	},
	-- put here the commands by filetype
	filetype = {
		c = {
			'cd "$dir" &&',
			"clang $fileName -lm -g3 -o $fileNameWithoutExt &&", -- -lm is for math.h, -g3 is for debugging
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&", -- if input.txt exists, run with it
			"./$fileNameWithoutExt < input.txt || ./$fileNameWithoutExt", -- else run without input
		},
		cpp = {
			'cd "$dir" &&',
			"clang++ $fileName -g3 -o $fileNameWithoutExt &&",
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"./$fileNameWithoutExt < input.txt || ./$fileNameWithoutExt",
		},
		go = {
			"cd $dir &&",
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"go run $fileName < input.txt || go run $fileName",
		},
		html = "cd $dir && live-server --open=$fileName",
		java = {
			'cd "$dir" && javac $fileName &&',
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"java $fileNameWithoutExt < input.txt || java $fileNameWithoutExt",
		},
		javascript = {
			"cd $dir &&",
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"node $fileName < input.txt || node $fileName",
		},
		lua = {
			"cd $dir &&",
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"lua $fileName < input.txt || lua $fileName",
		},
		asm = {
			'cd "$dir" &&',
			"nasm -f elf64 -o $fileNameWithoutExt.o $fileName &&", -- compile with nasm
			"ld -o $fileNameWithoutExt $fileNameWithoutExt.o &&", -- link with ld
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"./$fileNameWithoutExt < input.txt || ./$fileNameWithoutExt",
		},
		python = {
			"cd $dir &&",
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"python $fileName < input.txt || python $fileName",
		},
		rust = {
			'cd "$dir" && rustc $fileName &&',
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"./$fileNameWithoutExt < input.txt || ./$fileNameWithoutExt",
		},
		sh = {
			"cd $dir &&",
			"[[ -f input.txt ]] && echo 'Run with input.txt' &&",
			"bash $fileName < input.txt || bash $fileName",
		},
	},
})
