local ls = require("luasnip")
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local c_out = {}

table.insert(
	c_out,
	snip({
		trig = "#include <stdio.h>",
		namr = "c initial",
		dscr = "c initial file",
	}, {
		text({ "#include <stdio.h>", "", "" }),
		text({ "int main(int argc, char *argv[]) {", "\t" }),
		insert(0, ""),
		text({ "", "}" }),
	}, {
		condition = conds_expand.line_begin,
	})
)
table.insert(
	c_out,
	snip({
		trig = "for",
		namr = "for",
		dscr = "for loop",
	}, {
		text("for (int "),
		insert(1, "i"),
		text(" = "),
		insert(2, "0"),
		text("; "),
		insert(1, "i"),
		text(" < "),
		insert(3, "n"),
		text("; "),
		insert(1, "i"),
		text("++) {"),
		insert(4, ""),
		text("}"),
	})
)

return c_out
