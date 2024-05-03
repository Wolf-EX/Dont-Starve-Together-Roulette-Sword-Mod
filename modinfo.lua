name = "Roulette Sword"
description = ""
author = "Wolf_EX"
version = "1.2.3"
api_version = 10
forumthread = ""

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

all_clients_require_mod = true

server_filter_tags = {
"item", "sword",
}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
	{
		name = "easycraft",
		label = "Easy Crafting Recipe",
		hover = "How difficult the materials required are to obtain",
		options =
		{
			{description = "Easy", data = true},
			{description = "Hard", data = false},
		},
		default = true
	},
}