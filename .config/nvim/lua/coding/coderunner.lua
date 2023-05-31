local function get_command(compile, run)
	if compile == nil or compile == "" then
		compile = ""
	else
		compile = compile .. " && "
	end
	return {
		"ulimit -d 524288;", -- limit memory to 512MB
		'cd "$dir" && ' .. compile .. "if [[ -f input.txt ]];", -- check if input.txt exists
		'then cat input.txt && read -p "Run with input.txt? [Y/n]: " answer;', -- ask if user wants to run with input.txt
		'while [[ $answer != [yYnN] ]]; do read -p "Invalid option: " answer; done;', -- check if answer is valid
		"if [[ $answer == [yY] ]]; then clear;" .. run .. " < input.txt;", -- run with input.txt
		"else clear;" .. run .. "; fi; else " .. run .. "; fi", -- run without input.txt
	}
end

require("code_runner").setup({
	mode = "term",
	startinsert = false,
	term = {
		position = "bot", -- Position to open the terminal, this option is ignored if mode is tab
		size = 6, -- Window size, this option is ignored if tab is true
	},
	-- put here the commands by filetype
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
})
