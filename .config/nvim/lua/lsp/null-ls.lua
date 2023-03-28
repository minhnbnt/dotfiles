local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local format_dir = os.getenv("HOME") .. "/.config/nvim/lua/lsp/formatter"
local notify = vim.notify

vim.notify = function(msg, ...)
	if msg:match("warning: multiple different client offset_encodings") then
		return
	end
	notify(msg, ...)
end

-- sources
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover
local completion = null_ls.builtins.completion

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier.with({
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote", "--use-tabs" },
		}),
		formatting.clang_format.with({
			extra_args = { "--style=file:" .. format_dir .. "/.clang-format" },
		}),
		formatting.yapf.with({
			extra_args = { "--style={ based_on_style = pep8, use_tabs = true }" },
		}),
		formatting.beautysh.with({ extra_args = { "-t", "-i 4" } }),
		formatting.stylua,

		completion.spell,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = augroup,
				buffer = bufnr,
				callback = function()
					if vim.bo.modified then
						vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 5000 })
					end
				end,
			})
		end
	end,
})
