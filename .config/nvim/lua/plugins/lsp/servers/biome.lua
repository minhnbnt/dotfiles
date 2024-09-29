local newFormatter = require("utils.formatOnSave")

return {

	on_attach = function(client, bufnr)
		newFormatter(client, bufnr)
	end,
}
