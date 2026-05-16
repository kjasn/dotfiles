return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason.nvim",
			"mason-lspconfig.nvim",
		},
		opts = {
			-- Configure the servers that will be set up
			servers = {
				-- gopls will be automatically installed with mason and loaded with lspconfig
				gopls = {
					settings = {
						gopls = {
							-- Enable gofumpt instead of gofmt
							gofumpt = true,
							-- Enable unused import removal
							analyses = {
								unusedparams = true,
								unusedwrite = true,
								unusedvariable = true,
							},

							staticcheck = true,
							-- Performance optimization for large projects
							completeUnimported = true,
							usePlaceholders = true,
							-- Disable expensive operations in large projects
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },
						},
					},
				},
			},
		},
	},
}
