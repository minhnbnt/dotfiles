local ftMap = {
	vim = "indent",
	python = "indent",
	git = "",
}

local function handler(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = ("  %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

return {

	"kevinhwang91/nvim-ufo",
	event = { "BufReadPost", "BufNewFile" },

	dependencies = { "kevinhwang91/promise-async" },

	init = function()
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
	end,

	opts = {
		open_fold_hl_timeout = 150,
		fold_virt_text_handler = handler,
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
			},
		},
		provider_selector = function(bufnr, filetype, buftype)
			local bt_ignore = { "nofile", "prompt", "terminal" }

			if vim.tbl_contains(bt_ignore, buftype) then
				return ""
			end

			-- if you prefer treesitter provider rather than lsp,
			--return ftMap[filetype] or { "treesitter", "indent" }
			return ftMap[filetype] or { "treesitter", "indent" }
			-- refer to ./doc/example.lua for detail
		end,
	},
}
