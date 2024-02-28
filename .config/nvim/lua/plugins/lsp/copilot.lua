require("copilot").setup({
	cmp = {
		enabled = true,
		method = "getCompletionsCycling",
	},
	server_opts_overrides = {
		--trace = "verbose",
		on_attach = function()
			vim.cmd("Copilot")
			vim.b.copilot_active = true
		end,
		on_exit = function()
			vim.b.copilot_active = nil
		end,
		settings = {
			advanced = {
				-- listCount = 10, -- #completions for panel
				inlineSuggestCount = 3, -- #completions for getCompletions
			},
		},
	},
})

require("copilot_cmp").setup({
	event = { "InsertEnter", "LspAttach" },
	fix_pairs = true,
})
