local servers = {
	"bashls",
	"ccls",
	--"clangd",
	"cmake",
	"cssls",
	"emmet_ls",
	"eslint",
	"html",
	"jsonls",
	"tailwindcss",
	"pyright",
	--"sumneko_lua",
	"vimls",
}

local config = {
	clangd = {
		cmd = { "clangd", "--background-index=0", "--suggest-missing-includes", "--clang-tidy=0" },
	},
	sumneko_lua = {
		settings = { Lua = { diagnostics = { globals = { "vim" } } } },
	},
	emmet_ls = {
		cmd = { "emmet-ls", "--stdio" },
		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
		init_options = {
			html = {
				options = {
					["bem.enabled"] = true,
				},
			},
		},
	},
}

local signs = {
	Error = "x",
	Warning = "!",
	Warn = "!",
	Hint = "",
	Information = "i",
	Info = "i",
}

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(0, { scope = "cursor", focus = false })
	end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
	update_in_insert = false,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities = {
	--offsetEncoding = { "utf-16" },
	--documentFormattingProvider = false
	textDocument = {
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		},
		completion = {
			completionItem = {
				snippetSupport = true,
			},
		},
	},
}

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

for type, icon in pairs(signs) do
	local hl = "LspDiagnosticsSign" .. type
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

for _, lsp in pairs(servers) do
	if config[lsp] == nil then
		config[lsp] = {}
	end
	table.insert(config[lsp], {
		capabilities = capabilities,
		on_attach = on_attach,
	})
	require("lspconfig")[lsp].setup(config[lsp])
end
