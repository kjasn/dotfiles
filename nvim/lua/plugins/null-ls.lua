return {
    "jose-elias-alvarez/null-ls.nvim", -- 安装 null-ls 插件
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.prettierd, -- 使用 Prettier 作为格式化工具
            },
        })
    end,
}
