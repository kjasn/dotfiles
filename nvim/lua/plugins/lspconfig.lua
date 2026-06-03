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
				buf_ls = {}, -- reads buf.yaml, resolves proto imports correctly
				-- gopls will be automatically installed with mason and loaded with lspconfig
				gopls = {
					capabilities = vim.lsp.protocol.make_client_capabilities(),
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
			setup = {
				gopls = function()
					-- Disable LazyVim's gopls semantic-token shim, which is incompatible
					-- with Neovim 0.12's semantic token decoder.
				end,
			},
		},
	},
}
