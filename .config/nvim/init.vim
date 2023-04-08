if exists('g:vscode')
    lua require("vscbootstrap")
else
    lua require("options")
	lua require("plug")
endif
