local IMOff, IMOn = function() end, function() end

if vim.g.input_method == "ibus" and io.open("/usr/bin/ibus", "r") ~= nil then
	IMOff = function()
		vim.g.im_prev_engine = io.popen("ibus engine", "r"):read("*all")
		os.execute("ibus engine BambooUs")
	end

	IMOn = function()
		os.execute("ibus engine " .. vim.g.im_prev_engine)
		local current_engine = io.popen("ibus engine", "r"):read("*all")
		if current_engine ~= "BambooUs" then
			vim.g.im_prev_engine = current_engine
		end
	end
end

if vim.g.input_method == "fcitx5" and io.open("/usr/bin/fcitx5", "r") ~= nil then
	IMOff = function()
		vim.g.im_prev_engine = io.popen("fcitx5-remote -n", "r"):read("*all")
		os.execute("fcitx5-remote -s keyboard-us")
	end

	IMOn = function()
		os.execute("fcitx5-remote -s " .. vim.g.im_prev_engine)
		local current_engine = io.popen("fcitx5-remote -n", "r"):read("*all")
		if current_engine ~= "keyboard-us" then
			vim.g.im_prev_engine = current_engine
		end
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinResized" }, {
	callback = function()
		local excluded_ft = { "python" }
		local ft = { "html", "xhtml", "xml", "typescriptreact", "javascriptreact", "svelte", "yaml" }

		vim.cmd("se tabstop=4 shiftwidth=4 softtabstop=4")

		if vim.fn.winwidth(0) < 100 or vim.tbl_contains(ft, vim.bo.filetype) then
			vim.cmd("se tabstop=2 shiftwidth=2 softtabstop=2")
			return
		end

		if vim.tbl_contains(excluded_ft, vim.bo.filetype) then
			vim.cmd("se tabstop=4 shiftwidth=4 softtabstop=4")
		end
	end,
})

--[[
vim.api.nvim_create_autocmd("CmdlineEnter", {
	pattern = { "/", "?" },
	callback = IMOn,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	pattern = { "/", "?" },
	callback = IMOff,
})
]]

vim.api.nvim_create_autocmd({ "InsertEnter", "VimLeave" }, { callback = IMOn })
vim.api.nvim_create_autocmd({ "InsertLeave", "VimEnter" }, { callback = IMOff })

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { scope = "cursor" })
	end,
})
