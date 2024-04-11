return {
	server = {
		on_attach = function(client, bufnr)
			local clang_inlay = require("clangd_extensions.inlay_hints")

			clang_inlay.setup_autocmd()
			clang_inlay.set_inlay_hints()
		end,

		capabilities = {
			textDocument = { completion = { editsNearCursor = true } },
			offsetEncoding = {},
		},
	},
}
