local ls = require("luasnip")
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local conds_expand = require("luasnip.extras.conditions.expand")

local html_out = {}

-- need a function, variable will throw exception
local function init()
	return {
		text({ "<!DOCTYPE html>", '<html lang="vi">', "\t<head>" }),
		text({ "", '\t\t<meta charset="UTF-8" />', "" }),
		text('\t\t<meta name="viewport" content="width='),
		insert(1, "device-width"),
		text(", initial-scale="),
		insert(2, "1.0"),
		text({ '" />', "\t\t<title>" }),
		insert(3, "Document"),
		text({ "</title>", "\t</head>", "", "\t<body>", "\t\t" }),
		insert(0, ""),
		text({ "", "\t</body>", "</html>" }),
	}
end

table.insert(
	html_out,
	snip({
		trig = "!!!",
		namr = "!doctype",
		dscr = "Define doctype",
	}, { text({ "<!DOCTYPE html>", "" }) })
)

table.insert(
	html_out,
	snip({
		trig = "!",
		namr = "!init",
		dscr = "Initial HTML file",
	}, init())
)

table.insert(
	html_out,
	snip({
		trig = "html:5",
		namr = "!init",
		dscr = "Initial HTML file",
	}, init())
)

table.insert(
	html_out,
	snip({
		trig = "html:xml",
		namr = "!init",
	}, {
		text('<html xmlns="http://www.w3.org/1999/xhtml">'),
		insert(0, ""),
		text("</html>"),
	})
)

table.insert(
	html_out,
	snip({
		trig = "a:link",
	}, {
		text('<a href="https://'),
		insert(1, ""),
		text('">'),
		insert(0, ""),
		text("</a>"),
	})
)

return html_out
