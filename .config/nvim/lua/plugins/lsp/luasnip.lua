local ls = require("luasnip")
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local conds = require("luasnip.extras.conditions.expand")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

ls.filetype_extend("all", { "_" })

local cpp = {

	snip({
		trig = "#include <bits/stdc++.h>",
		namr = "initial",
		dscr = "initial c++ file for contests",
	}, {
		text("#include <bits/stdc++.h>"),
		text({ "", "", "using namespace std;" }),
		text({ "", "", "int main(void) {" }),
		text({ "", "", "\tios_base::sync_with_stdio(false);", "" }),
		text({ "\tcin.tie(nullptr), cout.tie(nullptr);", "", "\t" }),
		insert(0, ""),
		text({ "", "", "\treturn 0;", "}" }),
	}, {
		condition = function()
			return vim.fn.line(".") == 1
		end,
	}),

	snip({
		trig = "#include <iostream>",
		namr = "initial",
		dscr = "initial c++ file",
	}, {
		text("#include <iostream>"),
		text({ "", "", "int main(void) {" }),
		text({ "", "", "\tstd::ios_base::sync_with_stdio(false);", "" }),
		text({ "\tstd::cin.tie(nullptr), std::cout.tie(nullptr);", "", "\t" }),
		insert(0, ""),
		text({ "", "", "\treturn 0;", "}" }),
	}, {
		condition = function()
			return false
		end,
	}),
}

ls.add_snippets(nil, { cpp = cpp })
