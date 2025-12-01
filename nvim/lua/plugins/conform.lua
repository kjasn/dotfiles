return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		-- Set up formatters
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "gofmt", "gofumpt", "goimports" },
			python = { "isort", "black" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
		-- Enable formatting on save
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}

