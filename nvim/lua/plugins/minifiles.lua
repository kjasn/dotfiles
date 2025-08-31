return {
	"echasnovski/mini.files",
	version = "*",
	lazy = true,
	keys = {
		{
			"<leader>e",
			":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>:lua MiniFiles.reveal_cwd()<cr>",
			{ desc = "MiniFiles" },
		},
	},
	config = function()
		require("mini.files").setup()
	end,
}
