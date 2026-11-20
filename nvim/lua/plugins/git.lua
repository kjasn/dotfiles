return {
	-- Keep picker loading from taking over the CodeDiff shortcut.
	{
		"ibhagwan/fzf-lua",
		optional = true,
		keys = { { "<leader>gd", false } },
	},
	{
		"folke/snacks.nvim",
		optional = true,
		keys = { { "<leader>gd", false } },
	},
	-- Git Diff Viewer
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		keys = {
			{ "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Review Git Changes (CodeDiff)" },
		},
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
