return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "jay-babu/mason-null-ls.nvim",
    },
    config = function()
        local none_ls = require("null-ls")

        -- 格式化和诊断工具
        local formatting = none_ls.builtins.formatting
        local diagnostics = none_ls.builtins.diagnostics

        require("null-ls").setup({
            sources = {
                formatting.prettierd, -- Prettier 格式化
                diagnostics.eslint_d, -- ESLint 诊断
            },
            on_attach = function(client, bufnr)
                -- 自动保存时格式化
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })

        -- mason-null-ls 自动安装支持
        require("mason-null-ls").setup({
            ensure_installed = {
                "prettierd",
                "eslint_d",
            },
            automatic_installation = true,
        })
    end,
}
