return {
	{
		"folke/tokyonight.nvim",
		opts = {
			on_highlights = function(highlights, colors)
				-- Set the cursor color
				highlights.Cursor = {
					bg = "#FF5843",
				}
			end,
		},
	},
}

