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

local cpp_out = {}

table.insert(
	cpp_out,
	snip({
		trig = "#include <bits/stdc++.h>",
		namr = "initial",
		dscr = "initial c++ file",
	}, {
		text("#include <bits/stdc++.h>"),
		text({ "", "", "using namespace std;" }),
		text({ "", "", "int main(void) {", "\t" }),
		text({ "ios_base::sync_with_stdio(false);", "\t" }),
		text({ "cin.tie(nullptr), cout.tie(nullptr);", "\t" }),
		insert(0, ""),
		text({ "", "\treturn 0;", "}" }),
	}, {
		condition = conds_expand.line_begin,
	})
)
table.insert(
	cpp_out,
	snip({
		trig = "std::cout",
		namr = "cout",
		dscr = "std::cout << message << std::endl",
	}, {
		text('std::cout << "'),
		insert(0, ""),
		text('" << std::endl;'),
	})
)
table.insert(
	cpp_out,
	snip({
		trig = "cout",
		namr = "cout",
		dscr = "cout << message << endl",
	}, {
		text('cout << "'),
		insert(0, ""),
		text('" << endl;'),
	})
)
table.insert(
	cpp_out,
	snip({
		trig = "cin",
		namr = "cin",
		dscr = "cin >> variable",
	}, {
		text("cin >> "),
		insert(0),
		text(";"),
	})
)
table.insert(
	cpp_out,
	snip({
		trig = "std::cin",
		namr = "std::cin",
		dscr = "std::cin >> variable",
	}, {
		text("std::cin >> "),
		insert(0),
		text(";"),
	})
)

return cpp_out
