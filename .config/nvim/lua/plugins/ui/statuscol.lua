local builtin = require("statuscol.builtin")
function builtin.diagnostic_click(args)
	if args.button == "l" then
		vim.diagnostic.open_float()
	elseif args.button == "r" then
		vim.lsp.buf.code_action()
	end
end

require("statuscol").setup({
	setopt = true,
	relculright = true,
	--[[ stylua: ignore
	ft_ignore = { "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes",
	              "dapui_console", "dapui_watches", "dap-repl", "NvimTree", "" }, ]]

	bt_ignore = { "nofile", "prompt", "terminal" },

	segments = {
		{
			click = "v:lua.ScSa",
			sign = {
				namespace = { "gitsigns_extmark_signs_" },
				name = { "Diagnostic" },
				maxwidth = 1,
				colwidth = 1,
			},
		},
		{
			text = { " ", builtin.lnumfunc, " " },
			condition = { true, builtin.not_empty },
			click = "v:lua.ScLa",
		},
		{
			text = { builtin.foldfunc },
			click = "v:lua.ScFa",
			condition = { builtin.not_empty },
		},
	},
})
