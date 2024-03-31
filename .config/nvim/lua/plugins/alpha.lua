return {

	"goolord/alpha-nvim",

	init = function()
		vim.cmd([[
			augroup _alpha
				autocmd!
				autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
			augroup end
		]])
	end,

	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		--     
		dashboard.section.header.val = {

			--▟▙    █ ▟▀▀▀▀ ▟▀▀▀▙ █   █ █ ▟▙ ▟▙
			--█▝▙   █ █     █   █ █   █ █ █▐▄▌█
			--█ ▝▙  █ █▀▀▀▀ █   █ █   █ █ █ ▀ █
			--█  ▝▙ █ █     █   █ ▜▖ ▗▛ █ █   █
			--█   ▝▙▛ ▜▄▄▄▄ ▜▄▄▄▛  ▜▄▛  █ █   █

			--	[[  ▗██▙        ██▖  ]],
			--	[[ ▟█████▖      ███▙ ]],
			--	[[▙▝▜█████▙     █████]],
			--	[[██▖▀██████▖   █████]],
			--	[[███▙▖▀█████▙  █████]],
			--	[[█████ ▝▜█████▄▝▜███]],
			--	[[█████   ▀██████▄▝██]],
			--	[[█████     ▜█████▙▖▜]],
			--	[[ ▜███      ▝█████▛ ]],
			--	[[  ▝██        ▜██▘  ]],

			[[  ▗██▙       ██▖                             ]],
			[[ ▟█████▖     ███▙                            ]],
			[[▙▝▜█████▙▖   █████ ▟▀▀▀▀ ▟▀▀▀▙ █  ▐▌▐▌▗█▖  ▟▙]],
			[[██▖▀██████▙  █████ █     █   █ █  ▐▌▐▌▐▌▜▖▟▘█]],
			[[███▙▖▀██████▄▝▜███ █▀▀▀▀ █   █ █  ▐▌▐▌▐▌ ▜▘ █]],
			[[█████ ▝▜██████▄▝██ █     █   █ ▜▖ ▟▘▐▌▐▌    █]],
			[[█████   ▝▜█████▙▖▜ ▜▄▄▄▄ ▜▄▄▄▛  ▜▟▘ ▐▌▐▌    █]],
			[[ ▜███     ▝█████▛                            ]],
			[[  ▝██       ▜██▘                             ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("n", "  New file", ":ene <CR>"),
			dashboard.button("o", "  Open file", ":Telescope file_browser hidden=true grouped=true <CR>"),
			dashboard.button("f", "  Find file", ":Telescope find_files hidden=true <CR>"),
			dashboard.button("p", "  Find project", ":lua require('telescope').extensions.projects.projects() <CR>"),
			dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
			dashboard.button(
				"c",
				"  Configuration",
				":Telescope file_browser hidden=true grouped=true path=" .. vim.fn.stdpath("config") .. " <CR>"
			),
			dashboard.button("g", "  Live grep", ":Telescope live_grep <CR>"),
			dashboard.button("t", "  Tutor", ":Tutor <CR>"),
			dashboard.button("h", "  Help", ":tab h <CR>"),
			dashboard.button("q", "  Quit Neovim", ":qa <CR>"),
		}

		dashboard.section.footer.val = function()
			--local handle = io.popen("fortune")
			--if handle == nil then
			return "It will create a miracle."
			--end
			--local fortune = handle:read("*a")
			--handle:close()
			--return fortune
		end

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"

		dashboard.opts.opts.noautocmd = true

		return dashboard.opts
	end,
}
