return {
	"nvim-mini/mini.nvim",
	version = "*",
	lazy = true,
	keys = {
		{
			"<leader>E",
			-- ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>:lua MiniFiles.reveal_cwd()<cr>",
			":lua MiniFiles.open()<cr>",
			desc = "File Structure(cwd)",
		},
		{
			"<leader>e",
			":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>:lua MiniFiles.reveal_cwd()<cr>",
			desc = "File Structure(Root Dir)",
		},
	},
	config = function()
		require("mini.files").setup()
	end,
}
