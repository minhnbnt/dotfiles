return {
	lsp = {
		use_defaults = true,
		server = {
			init_options = {
				index = { threads = 4 },
				completion = { placeholder = false },
			},
			flags = { debounce_text_changes = 150 },
		},
	},
}
