return {
	"petertriho/nvim-scrollbar",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		{
			"kevinhwang91/nvim-hlslens",
			config = function()
				require("hlslens").setup({
					build_position_cb = function(plist, _, _, _)
						require("scrollbar.handlers.search").handler.show(plist.start_pos)
					end,
				})
			end,
		},
	},
	opts = {
		handle = {
			text = " ",
			color = "#C7E9E4",
		},
		handlers = {
			gitsigns = true,
			search = true,
		},
	},
}
