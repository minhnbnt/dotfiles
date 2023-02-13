local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

--█▙    █ █▀▀▀▀▀▀ █▀
--█▝▙   █ █       █
--█ ▝▙  █ █▀▀▀▀▀▀ █
--█  ▝▙ █ █       █
--█   ▝▙█ █▄▄▄▄▄▄ █

local dashboard = require("alpha.themes.dashboard")
--     
dashboard.section.header.val = {
	--[[  ▗██▙        ██▖  ]]
	--[[ ▟█████▖      ███▙ ]]
	--[[████████▙     █████]]
	--[[██████████▖   █████]]
	--[[█████▀█████▙  █████]]
	--[[█████ ▝▜█████▄█████]]
	--[[█████   ▀██████████]]
	--[[█████     ▜████████]]
	--[[ ▜███      ▝█████▛ ]]
	--[[  ▝██        ▜██▘  ]]

	[[  ▗██▙        ██▖  ]],
	[[ ▟█████▖      ███▙ ]],
	[[▙▝▜█████▙     █████]],
	[[██▖▀██████▖   █████]],
	[[███▙▖▀█████▙  █████]],
	[[█████ ▝▜█████▄▝▜███]],
	[[█████   ▀██████▄▝██]],
	[[█████     ▜█████▙▖▜]],
	[[ ▜███      ▝█████▛ ]],
	[[  ▝██        ▜██▘  ]],
}
dashboard.section.buttons.val = {
	dashboard.button("n", "  New file", ":ene <CR>"),
	dashboard.button("o", "  Open file", ":Telescope file_browser hidden=true grouped=true <CR>"),
	dashboard.button("f", "  Find file", ":Telescope find_files hidden=true <CR>"),
	dashboard.button("p", "  Find project", ":lua require'telescope'.extensions.projects.projects{} <CR>"),
	dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button(
		"c",
		"  Configuration",
		":Telescope file_browser hidden=true grouped=true path=~/.config/nvim/ <CR>"
	),
	dashboard.button("g", "  Live grep", ":Telescope live_grep <CR>"),
	dashboard.button("t", "  Tutor", ":Tutor <CR>"),
	dashboard.button("h", "  Help", ":tab h <CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa <CR>"),
}

local function footer()
	-- NOTE: requires the fortune-mod package to work
	-- local handle = io.popen("fortune")
	-- local fortune = handle:read("*a")
	-- handle:close()
	-- return fortune
	return "It will create a miracle!!!"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)

vim.cmd([[
	augroup _alpha
		autocmd!
		autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
	augroup end
]])
