require("keyjump"):setup({
	icon_fg = "#fda1a1",
	first_key_fg = "#df6249",
	go_table = { -- `g` to open go menu(global mode)
		{ on = { "h" }, run = "cd ~",           desc = "Go to home" },
		{ on = { "c" }, run = "cd ~/.config",   desc = "Go to config" },
		{ on = { "u" }, run = "cd /media/UUI/", desc = "Go to Mobile disk" },
	}
})

