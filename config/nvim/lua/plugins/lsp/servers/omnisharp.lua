return {

	cmd = {
		"mono",
		"$HOME/.local/bin/OmniSharp/OmniSharp.exe",
		"--languageserver",
		"--hostPID",
		tostring(vim.fn.getpid()),
	},

	root_dir = require("lspconfig").util.root_pattern("*.sln", "*.csproj", "project.json", ".git"),
}
