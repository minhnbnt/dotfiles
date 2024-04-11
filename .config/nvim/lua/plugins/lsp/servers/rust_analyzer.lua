return {

	server = {
		standalone = true,
		settings = {
			["rust-analyzer"] = {
				cargo = { allFeatures = true },
				check = { command = "clippy" },
				diagnostics = {
					enable = true,
					experimental = {
						enable = true,
					},
				},
			},
		},
	},
}
