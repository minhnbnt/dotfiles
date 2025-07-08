local servers = {
	"ansiblels",
	"basedpyright",
	--"ccls",
	"clangd",
	"cmake",
	"cssls",
	--"emmet_ls",
	"emmet_language_server",
	"eslint",
	"gopls",
	"html",
	--"jdtls",
	"jsonls",
	--"kotlin_language_server",
	"lua_ls",
	--"omnisharp",
	"nixd",
	"ruff",
	"rust_analyzer",
	"svelte",
	"tailwindcss",
	"terraformls",
	"typos_lsp",
	"vtsls",
	"yamlls",
}

local function get_server_config(server_name)
	local mod_name = "plugins.lsp.servers." .. server_name
	local ok, config = pcall(require, mod_name)

	if not ok then
		return {}
	end

	return config
end

return {

	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },

		enabled = function()
			return vim.tbl_contains(servers, "clangd")
		end,

		opts = function()
			return get_server_config("clangd")
		end,

		config = function(_, opts)
			require("lspconfig")["clangd"].setup(opts.server)
			require("clangd_extensions").setup(opts.extensions)
		end,
	},

	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },

		enabled = function()
			return vim.tbl_contains(servers, "jdtls")
		end,

		init = function()
			vim.api.nvim_create_autocmd("Filetype", {
				pattern = { "java" },
				callback = function()
					local opts = get_server_config("jdtls")
					require("jdtls").start_or_attach(opts)
				end,
			})
		end,
	},

	{
		"ranjithshegde/ccls.nvim",
		ft = { "c", "cpp", "objc", "objcpp", "cuda" },

		enabled = function()
			return vim.tbl_contains(servers, "ccls")
		end,

		opts = function()
			return get_server_config("ccls")
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "*",
		ft = { "rust" },
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },

		keys = {
			{ "<leader>lr", "<cmd>LspRestart<cr>", desc = "LSP Restart" },
			{
				"<leader>li",
				function()
					local is_enabled = vim.lsp.inlay_hint.is_enabled()
					vim.lsp.inlay_hint.enable(not is_enabled)
				end,
				desc = "LSP toggle inlay hints",
			},
		},

		dependencies = {},

		opts = {

			inlay_hint = false,
			log_level = "info",

			signs = {
				Error = "",
				Warn = "",
				Hint = "",
				Info = "",
			},

			custom_init = {
				"ccls",
				"clangd",
				"jdtls",
				"rust_analyzer",
			},

			diagnostic = {

				float = {
					focusable = false,
					close_events = {
						"BufLeave",
						"CursorMoved",
						"InsertEnter",
						"FocusLost",
					},
					border = "rounded",
					source = "always",
					prefix = " ",
				},

				virtual_text = {
					format = function(diagnostic)
						local max_len = 50

						local first_line = diagnostic.message:match("[^\n]+")

						if first_line:len() > max_len then
							return first_line:sub(1, max_len - 3) .. "..."
						end

						return first_line
					end,
				},

				underline = true,
				update_on_insert = false,
				severity_sort = true,
			},

			capabilities = function()
				local capabilities = require("cmp_nvim_lsp").default_capabilities()
				capabilities.textDocument.documentFormattingProvider = false
				capabilities.textDocument.completion.completionItem.snippetSupport = true

				return capabilities
			end,

			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
		},

		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local capabilities = opts.capabilities()

			vim.diagnostic.config(opts.diagnostic)
			vim.lsp.set_log_level(opts.log_level)
			vim.lsp.inlay_hint.enable(opts.inlay_hint)

			for type, icon in vim.iter(opts.signs) do -- set signs
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl })
			end

			local vscode_extracted = { "html", "cssls", "eslint", "jsonls" }

			vim.iter(servers)
				:filter(function(server)
					return not vim.tbl_contains(opts.custom_init, server)
						and not vim.tbl_contains(vscode_extracted, server)
				end)
				:map(function(server)
					local config = get_server_config(server)
					config.capabilities = capabilities

					return server, config
				end)
				:each(function(server, config)
					lspconfig[server].setup(config)
				end)

			-- for some reason vscode_extracted servers need to be setup after all others
			vim.iter(vscode_extracted)
				:filter(function(server)
					return vim.tbl_contains(servers, server)
				end)
				:each(function(server)
					lspconfig[server].setup({ capabilities = capabilities })
				end)
		end,
	},
}
