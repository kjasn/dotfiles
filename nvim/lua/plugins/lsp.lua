return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                virtual_text = false,
                float = {
                    border = "rounded",
                    source = "always",
                    wrap = true,
                    max_width = 80,
                    focusable = false,
                    close_events = { "CursorMoved", "InsertEnter", "BufLeave" },
                },
            },
        },
        config = function()
            -- 全局设置诊断显示
            vim.diagnostic.config({
                virtual_text = false,
                float = {
                    border = "rounded",
                    source = "always",
                    wrap = true,
                    max_width = 200,
                    focusable = false,
                    close_events = { "CursorMoved", "InsertEnter", "BufLeave" },
                },
            })

            -- 设置 CursorHold 自动弹出诊断浮窗
            vim.api.nvim_create_autocmd("CursorHold", {
                group = vim.api.nvim_create_augroup("AutoShowDiagnostics", { clear = true }),
                callback = function()
                    local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
                    if #diagnostics > 0 then
                        vim.diagnostic.open_float(nil, {
                            scope = "line",
                            border = "rounded",
                            source = "always",
                            wrap = true,
                            max_width = 80,
                            focusable = false,
                        })
                    end
                end,
            })
        end,
    },
}
