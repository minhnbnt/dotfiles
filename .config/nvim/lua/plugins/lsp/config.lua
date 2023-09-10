-- just comment out the servers you don't want to use
local servers = {
	"bashls",
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
	"rust_analyzer",
	"tailwindcss",
	"tsserver",
	"pyright",
	"lua_ls",
	--"vimls",
}

-- for servers that need custom setup function(opts)
local init = {
	-- ccls = require("ccls").setup,
	clangd = function(opts)
		require("lspconfig")["clangd"].setup(opts.server)
		require("clangd_extensions").setup(opts.extensions)
	end,
	jdtls = function(opts)
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = "*.java",
			callback = function()
				require("jdtls").start_or_attach(opts)
			end,
		})
	end,
	rust_analyzer = require("rust-tools").setup,
}

local signs = {
	Error = "",
	Warning = "",
	Warn = "",
	Hint = "",
	Information = "",
	Info = "",
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.documentFormattingProvider = false
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)
end

-- for servers that need custom config
local config = {
	ccls = {
		init_options = { index = { threads = 0 } },
		flags = { debounce_text_changes = 150 },
	},
	clangd = {
		extensions = { inlay_hints = { show_parameter_hints = false } },
		server = {
			capabilities = {
				textDocument = { completion = { editsNearCursor = true } },
				offsetEncoding = {},
			},
			on_attach = on_attach,
		},
	},
	lua_ls = {
		settings = { Lua = { diagnostics = { globals = { "vim" } } } },
	},
	emmet_ls = {
		cmd = { "emmet-ls", "--stdio" },
		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
		init_options = { html = { options = { ["bem.enabled"] = true } } },
	},
	emmet_language_server = {
		init_options = {
			--- @type table<string, any> https://docs.emmet.io/customization/preferences/
			preferences = {},
			--- @type "always" | "never" defaults to `"always"`
			showexpandedabbreviation = "always",
			--- @type boolean defaults to `true`
			showabbreviationsuggestions = true,
			--- @type boolean defaults to `false`
			showsuggestionsassnippets = true,
			--- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
			syntaxprofiles = {},
			--- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
			variables = {},
			--- @type string[]
			excludelanguages = {},
		},
	},
	jdtls = {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)

			-- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
			-- you make during a debug session immediately.
			-- Remove the option if you do not want that.
			-- You can use the `JdtHotcodeReplace` command to trigger it manually
			require("jdtls.dap").setup_dap_main_class_configs()
			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("jdtls.setup").add_commands()
		end,
		capabilities = capabilities,
		filetypes = { "java" },
		single_file_support = true,
		init_options = {
			bundles = { "/usr/share/java-debug/com.microsoft.java.debug.plugin.jar" },
			jvm_args = { "-Xmx500M" },
		},
		cmd = { "/usr/share/java/jdtls/bin/jdtls" }, -- AUR package jdtls
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
	},
	rust_analyzer = {
		server = {
			standalone = true,
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					imports = { granularity = { group = "module" }, prefix = "self" },
					cargo = { buildScripts = { enable = true } },
					procMacro = { enable = true },
				},
			},
		},
	},
}

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function() -- enable showing diagnostics in virtual text
		vim.diagnostic.open_float(0, { scope = "cursor", focus = false })
	end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = --
	vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		update_in_insert = false,
	})

for type, icon in pairs(signs) do -- set signs
	-- local hl = "LspDiagnosticsSign" .. type
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local vscode_extracted = { "html", "cssls", "eslint", "jsonls" }

-- reqiure all servers
for _, server in pairs(servers) do
	if config[server] == nil then
		config[server] = {}
	end
	if init[server] ~= nil then
		-- if server needs custom init options
		init[server](config[server])
	elseif not vim.tbl_contains(vscode_extracted, server) then
		table.insert(config[server], {
			capabilities = capabilities,
			on_attach = on_attach,
		})
		require("lspconfig")[server].setup(config[server])
	end
end

-- for some reason vscode_extracted servers need to be setup after all others
for _, server in pairs(vscode_extracted) do
	if vim.tbl_contains(servers, server) then
		require("lspconfig")[server].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end
end
