local M = {

	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },

	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"ray-x/cmp-treesitter",
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
	},
}

local kind_icons = {
	Copilot = "",
	Text = "",
	Method = "m",
	Function = "󰊕",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰅲",
	TabNine = "",
}

local source_icons = {
	nvim_lsp = "",
	luasnip = "",
	tags = "",
	buffer = "",
	path = "",
	emoji = "",
	omni = "",
	calc = "",
	spell = "",
	look = "",
	cmp_tabnine = "",
	treesitter = "",
	copilot = "",
	cmdline = "",
	nvim_lua = "",
}

function M.init()
	vim.cmd("hi CmpItemMenu cterm=bold gui=bold")
	vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#04A5E5" })
	vim.api.nvim_set_hl(0, "CmpItemKindTabNine", { fg = "#f397f7" })
end

function M.config()
	local cmp, luasnip = require("cmp"), require("luasnip")
	local defaults = require("cmp.config.default")()

	require("luasnip.loaders.from_vscode").lazy_load()

	cmp.setup({

		sorting = defaults.sorting,

		preselect = cmp.PreselectMode.None,
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		completion = {
			keyword_length = 1,
			completeopt = "menu,menuone,noinsert",
		},
		matching = {
			disallow_prefix_unmatching = true,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered({
				max_height = 25,
			}),
		},
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		view = { entries = "custom" },
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<ESC>"] = cmp.mapping.close(),
			--["<CR>"] = cmp.mapping.confirm({ select = false }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.confirm({ select = true })
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			-- changed to select, not insert for safer use
			["<Up>"] = cmp.mapping.select_prev_item({
				behavior = cmp.SelectBehavior.Select,
			}),
			["<Down>"] = cmp.mapping.select_next_item({
				behavior = cmp.SelectBehavior.Select,
			}),
		}),
		sources = cmp.config.sources({
			{
				name = "copilot",
				max_item_count = 3,
				priority = 100,
			},
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "treesitter" },
			{ name = "buffer" },
			--{ name = "nvim_lua" },
		}),

		formatting = {
			fields = { "menu", "abbr", "kind" },
			format = function(entry, vim_item)
				local max_width = 50
				if max_width > 0 and #vim_item.abbr > max_width then
					vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 3) .. "..."
				end
				-- Kind icons
				-- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
				vim_item.dup = { nvim_lsp = 1, luasnip = 0 }
				local icon = kind_icons[vim_item.kind] or " "
				vim_item.kind = string.format("%s %s", icon, vim_item.kind)
				-- source icons
				vim_item.menu = source_icons[entry.source.name] .. " " or "  "
				return vim_item
			end,
		},
		experimental = {
			ghost_text = { hl_group = "NonText" },
		},
	})

	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline({
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
			["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
		}),
		sources = {
			{ name = "buffer" },
			{ name = "nvim_lsp_document_symbol" },
		},
	})

	cmp.setup.cmdline(":", {
		preselect = "none",
		completion = {
			completeopt = "menu,preview,menuone,noselect",
		},
		mapping = cmp.mapping.preset.cmdline({
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
			["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
			["<Tab>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		}),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline" },
		}),
	})
end

return M
