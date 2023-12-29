local M = {}

M.enabled_plugins = {

	"Mofiqul/vscode.nvim",
	--"catppuccin/nvim",

	"CRAG666/code_runner.nvim",
	"windwp/nvim-autopairs",
	"numToStr/Comment.nvim",
	"lukas-reineke/indent-blankline.nvim",
	"michaelb/sniprun",

	"goolord/alpha-nvim",

	"kevinhwang91/nvim-ufo",

	"mfussenegger/nvim-dap",
	"rcarriga/nvim-dap-ui",

	"neovim/nvim-lspconfig",
	"ray-x/lsp_signature.nvim",
	"mrcjkb/rustaceanvim",
	"L3MON4D3/LuaSnip",
	"nvimtools/none-ls.nvim",
	"zbirenbaum/copilot.lua",
	"hrsh7th/nvim-cmp",

	"nvim-telescope/telescope.nvim",
	"nvim-tree/nvim-tree.lua",

	"HiPhish/rainbow-delimiters.nvim",
	"nvim-treesitter/nvim-treesitter",

	"folke/which-key.nvim",
	"rcarriga/nvim-notify",
	"folke/noice.nvim",
	"nvim-lualine/lualine.nvim",
	"akinsho/bufferline.nvim",
	"luukvbaal/statuscol.nvim",
	"lewis6991/gitsigns.nvim",
}

M.lsp_servers = {

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
	"tailwindcss",
	"tsserver",
	"pyright",
	"lua_ls",
	--"vimls",
}

return M
