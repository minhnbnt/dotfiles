return {

	"luukvbaal/statuscol.nvim",
	event = { "BufReadPost", "BufNewFile" },

	opts = function()
		local builtin = require("statuscol.builtin")
		function builtin.diagnostic_click(args)
			if args.button == "l" then
				vim.diagnostic.open_float()
			elseif args.button == "r" then
				vim.lsp.buf.code_action()
			end
		end

		return {

			setopt = true,
			relculright = true,

			bt_ignore = { "nofile", "prompt", "terminal" },

			segments = {
				{
					click = "v:lua.ScSa",
					sign = { namespace = { "diagnostic/signs" }, colwidth = 1 },
				},
				{
					click = "v:lua.ScLa",
					sign = { name = { "Dap" }, colwidth = 1 },
				},
				{
					text = { builtin.lnumfunc },
					condition = { true, builtin.not_empty },
					click = "v:lua.ScLa",
				},
				{
					click = "v:lua.ScSa",
					sign = { namespace = { "gitsigns_extmark_signs_" }, colwidth = 1 },
				},
				{
					text = { builtin.foldfunc },
					click = "v:lua.ScFa",
					condition = { builtin.not_empty },
				},
			},
		}
	end,
}
