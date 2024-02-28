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
			"ranjithshegde/ccls.nvim",
		},

		config = load("config"),
	},

	{
		"mrcjkb/rustaceanvim",
		version = "*",
		ft = { "rust" },
	},

	{
		"ray-x/lsp_signature.nvim",

		enabled = true,

		opts = {
			bind = true,
			max_height = 15,
			max_width = 80,
			always_trigger = true,
			handler_opts = { border = "rounded" },
			hint_prefix = " ",
		},
	},

	{
		"L3MON4D3/LuaSnip",

		dependencies = {
			"rafamadriz/friendly-snippets",
			"honza/vim-snippets",
		},

		version = "*",
		build = "make install_jsregexp",
		config = load("luasnip"),
	},

	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = load("null-ls"),
	},

	{
		"zbirenbaum/copilot.lua",
		enabled = false,

		cmd = "Copilot",
		event = "InsertEnter",

		dependencies = { "zbirenbaum/copilot-cmp" },
		config = load("copilot"),
	},

	{
		"hrsh7th/nvim-cmp",

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
