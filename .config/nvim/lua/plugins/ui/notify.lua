return {

	"rcarriga/nvim-notify",
	lazy = true,

	opts = {
		background_colour = "#000000",
		render = "wrapped-compact",
		stages = "static",
		top_down = false,

		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
	},
}
