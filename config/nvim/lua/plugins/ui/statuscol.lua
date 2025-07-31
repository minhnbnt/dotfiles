local function diagnostic_click(args)
	if args.button == "l" then
		vim.diagnostic.open_float()
	elseif args.button == "r" then
		vim.cmd("Lspsaga code_action")
	end
end

return {

	"luukvbaal/statuscol.nvim",
	event = { "BufReadPost", "BufNewFile" },

	opts = function()
		local builtin = require("statuscol.builtin")

		return {

			setopt = true,
			relculright = true,

			bt_ignore = { "nofile", "prompt", "terminal" },

			segments = {
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
					sign = { namespace = { "gitsigns" }, colwidth = 1 },
				},
				{
					text = { builtin.foldfunc },
					click = "v:lua.ScFa",
					condition = { builtin.not_empty },
				},
			},

			clickhandlers = { ["diagnostic/signs"] = diagnostic_click },
		}
	end,
}
