return {

	"goolord/alpha-nvim",
	lazy = false,

	keys = {
		{ "<leader>a", "<cmd>Alpha<cr>", desc = "Alpha" },
	},

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
			dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
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
			return { "It will create a miracle." }
		end

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"

		dashboard.opts.opts.noautocmd = true

		return dashboard.opts
	end,
}
