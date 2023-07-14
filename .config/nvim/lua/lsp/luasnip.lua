local luasnip = require("luasnip")

luasnip.add_snippets(nil, {
	html = require("lsp.snippet.html"),
	c = require("lsp.snippet.c"),
	cpp = require("lsp.snippet.cpp"),
})

luasnip.filetype_extend("all", { "_" })
luasnip.filetype_extend("cpp", { "c" })

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
