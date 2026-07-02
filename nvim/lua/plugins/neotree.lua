return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			enable_diagnostics = true,
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
			window = {
				mappings = {
					["s"] = "none",
				},
			},
		},
		keys = {
			{ "<leader>e", false },
			{
				"<leader>E",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
				end,
				desc = "Explorer NeoTree (Root Dir)",
			},
		},
	},
}
