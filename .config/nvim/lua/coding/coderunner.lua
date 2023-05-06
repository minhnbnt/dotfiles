local function get_command(compile, run)
	if compile == nil then
		compile = ""
	else
		compile = compile .. " && "
	end
	return {
		'cd "$dir" && ' .. compile .. "[[ -f input.txt ]] && {",
		'cat input.txt && read -p "Run with input.txt? [Y/n]: " answer;',
		'while [[ $answer != [yYnN] ]]; do read -p "Invalid option [Y/N]: " answer; done;',
		"[[ $answer == [yY] ]] && { " .. run .. " < input.txt; } ||",
		"{ " .. run .. '; } } || { echo "Ready."; ' .. run .. "; }",
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
		go = get_command(nil, "go run $fileName"),
		html = "cd $dir && live-server --open=$fileName",
		java = get_command("javac $fileName", "java $fileNameWithoutExt"),
		javascript = get_command(nil, "node $fileName"),
		lua = get_command(nil, "lua $fileName"),
		python = get_command(nil, "python $fileName"),
		rust = get_command("rustc $fileName", "./$fileNameWithoutExt"),
		sh = get_command(nil, "bash $fileName"),
	},
})
