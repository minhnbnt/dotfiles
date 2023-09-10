local function config()
	require("vscode").setup({
		-- Enable transparent background
		transparent = true,
		-- Enable italic comment
		italic_comments = false,
		-- Disable nvim-tree background color
		disable_nvimtree_bg = true,
		-- Override colors (see ./lua/vscode/colors.lua)
		color_overrides = {
			vscFront = "#DCE0E8",
			vscBack = "#1E2030",
			--
			vscTabCurrent = "#1E2030",
			vscTabOther = "#303446",
			vscTabOutside = "#232634",
			--
			vscPopupFront = "#B5BFE2",
			vscPopupBack = "#181926", --
			vscPopupHighlightBlue = "#242a4f",
			vscPopupHighlightGray = "#292C3C",
			--
			vscSplitLight = "#8E95B3",
			vscSplitDark = "#43465A",
			vscSplitThumb = "#363A4F",
			--
			vscCursorDarkDark = "#11111B",
			vscCursorDark = "#51576D",
			vscCursorLight = "#A5ADCE",
			vscSelection = "#1b376e",
			vscLineNumber = "#51576D",
			--
			vscDiffRedDark = "#4d0515",
			vscDiffRedLight = "#691118",
			vscDiffRedLightLight = "#D20F39",
			vscDiffGreenDark = "#31452d",
			vscDiffGreenLight = "#41632f",
			vscSearchCurrent = "#304266",
			vscSearch = "#6e2e09",
			--
			vscGitAdded = "#7aad6f",
			vscGitModified = "#E5C890",
			vscGitDeleted = "#c73c48",
			vscGitRenamed = "#659c59",
			vscGitUntracked = "#84e3c2",
			vscGitIgnored = "#8C8FA1",
			vscGitStageModified = "#E5C890",
			vscGitStageDeleted = "#c93c49",
			vscGitConflicting = "#e6676c",
			vscGitSubmodule = "#8CAAEE",
			--
			vscContext = "#414559",
			vscContextCurrent = "#737994",
			vscFoldBackground = "#1b2230",
			--
			vscYellowOrange = "#E5C890",
			vscLightRed = "#E78284",
			vscLightGreen = "#A6DA95",
			vscBlueGreen = "#5be3c8",
			vscMediumBlue = "#04A5E5",
			vscDarkBlue = "#1E66F5",
			vscRed = "#E64553",
			vscAccentBlue = "#99D1DB",
			vscYellow = "#E5C890",
			vscGreen = "#5ea64e",
			vscOrange = "#EF9F76",
			vscLightBlue = "#99D1DB",
			vscPink = "#EA76CB",
			vscGray = "#CCD0DA",
			vscViolet = "#8839EF",
			vscBlue = "#7287FD",
			vscDarkYellow = "#DF8E1D",
		},
		-- Override highlight groups (see ./lua/vscode/theme.lua)
		group_overrides = {
			-- this supports the same val table as vim.api.nvim_set_hl
			-- use colors from this colorscheme by requiring vscode.colors!
		},
	})

	require("vscode").load("dark")

	vim.cmd([[
		hi BufferLineSeparator guifg=#565970 guibg=#232634
		hi BufferLineSeparatorSelected guifg=#565970
		hi BufferLineSeparatorVisible guifg=#565970
		hi BufferLineBackground guibg=#232634
		hi BufferLineFill guibg=#565970
		hi BufferLineBufferSelected guifg=#99d1db
		hi BufferLineCloseButton guibg=#232634
		hi BufferLineDuplicate guibg=#232634
		hi BufferLineModified guibg=#232634
		hi ModeMsg guibg=none gui=bold
		hi DiagnosticSignHint guifg=#99d1db
	]])
end

return {
	"Mofiqul/vscode.nvim",
	config = config,
}