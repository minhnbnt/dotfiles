require("notify").setup({
	background_colour = "#000000",
	render = "compact",
	stages = "slide",
	top_down = true,

	max_height = function()
		return math.floor(vim.o.lines * 0.75)
	end,
	max_width = function()
		return math.floor(vim.o.columns * 0.75)
	end,
})

function vim.notify(msg, ...)
	if msg:match("warning: multiple different client offset_encodings") then
		return
	end

	require("notify")(msg, ...)
end
