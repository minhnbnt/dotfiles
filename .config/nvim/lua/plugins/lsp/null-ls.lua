local M = {

	"nvimtools/none-ls.nvim",
	commit = "2236d2b",
	event = { "BufReadPost", "BufNewFile" },

	dependencies = {
		-- "nvimtools/none-ls-extras.nvim",
	},
}

local config = {
	clang_format = {
		AccessModifierOffset = -4,
		AlwaysBreakTemplateDeclarations = "Yes",
		AllowShortBlocksOnASingleLine = "Empty",
		AllowShortFunctionsOnASingleLine = "Empty",
		AllowShortIfStatementsOnASingleLine = "AllIfsAndElse",
		AllowShortLoopsOnASingleLine = true,
		Cpp11BracedListStyle = false,
		EmptyLineAfterAccessModifier = "Leave",
		EmptyLineBeforeAccessModifier = "Leave",
		IncludeBlocks = "Regroup",
		IndentAccessModifiers = false,
		IndentWidth = 4,
		TabWidth = 4,
		UseTab = "ForIndentation",
	},
	rustfmt = function()
		local config = {
			hard_tabs = true,
			tab_spaces = 4,
			brace_style = "PreferSameLine",
			format_strings = true,
			spaces_around_ranges = true,
		}
		local rtn = {}
		for k, v in pairs(config) do
			table.insert(rtn, string.format("%s=%s", k, v))
		end
		return table.concat(rtn, ",")
	end,
}

function M.init()
	vim.g.nonels_suppress_issue58 = true
end

M.opts = function()
	local null_ls = require("null-ls")
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	local code_actions = null_ls.builtins.code_actions
	local diagnostics = null_ls.builtins.diagnostics
	local formatting = null_ls.builtins.formatting
	local hover = null_ls.builtins.hover
	local completion = null_ls.builtins.completion

	return {
		debug = false,
		sources = {

			--diagnostics.codespell,
			diagnostics.typos,

			formatting.shfmt,
			formatting.clang_format.with({
				extra_args = { "--style=" .. vim.fn.json_encode(config.clang_format) },
			}),
			formatting.gofmt,
			formatting.prettier.with({ extra_filetypes = { "svelte" } }),
			formatting.rustfmt.with({ extra_args = { "--config=" .. config.rustfmt() } }),
			formatting.stylua,
			formatting.ruff_format,
			formatting.isort,

			hover.dictionary,
		},

		on_attach = function(client, bufnr)
			if not client.supports_method("textDocument/formatting") then
				return
			end
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(server)
							return server.name == "null-ls"
						end,
						timeout_ms = 5000,
						bufnr = bufnr,
					})
				end,
			})
		end,
	}
end

return M
