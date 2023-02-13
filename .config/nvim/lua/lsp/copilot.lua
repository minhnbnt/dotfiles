require("copilot").setup({
	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>",
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<M-l>",
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	copilot_node_command = "node", -- Node.js version must be > 16.x
	server_opts_overrides = {
		--trace = "verbose",
		settings = {
			advanced = {
				--listCount = 10, -- #completions for panel
				--inlineSuggestCount = 3, -- #completions for getCompletions
			},
		},
	},
})
