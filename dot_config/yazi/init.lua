require("searchjump"):setup({
	unmatch_fg = "#736e6b",
	match_str_fg = "#82a2d9",
	match_str_bg = "#242730",
	first_match_str_fg = "#000000",
	first_match_str_bg = "#73AC3A",
	label_fg = "#92bf8e",
	label_bg = "#242730",
	only_current = false,
	show_search_in_statusbar = false,
	auto_exit_when_unmatch = false,
	enable_capital_label = true,
	search_patterns = ({ "hell[dk]d", "%d+.1080p", "第%d+集", "第%d+话", "%.E%d+", "S%d+E%d+", })
})
