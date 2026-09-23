return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
			-- show virtual text for Error only, hide for Warning, Info and Hint
			virtual_text = {
				severity = { min = vim.diagnostic.severity.ERROR },
				source = "if_many",
			},

			-- keep signs for Warning and Error only, hide for Info and Hint
			signs = {
				severity = { min = vim.diagnostic.severity.WARN },
			},

			-- show underline for Warning and Error only, hide for Info and Hint
			-- underline = {
			-- 	severity = { min = vim.diagnostic.severity.WARN },
			-- },
		})
		return opts
	end,
}
