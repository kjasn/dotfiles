return {
	{
		"LazyVim/LazyVim",
		opts = {
			-- colorscheme = "catppuccin-latte",
			colorscheme = "catppuccin-macchiato",
		},
	},
	{
		"catppuccin/nvim",
		opts = function(_, opts)
			opts.flavour = "mocha"
			opts.integrations = opts.integrations or {}
			opts.integrations.mini = true
			opts.transparent_background = true
			opts.custom_highlights = function(colors)
				return {
					WinSeparator = { fg = colors.lavender },
				}
			end
		end,
	},
}
