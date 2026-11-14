return {
	{
		"kjasn/flash.nvim",
		branch = "feat/Chinese-chracter-pronounce",
		version = false,
		build = "python3 scripts/generate_pinyin.py",
		opts = {
			search = {
				pinyin = true,
				pinyin_options = {
					-- settings here
					cross_character = true,
					initials = true,
					mixed = true,
					retain_search = true,
				},
			},
		},
	},
}
