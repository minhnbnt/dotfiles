local newFormatter = require("utils.formatOnSave")
local temp_dir = vim.fn.stdpath("state") .. "/none-ls"

local M = {

	"nvimtools/none-ls.nvim",
	event = { "BufReadPost", "BufNewFile" },

	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
}

local config = {
	clang_format = function()
		local opts = {
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
		}

		return vim.fn.json_encode(opts)
	end,
	rustfmt = function()
		local opts = {
			hard_tabs = true,
			tab_spaces = 4,
			brace_style = "PreferSameLine",
			format_strings = true,
			spaces_around_ranges = true,
		}

		return vim.iter(opts)
			:map(function(k, v)
				return ("%s=%s"):format(k, v)
			end)
			:join(",")
	end,
}

function M.init()
	vim.g.nonels_suppress_issue58 = true

	if vim.fn.isdirectory(temp_dir) == 0 then
		vim.fn.mkdir(temp_dir, "p")
	end

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		pattern = "*.py",
		callback = function()
			local file_path = vim.fn.expand("%:p")
			local file_exists = vim.loop.fs_stat(file_path) ~= nil

			if not file_exists then
				vim.cmd("w")
			end
		end,
	})
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

			--formatting.biome,

			formatting.shfmt,
			formatting.clang_format.with({ extra_args = { "--style=" .. config.clang_format() } }),
			formatting.gofmt,
			formatting.prettier.with({ extra_filetypes = { "svelte" } }),
			require("none-ls.formatting.rustfmt").with({ extra_args = { "--config=" .. config.rustfmt() } }),
			formatting.stylua,

			formatting.nixfmt,

			--[[
			diagnostics.mypy.with({
				extra_args = function()
					local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
					return { "--python-executable", virtual .. "/bin/python3" }
				end,
				temp_dir = temp_dir,
			}),
			]]

			diagnostics.golangci_lint,

			hover.dictionary,
		},

		on_attach = function(client, bufnr)
			newFormatter(client, bufnr)
		end,
	}
end

return M
