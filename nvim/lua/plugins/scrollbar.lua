return {
	"petertriho/nvim-scrollbar",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"kevinhwang91/nvim-hlslens",
	},
	opts = {},
	config = function()
		require("scrollbar").setup({
			handle = {
				text = " ",
				color = "#C7E9E4",
			},
		})
		require("gitsigns").setup()
		require("hlslens").setup({
			build_position_cb = function(plist, _, _, _)
				require("scrollbar.handlers.search").handler.show(plist.start_pos)
			end,
		})
		require("scrollbar.handlers.gitsigns").setup()
		require("scrollbar.handlers.search").setup()
	end,
}
