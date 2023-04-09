-- Set up nvim-cmp.
local cmp = require("cmp")

--require("copilot_cmp").setup({
--	method = "getPanelCompletions",
--})

local type_comparator = function(conf)
	local lsp_types = require("cmp.types").lsp
	return function(entry1, entry2)
		if entry1.source.name ~= "nvim_lsp" then
			if entry2.source.name == "nvim_lsp" then
				return false
			else
				return nil
			end
		end
		local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
		local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

		local priority1 = conf.kind_priority[kind1] or 0
		local priority2 = conf.kind_priority[kind2] or 0
		if priority1 == priority2 then
			return nil
		end
		return priority2 < priority1
	end
end

local label_comparator = function(entry1, entry2)
	return entry1.completion_item.label < entry2.completion_item.label
end

local kind_icons = {
	Copilot = "",
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

local source_icons = {
	nvim_lsp = "",
	luasnip = "",
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
}

cmp.setup({
	preselect = cmp.PreselectMode.None,
	--comparators = {
	--	type_comparator({
	--		kind_priority = {
	--			Field = 11,
	--			Property = 11,
	--			Constant = 10,
	--			Enum = 10,
	--			EnumMember = 10,
	--			Event = 10,
	--			Function = 10,
	--			Method = 10,
	--			Operator = 10,
	--			Reference = 10,
	--			Struct = 10,
	--			Variable = 9,
	--			File = 8,
	--			Folder = 8,
	--			Class = 5,
	--			Color = 5,
	--			Module = 5,
	--			Keyword = 0,
	--			Constructor = 1,
	--			Interface = 1,
	--			Snippet = 0,
	--			Text = 1,
	--			TypeParameter = 1,
	--			Unit = 1,
	--			Value = 1,
	--		},
	--	}),
	--	label_comparator,
	--},
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
		documentation = {
			max_height = 30,
		},
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	view = {
		entries = "custom",
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<ESC>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm(), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
		["<Down>"] = cmp.mapping.select_next_item(),
		["<Up>"] = cmp.mapping.select_prev_item(),
		--["<Right>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000 },
		{ name = "path" },
		--{ name = "vsnip" }, -- For vsnip users.
		{ name = "luasnip", priority = 10000 }, -- For luasnip users.
		--{ name = "ultisnips" }, -- For ultisnips users.
		--{ name = "snippy" }, -- For snippy users.
		--{ name = "omni" },
		{ name = "tags" },
		--{ name = "emoji", insert = true }, -- emoji completion
		{ name = "buffer" },
		{ name = "calc" },
		--{ name = "cmp_tabnine" },
		{ name = "treesitter", priority = 10 },
		{ name = "nvim_lua" },
		--{ name = "copilot", priority = 100 },
		--{ name = "nvim_lsp_signature_help" },
		{
			name = "look",
			keyword_length = 2,
			option = {
				convert_case = true,
				loud = true,
				--dict = '/usr/share/dict/words'
			},
		},
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
				vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
			end
			-- Kind icons
			-- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			vim_item.dup = { nvim_lsp = 0 }
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
			-- source icons
			vim_item.menu = source_icons[entry.source.name]
			return vim_item
		end,
	},
	experimental = {
		--ghost_text = { hl_group = "NonText" }, -- this feature conflict with copilot.vim's preview.
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
		{ name = "buffer" },
	}),
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

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
