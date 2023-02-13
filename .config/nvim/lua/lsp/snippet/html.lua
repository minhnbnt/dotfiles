local ls = require("luasnip")
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local html_out = {}

-- stylua: ignore
--[[
local tags = { "p", "s", "q", "i", "b", "u", "h1", "h2", "h3", "h4", "h5", "h6", "hr", "ol", "ul", "li", "dl", "dt",
    "dd", "em", "rb", "rt", "rp", "br", "tr", "td", "th", "nav", "pre", "div", "dfn", "var", "kbd", "sub", "sup", "bdi",
    "bdo", "wbr", "ins", "del", "img", "map", "col", "html", "head", "base", "link", "meta", "body", "main", "cite",
    "abbr", "ruby", "time", "code", "samp", "mark", "span", "area", "form", "title", "style", "aside", "small", "embed",
    "param", "video", "audio", "track", "table", "tbody", "thead", "tfoot", "label", "input", "meter", "header", "footer",
    "firgure", "strong", "iframe", "object", "source", "button", "select", "option", "output", "legend", "dialog",
    "script", "canvas", "article", "section", "address", "picture", "caption", "details", "summary", "colroup",
    "datalist", "optgroup", "textarea", "progress", "fieldset", "noscript", "template", "blockquote", "figcaption",
}
for _, tag in pairs(tags) do
	local snippet = snip({
		trig = tag,
		namr = "Html tag",
		dscr = "Html tags completion by m1nhnbnt",
	}, {
		text(string.format("<%s>", tag)),
		insert(1, ""),
		text(string.format("</%s>", tag)),
	})
	table.insert(html_out, snippet)
end
]]

local bttn = {
    ["d"] = { "btn:d", "button:d", "button:disabled" },
    ["r"] = { "btn:r", "button:r", "button:reset" },
    ["s"] = { "btn:s", "button:s", "button:submit" },
}

local fieldset_d = { "fieldset:d", "fieldset:disabled", "fst:d", "fset:d" }
local area = {
	["c"] = "circle",
	["r"] = "rect",
	["p"] = "poly",
	["d"] = "default",
}
local input = {
	out = {},
	short = {
		["h"] = "hidden",
		["t"] = "text",
		["p"] = "password",
		["f"] = "file",
		["i"] = "image",
		["b"] = "button",
		["s"] = "submit",
		["c"] = "checkbox",
		["r"] = "radio",
	},
	long = {
		"search",
		"email",
		"url",
		"date",
		"datetime-local",
		"month",
		"week",
		"time",
		"tel",
		"number",
		"range",
		"color",
		"reset",
	},
}
local img = {
	sizes = { "img:s", "img:size", "ri:d", "ri:dpr" },
	srcset = { "img:srcset", "img:srcset" },
}
local short = {
	["bq"] = "blockquote",
	["fig"] = "figure",
	["figc"] = "figcaption",
	["pic"] = "picture",
	["ifr"] = "iframe",
	["emb"] = "embed",
	["obj"] = "object",
	["cap"] = "caption",
	["colg"] = "colgroup",
	["fst"] = "fieldset",
	["btn"] = "button",
	["optg"] = "optgroup",
	["tarea"] = "textarea",
	["leg"] = "legend",
	["sect"] = "section",
	["art"] = "article",
	["hdr"] = "header",
	["ftr"] = "footer",
	["adr"] = "address",
	["dlg"] = "dialog",
	["str"] = "strong",
	["prog"] = "progress",
	["mn"] = "main",
	["tem"] = "template",
	["fset"] = "fieldset",
	["datag"] = "datagrid",
	["datal"] = "datalist",
	["kg"] = "keygen",
	["out"] = "output",
	["det"] = "details",
	["sum"] = "summary",
	["cmd"] = "command",
}
local source = {
	out = {},
	short = {
		["sc"] = "scr",
		["s"] = "srcset",
		["t"] = "type",
		["m"] = "media",
		["z"] = "sizes",
		["mt"] = "media:type",
		["mz"] = "media:sizes",
		["zt"] = "sizes:type",
	},
	snip = {
		["sc"] = {
			text('<source src="'),
			insert(1, ""),
			text('" type="'),
			insert(2, ""),
			text('">'),
		},
		["s"] = {
			text('<source srcset="'),
			insert(1, ""),
			text('">'),
		},
		["t"] = {
			text('<source srcset="'),
			insert(1, ""),
			text('" type="'),
			insert(2, "image/"),
			text('">'),
		},
		["m"] = {
			text('<source media="('),
			insert(1, "min-width: "),
			text(')"  srcset='),
			insert(2, ""),
			text('">'),
		},
		["z"] = {
			text('<source sizes="'),
			insert(1, ""),
			text('" srcset="'),
			insert(2, ""),
			text('">'),
		},
		["mt"] = {
			text('<source media="('),
			insert(1, "min-width: "),
			text(')" srcset="'),
			insert(2, ""),
			text('" type="'),
			insert(3, "image/"),
			text('">'),
		},
		["mz"] = {
			text('<source media="('),
			insert(1, "min-width: "),
			text(')" srcset="'),
			insert(2, ""),
			text('" sizes="'),
			insert(3, ""),
			text('">'),
		},
		["zt"] = {
			text('<source sizes="'),
			insert(1, ""),
			text('" srcset="'),
			insert(2, ""),
			text('" type="'),
			insert(3, "image/"),
			text('">'),
		},
	},
}

local tag = {
	["!DOCTYPE"] = {
		text("<!DOCTYPE html>"),
	},
	["a:blank"] = {
		text('<a href="http://'),
		insert(1, ""),
		text('" target="_blank" rel="noopener noreferrer">'),
		insert(2, ""),
		text("</a>"),
	},
	["a:link"] = {
		text('<a href="http://'),
		insert(1, ""),
		text(">"),
		insert(2, ""),
		text("</a>"),
	},
	["a:mail"] = {
		text('<a href="mailto:'),
		insert(1, ""),
		text('">'),
		insert(2, ""),
		text("</a>"),
	},
	["abbr"] = {
		text('<abbr title="'),
		insert(1, ""),
		text('">'),
		insert(2, ""),
		text("</abbr>"),
	},
	["acr"] = {
		text("<acronym>"),
		insert(1, ""),
		text("</acronym>"),
	},
	["acronym"] = {
		text("<acronym>"),
		insert(1, ""),
		text("</acronym>"),
	},
	["basefont"] = {
		text("<basefont>"),
	},
	["frame"] = {
		text("<frame>"),
	},
	["bdo:l"] = {
		text('<bdo dir="ltr">'),
		insert(1, ""),
		text("</bdo>"),
	},
	["bdo:r"] = {
		text('<bdo dir="rtl">'),
		insert(1, ""),
		text("</bdo>"),
	},
	["link:css"] = {
		text('<link rel="stylesheet" href="'),
		insert(1, "style"),
		text('.css">'),
		insert(2, ""),
	},
	["link:print"] = {
		text('<link rel="stylesheet" href="'),
		insert(1, "print"),
		text('.css" media="print">'),
		insert(2, ""),
	},
	["link:favicon"] = {
		text('<link rel="shortcut icon" href="'),
		insert(1, "favicon.ico"),
		text('" type="image/x-icon">'),
		insert(2, ""),
	},
	["link:touch"] = {
		text('<link rel="apple-touch-icon" href="'),
		insert(1, "touch.png"),
		text('">'),
		insert(2, ""),
	},
	["link:rss"] = {
		text('<link rel="alternate" type="application/rss+xml" title="RSS" href="'),
		insert(1, "rss"),
		text('.xml">'),
		insert(2, ""),
	},
	["link:atom"] = {
		text('<link rel="alternate" href="'),
		insert(1, "atom"),
		text('.xml" type="application/atom+xml" title="Atom">'),
		insert(2, ""),
	},
	["link:manifest"] = {
		text('<link rel="manifest" href="'),
		insert(1, "manifest"),
		text('.json">'),
		insert(2, ""),
	},
	["link:mf"] = {
		text('<link rel="manifest" href="'),
		insert(1, "manifest"),
		text('.json">'),
		insert(2, ""),
	},
	["link:im"] = {
		text('<link rel="manifest" href="'),
		insert(1, "manifest"),
		text('.json">'),
		insert(2, ""),
	},
	["link:import"] = {
		text('<link rel="manifest" href="'),
		insert(1, "manifest"),
		text('.json">'),
		insert(2, ""),
	},
	["meta:utf"] = {
		text('<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">'),
	},
	["meta:vp"] = {
		text('<meta name="viewport" content="width='),
		insert(1, "device-width"),
		text(", initial-scale="),
		insert(2, "1.0"),
		text('">'),
		insert(3, ""),
	},
	["meta:compat"] = {
		text('<meta http-equiv="X-UA-Compatible" content="'),
		insert(1, "IE=7"),
		text('">'),
		insert(2, ""),
	},
	["meta:edge"] = {
		text('<meta http-equiv="X-UA-Compatible" content="'),
		insert(1, "IE=edge"),
		text('">'),
		insert(2, ""),
	},
	["btn"] = {
		text("<button>"),
		insert(1, ""),
		text("</button>"),
	},
	["button"] = {
		text("<button>"),
		insert(1, ""),
		text("</button>"),
	},
}

for _, v in pairs(bttn.d) do
	tag[v] = {
		text('<button disabled="disabled">'),
		insert(1, ""),
		text("</button>"),
	}
end
for _, v in pairs(bttn.r) do
	tag[v] = {
		text('<button type="reset">'),
		insert(1, ""),
		text("</button>"),
	}
end
for _, v in pairs(bttn.s) do
	tag[v] = {
		text('<button type="submit">'),
		insert(1, ""),
		text("</button>"),
	}
end

for _, v in pairs(fieldset_d) do
	tag[v] = {
		text('<fieldset disabled="disabled">'),
		insert(1, ""),
		text("</fieldset>"),
	}
end
for k, v in pairs(area) do
	tag["area:" .. k] = {
		text('<area shape="' .. v .. '" coords="'),
		insert(1, ""),
		text('" href="'),
		insert(2, ""),
		text('" alt="'),
		insert(3, ""),
		text('">'),
	}
end
for k, v in pairs(input.short) do
	input.out["input:" .. k] = v
	input.out["input:" .. v] = v
end
for _, v in pairs(input.long) do
	input.out["input:" .. v] = v
end
for k, v in pairs(input.out) do
	tag[k] = {
		text('<input type="' .. v .. '" name="'),
		insert(1, ""),
		text('" value="'),
		insert(2, ""),
		text('">'),
	}
end
for k, v in pairs(short) do
	tag[k] = {
		text("<" .. v .. ">"),
		insert(1, ""),
		text("</" .. v .. ">"),
	}
end
for k, v in pairs(source.short) do
	tag[string.format("src:%s", k)] = source.snip[k]
	tag["source:" .. v] = source.snip[k]
end

for k, v in pairs(tag) do
	local snippet = snip({
		trig = k,
		namr = "Html tag",
		dscr = "HTML tags completion by m1nhnbnt",
	}, v)
	table.insert(html_out, snippet)
end

return html_out
