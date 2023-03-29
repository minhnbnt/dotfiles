require("notify").setup({
	stages = "fade_in_slide_out",
	background_colour = "#000000",
	timeout = 3000,
})

vim.notify = require("notify")
