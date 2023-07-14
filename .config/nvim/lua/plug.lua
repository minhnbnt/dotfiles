local function load(module)
	local enable_notifications = true -- Enable notifications for errors
	if not pcall(require, module) and enable_notifications then -- If not run correctly, notify the user
		vim.notify("Error loading module: " .. module, vim.log.levels.ERROR, { title = "plug.lua" })
	end
end

load("packers")

load("ui.vscodetheme")
--load("ui.base16")
--load("ui.tokyonight")
--load("ui.dracula")
load("ui.alpha")
load("ui.lualine")
load("ui.bufferline")
load("ui.devicons")
load("ui.notify")
load("ui.noice")
--load("ui.dashboard")
--load("ui.scrollbar")
load("ui.statuscol")

load("lsp.cmp")
load("lsp.copilot")
load("lsp.lspconfig")
load("lsp.mason")
load("lsp.null-ls")
load("lsp.signature")
load("lsp.luasnip")

load("coding.autopairs")
load("coding.dap")
load("coding.ufo")
load("coding.coderunner")
load("coding.treesitter")
load("coding.identblankline")
load("coding.comment")
--load("coding.filetype")
load("coding.gitsigns")

load("browser.project")
load("browser.telescope")
load("browser.nvimtree")
