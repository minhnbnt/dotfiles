local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local config = {
	clang_format = {
		AllowShortBlocksOnASingleLine = "Empty",
		AllowShortIfStatementsOnASingleLine = "AllIfsAndElse",
		AllowShortLoopsOnASingleLine = true,
		ColumnLimit = 70,
		IncludeBlocks = "Regroup",
		IndentWidth = 4,
		TabWidth = 4,
		UseTab = "AlignWithSpaces",
	},
	yapf = {
		based_on_style = "pep8",
		column_limit = 70,
		continuation_indent_width = 4,
		indent_width = 4,
		use_tabs = true,
	},
}

-- sources
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover
local completion = null_ls.builtins.completion

null_ls.setup({
	debug = false,
	sources = {
		code_actions.gitsigns,

		formatting.prettier.with({ extra_args = { "--use-tabs" } }),
		formatting.clang_format.with({ extra_args = { "--style=" .. vim.fn.json_encode(config.clang_format) } }),
		formatting.yapf.with({ extra_args = { "--style=" .. vim.fn.json_encode(config.yapf) } }),
		formatting.beautysh.with({ extra_args = { "-t", "-i 4" } }),
		formatting.stylua,

		completion.spell,

		hover.dictionary,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = augroup,
				buffer = bufnr,
				callback = function()
					if vim.bo.modified then
						vim.lsp.buf.format({
							bufnr = bufnr,
							timeout_ms = 5000,
						})
					end
				end,
			})
		end
	end,
})
