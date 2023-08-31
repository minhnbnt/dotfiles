local function load(module)
	return function()
		require("plugins.lsp." .. module)
	end
end

return {

	{
		"neovim/nvim-lspconfig",

		dependencies = {
			"p00f/clangd_extensions.nvim",
			"mfussenegger/nvim-jdtls",
			"simrat39/rust-tools.nvim",
		},

		config = load("config"),
	},

	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = load("null-ls"),
	},

	{
		"hrsh7th/nvim-cmp",
		enabled = true,
		config = load("cmp"),

		dependencies = {
			--"onsails/lspkind.nvim",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"octaltree/cmp-look",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			--"hrsh7th/cmp-calc",
			--"f3fora/cmp-spell",
			--"hrsh7th/cmp-emoji",
			"saadparwaiz1/cmp_luasnip",
			"quangnguyen30192/cmp-nvim-tags",
			"ray-x/cmp-treesitter",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			--"hrsh7th/cmp-omni",
			--"hrsh7th/cmp-nvim-lsp-signature-help",
			--"hrsh7th/cmp-copilot",
			"zbirenbaum/copilot-cmp",
			--"tzachar/cmp-ai",
			--[[ {
				"tzachar/cmp-tabnine",
				build = "./install.sh",
			}, ]]
			--"SirVer/ultisnips",
			--"quangnguyen30192/cmp-nvim-ultisnips",
			--"dcampos/nvim-snippy",
			--"dcampos/cmp-snippy",
		},
	},
}
