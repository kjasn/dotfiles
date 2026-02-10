return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		opts = {
			custom_highlights = function(colors)
				return {
					WinSeparator = { fg = colors.lavender },
				}
			end,
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
		},
		specs = {
			{
				"akinsho/bufferline.nvim",
				optional = true,
				opts = function(_, opts)
					if (vim.g.colors_name or ""):find("catppuccin") then
						opts.highlights = require("catppuccin.special.bufferline").get_theme()
					end
				end,
			},
		},
	},
}
