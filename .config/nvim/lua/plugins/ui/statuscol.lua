local builtin = require("statuscol.builtin")

require("statuscol").setup({
	setopt = true,
	-- stylua: ignore
	ft_ignore = { "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes",
	              "dapui_console", "dapui_watches", "dap-repl", "NvimTree", "" },

	segments = {
		{
			click = "v:lua.ScSa",
			sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false },
		},
		{
			text = { " ", builtin.lnumfunc, " " },
			condition = { true, builtin.not_empty, builtin.lnumfunc },
			click = "v:lua.ScLa",
		},
		{ text = { builtin.foldfunc }, click = "v:lua.ScFa", condition = { builtin.not_empty } },
	},
})
