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

-- Set up nvim-cmp.
local cmp, luasnip = require("cmp"), require("luasnip")

local bordered = cmp.config.window.bordered()
bordered.max_height = 25

cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			--vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			--require("snippy").expand_snippet(args.body) -- For `snippy` users.
			--vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	completion = {
		--autocomplete = true,
		keyword_length = 1,
		--completeopt = "menu,menuone,noinsert",
	},
	window = {
		--completion = cmp.config.window.bordered(),
		--documentation = bordered,
		documentation = { max_height = 30 },
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
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Set `select` to `false` to only confirm explicitly selected items.
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
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		--["<Right>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		--{ name = "vsnip" }, -- For vsnip users.
		{ name = "luasnip" }, -- For luasnip users.
		--{ name = "ultisnips" }, -- For ultisnips users.
		--{ name = "snippy" }, -- For snippy users.
		--{ name = "omni" },
		{ name = "tags" },
		--{ name = "emoji", insert = true }, -- emoji completion
	}, {
		{ name = "buffer" },
		{ name = "calc" },
		{ name = "cmp_tabnine" },
		{ name = "treesitter" },
		{ name = "nvim_lua" },
		{
			name = "copilot",
			-- keyword_length = 0,
			max_item_count = 3,
		},
		--{ name = "cmp_ai" },
		--{ name = "nvim_lsp_signature_help" },
		--[[{
					name = "look",
					keyword_length = 2,
					option = {
						convert_case = true,
						loud = true,
						--dict = '/usr/share/dict/words'
					},
				},]]
		{
			name = "spell",
			option = {
				keep_all_entries = false,
				enable_in_context = true,
			},
		},
	}),
	formatting = {
		fields = { "menu", "abbr", "kind" },
		format = function(entry, vim_item)
			local max_width = 50
			if max_width ~= 0 and #vim_item.abbr > max_width then
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
		ghost_text = { hl_group = "NonText" }, -- this feature conflict with copilot.vim's preview.
	},
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
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

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline({
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
		["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
	}),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})

vim.cmd("hi CmpItemMenu cterm=bold gui=bold")
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#04A5E5" })
vim.api.nvim_set_hl(0, "CmpItemKindTabNine", { fg = "#f397f7" })
