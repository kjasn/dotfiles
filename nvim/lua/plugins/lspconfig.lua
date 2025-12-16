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
						},
					},
				},
				eslint = {},
			},
			setup = {
				eslint = function()
					Snacks.util.lsp.on(function(bufnr, client)
						if client and client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = true
						elseif client and client.name == "tsserver" then
							client.server_capabilities.documentFormattingProvider = false
						end
					end)
				end,
			},
		},
	},
}
