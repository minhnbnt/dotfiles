require("copilot").setup({
	cmp = {
		enabled = true,
		method = "getCompletionsCycling",
	},
	panel = {
		enabled = true,
		auto_refresh = true,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>",
		},
	},
	server_opts_overrides = {
		--trace = "verbose",
		settings = {
			advanced = {
				-- listCount = 10, -- #completions for panel
				inlineSuggestCount = 3, -- #completions for getCompletions
			},
		},
	},
})

require("copilot_cmp").setup()
