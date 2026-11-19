return {
	-- Git Diff Viewer
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		opts = {
			keymaps = {
				view = {
					focus_explorer = false,
					hunk_textobject = false,
				},
			},
		},
		config = function(_, opts)
			require("codediff").setup(opts)
			require("config.codediff").setup_explorer()
		end,
	},
}
