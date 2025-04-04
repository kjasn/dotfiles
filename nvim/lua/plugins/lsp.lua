return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                virtual_text = false, -- Disable inline virtual text to avoid clutter
                float = {
                    border = "rounded", -- Add a border to the floating window
                    source = "always", -- Show the source of the diagnostic (e.g., ts_ls)
                    wrap = true, -- Ensure long messages wrap
                    max_width = 80, -- Force wrapping at a reasonable width
                    focusable = false, -- Prevent the window from stealing focus
                    close_events = { "CursorMoved", "InsertEnter", "BufLeave" }, -- Close the window on these events
                },
            },
        },
        config = function()
            -- Ensure the diagnostic config is applied globally
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
        end,
        -- Set up an autocommand to show diagnostics on CursorHold
        vim.api.nvim_create_autocmd("CursorHold", {
            group = vim.api.nvim_create_augroup("AutoShowDiagnostics", { clear = true }),
            callback = function()
                -- Check if there are diagnostics on the current line
                local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
                if #diagnostics > 0 then
                    vim.diagnostic.open_float(nil, {
                        scope = "line", -- Show diagnostics for the current line
                        border = "rounded",
                        source = "always",
                        wrap = true,
                        max_width = 80,
                        focusable = false,
                    })
                end
            end,
        }),
    },
}
