require("luasnip").add_snippets(nil, {
	html = require("lsp.snippet.html"),
	cpp = require("lsp.snippet.cpp"),
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

require("luasnip").filetype_extend("all", { "_" })
