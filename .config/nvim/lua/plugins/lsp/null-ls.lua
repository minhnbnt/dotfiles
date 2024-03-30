local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
	--[[yapf = function()
		local config = {
			based_on_style = "pep8",
			column_limit = 100,
			indent_width = 4,
			use_tabs = true,
		}
		local rtn = {}
		for k, v in pairs(config) do
			table.insert(rtn, string.format("%s: %s", k, v))
		end
		return "{ " .. table.concat(rtn, ", ") .. " }"
	end,]]
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

-- sources
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover
local completion = null_ls.builtins.completion

null_ls.setup({
	debug = false,
	sources = {

		formatting.shfmt,
		formatting.clang_format.with({ extra_args = { "--style=" .. vim.fn.json_encode(config.clang_format) } }),
		formatting.gofmt,
		formatting.prettier,
		require("none-ls.formatting.rustfmt"),
		formatting.stylua,
		formatting.black,
		formatting.isort,

		completion.spell,

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
})
