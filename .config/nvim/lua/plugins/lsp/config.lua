local servers = {
	--"ccls",
	"clangd",
	"cmake",
	"cssls",
	--"emmet_ls",
	"emmet_language_server",
	"eslint",
	"gopls",
	"html",
	"jdtls",
	"jsonls",
	"omnisharp",
	--"ruff_lsp",
	"rust_analyzer",
	"svelte",
	--"tailwindcss",
	"typos_lsp",
	"tsserver",
	"pyright",
	"lua_ls",
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
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },

		keys = {
			{ "<leader>lr", "<cmd>LspRestart<cr>", desc = "LSP Rename" },
		},

		dependencies = {},

		opts = {

			inlay_hint = true,
			log_level = "off",

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
				local capabilities = vim.lsp.protocol.make_client_capabilities()
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

			for type, icon in pairs(opts.signs) do -- set signs
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl })
			end

			local vscode_extracted = { "html", "cssls", "eslint", "jsonls" }

			-- require all servers
			for _, server in pairs(servers) do
				local server_config = get_server_config(server)

				if
					not vim.tbl_contains(opts.custom_init, server) --
					and not vim.tbl_contains(vscode_extracted, server)
				then
					server_config.capabilities = capabilities
					lspconfig[server].setup(server_config)
				end
			end

			-- for some reason vscode_extracted servers need to be setup after all others
			for _, server in pairs(vscode_extracted) do
				if vim.tbl_contains(servers, server) then
					lspconfig[server].setup({
						capabilities = capabilities,
					})
				end
			end
		end,
	},
}
