local function ensure_packer()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost packers.lua source <afile> | PackerCompile
	augroup end
]])

return require("packer").startup(function(use)
	--Plugin here
	use("wbthomason/packer.nvim")

	use("kyazdani42/nvim-web-devicons")

	use("antoinemadec/FixCursorHold.nvim")

	use("kyazdani42/nvim-tree.lua")

	use({
		"akinsho/bufferline.nvim",
		tag = "v3.*",
		requires = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
	})

	use("neovim/nvim-lspconfig")
	--use("williamboman/mason.nvim")
	--use("williamboman/mason-lspconfig.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("ray-x/lsp_signature.nvim")
	use("github/copilot.vim")
	--use("zbirenbaum/copilot.lua")

	use("windwp/nvim-autopairs")

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.x",
		requires = {
			"nvim-lua/plenary.nvim",
			--"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"ahmedkhalf/project.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
	})

	--use("lewis6991/gitsigns.nvim")

	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })

	use("lukas-reineke/indent-blankline.nvim")

	use({
		"folke/noice.nvim",
		requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
	})
	use("nvim-lualine/lualine.nvim")
	--use("nvim-lua/lsp-status.nvim")
	--use("arkav/lualine-lsp-progress")

	--use("petertriho/nvim-scrollbar")

	use("Mofiqul/vscode.nvim")
	use("folke/tokyonight.nvim")
	--use("Mofiqul/dracula.nvim")
	--use("chriskempson/base16-vim")

	use("CRAG666/code_runner.nvim")

	use("goolord/alpha-nvim")
	--use("glepnir/dashboard-nvim")

	--use("sheerun/vim-polyglot")
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"windwp/nvim-ts-autotag",
			"p00f/nvim-ts-rainbow",
		},
	})

	use("norcalli/nvim-colorizer.lua")

	use("nathom/filetype.nvim")

	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")

	use("rafamadriz/friendly-snippets")
	use("honza/vim-snippets")
	use({
		"hrsh7th/nvim-cmp",
		requires = {
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
			--"hrsh7th/cmp-omni",
			--"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-copilot",
			--"zbirenbaum/copilot-cmp",
			--{
			--	"tzachar/cmp-tabnine",
			--	run = "./install.sh",
			--},
			{
				"L3MON4D3/LuaSnip",
				run = "make install_jsregexp",
			},
			--"SirVer/ultisnips",
			--"quangnguyen30192/cmp-nvim-ultisnips",
			--"dcampos/nvim-snippy",
			--"dcampos/cmp-snippy",
		},
	})

	--use("dstein64/vim-startuptime")

	if ensure_packer() then
		require("packer").sync()
	end
end)
