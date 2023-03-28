require("vscode").setup({
	-- Enable transparent background
	transparent = true,
	-- Enable italic comment
	italic_comments = false,
	-- Disable nvim-tree background color
	disable_nvimtree_bg = true,
	-- Override colors (see ./lua/vscode/colors.lua)
	color_overrides = {
		--vscLineNumber = c.vscLightGreen,
		--vscBack = "NONE",
	},
	-- Override highlight groups (see ./lua/vscode/theme.lua)
	group_overrides = {
		-- this supports the same val table as vim.api.nvim_set_hl
		-- use colors from this colorscheme by requiring vscode.colors!
	},
})

require("vscode").load("dark")

vim.cmd([[
    hi CursorLine term=bold cterm=bold guibg=#131313
    hi BufferLineSeparator guifg=#555555 guibg=#252525
    hi BufferLineSeparatorSelected guifg=#555555
    hi BufferLineSeparatorVisible guifg=#555555
	hi BufferLineBackground guibg=#252525
    hi BufferLineFill guibg=#555555
    hi BufferLineBufferSelected guifg=#9cdcfe
	hi BufferLineCloseButton guibg=#252525
	"hi BufferLineIndicatorSelected guifg=#252525
	hi BufferLineDuplicate guibg=#252525
	hi BufferLineModified guibg=#252525
	hi ModeMsg guibg=none gui=bold
]])

--	hi BufferLineSeparator guibg=#550000
--	hi BufferLineCloseButton guibg=#550000
--	hi BufferLineModifiedVisible guibg=#550000
--	hi BufferLinePick guibg=#550000
--	hi BufferLineIndicatorSelected guibg=#ff0000
--	hi BufferLineBufferVisible guibg=#550000
