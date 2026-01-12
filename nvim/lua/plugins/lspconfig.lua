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
				vtsls = {
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					settings = {
						vtsls = {
							tsserver = {
								globalPlugins = {
									{
										name = "@vue/typescript-plugin",
										location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
										languages = { "vue" },
										configNamespace = "typescript",
										enableForWorkspaceTypeScriptVersions = true,
									},
								},
							},
						},
					},
				},
				vue_ls = {
					init_options = {
						typescript = {
							tsdk = vim.fn.stdpath("data") .. "/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib",
						},
					},
				},
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
				gopls = function()
					-- Auto organize imports on save for Go files
					vim.api.nvim_create_autocmd("BufWritePre", {
						pattern = "*.go",
						callback = function()
							local params = vim.lsp.util.make_range_params()
							params.context = { only = { "source.organizeImports" } }
							local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
							for cid, res in pairs(result or {}) do
								for _, r in pairs(res.result or {}) do
									if r.edit then
										local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
										vim.lsp.util.apply_workspace_edit(r.edit, enc)
									end
								end
							end
						end,
					})
				end,
			},
		},
	},
}
