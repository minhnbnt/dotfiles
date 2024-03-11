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
	"omnisharp",
	"rust_analyzer",
	--"tailwindcss",
	"tsserver",
	"pyright",
	"lua_ls",
	--"vimls",
}

-- for servers that need custom setup function(opts)
local init = {
	ccls = require("ccls").setup,
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
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.documentFormattingProvider = false
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.set_log_level("off")

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { scope = "cursor" })
	end,
})

vim.diagnostic.config({

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

	update_in_insert = false,
	severity_sort = true,
})

-- for servers that need custom config
local config = {
	ccls = {
		lsp = {
			use_defaults = true,
			server = {
				init_options = {
					index = { threads = 4 },
					completion = { placeholder = false },
				},
				flags = { debounce_text_changes = 150 },
			},
		},
	},
	clangd = {
		server = {
			on_attach = function(client, bufnr)
				local clang_inlay = require("clangd_extensions.inlay_hints")

				clang_inlay.setup_autocmd()
				clang_inlay.set_inlay_hints()
			end,
			capabilities = {
				textDocument = { completion = { editsNearCursor = true } },
				offsetEncoding = {},
			},
		},
	},
	lua_ls = {
		settings = { Lua = {
			telemetry = { enable = false },
			diagnostics = { globals = { "vim" } },
		} },
	},
	emmet_ls = {
		cmd = { "emmet-ls", "--stdio" },
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
	eslint = { settings = { quiet = true } },
	jdtls = {
		on_attach = function(client, bufnr)
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
			jvm_args = { "-Xmx1G" },
		},
		settings = {
			java = {
				signatureHelp = { enabled = true },
				contentProvider = { preferred = "fernflower" },
			},
		},
		cmd = { "/usr/share/java/jdtls/bin/jdtls" }, -- AUR package jdtls
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
		on_init = function(client)
			if not client.config.settings then
				return
			end
			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end,
	},
	omnisharp = {
		cmd = {
			"mono",
			"/home/minhnbnt/.local/bin/OmniSharp/OmniSharp.exe",
			"--languageserver",
			"--hostPID",
			tostring(vim.fn.getpid()),
		},
		root_dir = require("lspconfig").util.root_pattern("*.sln", "*.csproj", "project.json", ".git"),
	},
	pylyzer = {
		on_attach = function(client, bufnr)
			client.server_capabilities.semanticTokensProvider = nil
		end,
		settings = {
			python = {
				checkOnType = true,
				inlayHints = false,
			},
		},
	},
	rust_analyzer = {
		server = {
			standalone = true,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					cargo = { allFeatures = true },
					check = { command = "clippy" },
					diagnostics = { experimental = true },
				},
			},
		},
	},
}

local signs = {
	Error = "",
	Warn = "",
	Hint = "",
	Info = "",
}

for type, icon in pairs(signs) do -- set signs
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

local vscode_extracted = { "html", "cssls", "eslint", "jsonls" }

-- require all servers
for _, server in pairs(servers) do
	if config[server] == nil then
		config[server] = {}
	end
	if init[server] ~= nil then -- if server needs custom init options
		init[server](config[server])
	elseif not vim.tbl_contains(vscode_extracted, server) then
		config[server].capabilities = capabilities

		require("lspconfig")[server].setup(config[server])
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
