require("notify").setup({
	background_colour = "#000000",
	render = "compact",
	stages = "slide",
	top_down = true,
})

vim.notify = function(msg, ...)
	if msg:match("warning: multiple different client offset_encodings") then
		return
	end
	require("notify")(msg, ...)
end
