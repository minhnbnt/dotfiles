local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return function(client, bufnr)
	if not client:supports_method("textDocument/formatting") then
		return
	end

	vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		group = augroup,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({
				filter = function(server)
					return server.name == client.name
				end,

				timeout_ms = 5000,
				bufnr = bufnr,
			})
		end,
	})
end
