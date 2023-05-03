-- just comment out the servers you don't want to use
local servers = {
	"bashls",
	"ccls",
	--"clangd",
	"cmake",
	"cssls",
	"emmet_ls",
	"eslint",
	"gopls",
	"html",
	"jdtls",
	"jsonls",
	"rust_analyzer",
	"tailwindcss",
	"pyright",
	"lua_ls",
	--"vimls",
}

-- for servers that need custom config
local config = {
	ccls = {
		init_options = { index = { threads = 4 } },
		flags = { debounce_text_changes = 150 },
	},
	lua_ls = {
		settings = { Lua = { diagnostics = { globals = { "vim" } } } },
	},
	emmet_ls = {
		cmd = { "emmet-ls", "--stdio" },
		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
		init_options = { html = { options = { ["bem.enabled"] = true } } },
	},
	jdtls = {
		filetypes = { "java" },
		single_file_support = true,
		init_options = { jvm_args = {} },
		cmd = { "/usr/share/java/jdtls/bin/jdtls" }, -- AUR package jdtls
		--root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
	},
}

local signs = {
	Error = "",
	Warning = "",
	Warn = "",
	Hint = "",
	Information = "",
	Info = "",
}

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function() -- enable showing diagnostics in virtual text
		vim.diagnostic.open_float(0, { scope = "cursor", focus = false })
	end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
	update_in_insert = false,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.documentFormattingProvider = false

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

for type, icon in pairs(signs) do -- set signs
	-- local hl = "LspDiagnosticsSign" .. type
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- reqiure all servers
for _, lsp in pairs(servers) do
	if config[lsp] == nil then
		config[lsp] = {}
	end
	table.insert(config[lsp], {
		capabilities = capabilities,
		on_attach = on_attach,
	})
	if lsp == "jdtls" then -- jdtls requires special setup
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			callback = function()
				require("jdtls").start_or_attach(config.jdtls)
			end,
			pattern = "*.java",
		})
	else -- all other servers
		require("lspconfig")[lsp].setup(config[lsp])
	end
end
