local servers = {
	--"bashls",
	--"ccls",
	"clangd",
	"cmake",
	"cssls",
	--"denols",
	--"emmet_ls",
	"emmet_language_server",
	"eslint",
	"gopls",
	"html",
	"jdtls",
	"jsonls",
	"omnisharp",
	"ruff_lsp",
	"rust_analyzer",
	--"tailwindcss",
	"typos_lsp",
	"tsserver",
	"pyright",
	"lua_ls",
	--"vimls",
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

	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile" },

	dependencies = {
		"p00f/clangd_extensions.nvim",
		"mfussenegger/nvim-jdtls",
		"ranjithshegde/ccls.nvim",
	},

	config = function(_, opts)
		local init = opts.init
		local capabilities = opts.capabilities()

		vim.diagnostic.config(opts.diagnostic)
		vim.lsp.set_log_level(opts.log_level)

		for type, icon in pairs(opts.signs) do -- set signs
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl })
		end

		local vscode_extracted = { "html", "cssls", "eslint", "jsonls" }

		-- require all servers
		for _, server in pairs(servers) do
			local config = get_server_config(server)

			if init[server] ~= nil then
				init[server](config)
			elseif not vim.tbl_contains(vscode_extracted, server) then
				config.capabilities = capabilities

				require("lspconfig")[server].setup(config)
			end
		end

		-- for some reason vscode_extracted servers need to be setup after all others
		for _, server in pairs(vscode_extracted) do
			if vim.tbl_contains(servers, server) then
				require("lspconfig")[server].setup({
					capabilities = capabilities,
				})
			end
		end
	end,

	opts = {

		log_level = "off",

		signs = {
			Error = "",
			Warn = "",
			Hint = "",
			Info = "",
		},

		init = {
			ccls = function(opts)
				require("ccls").setup(opts)
			end,
			clangd = function(opts)
				require("lspconfig")["clangd"].setup(opts.server)
				require("clangd_extensions").setup(opts.extensions)
			end,
			jdtls = function(opts)
				vim.api.nvim_create_autocmd("Filetype", {
					pattern = { "java" },
					callback = function()
						require("jdtls").start_or_attach(opts)
					end,
				})
			end,
			rust_analyzer = function(opts)
				vim.g.rustaceanvim = opts
			end,
		},

		diagnostic = {

			float = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
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
}
