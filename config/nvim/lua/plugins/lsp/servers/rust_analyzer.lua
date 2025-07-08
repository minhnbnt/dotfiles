return {

	server = {
		cmd = function()
			return { "ra-multiplex" }
		end,
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = true,
					enableExperimental = true,
					experimental = {
						enable = true,
					},
				},
			},
		},
	},
}
