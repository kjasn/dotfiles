return {
    {
        "williamboman/mason.nvim",
        opts = {}, -- You can add Mason options here if needed
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            -- Ensure servers installed with Mason are automatically set up
            ensure_installed = {}, -- You can list servers here to ensure they are installed
            automatic_installation = true, -- Optional: Automatically install servers listed in ensure_installed
        },
    },
    {
        "neovim/nvim-lspconfig",
        -- Add dependencies
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            -- Add other LSP-related plugins like completion sources if needed
            -- e.g., "hrsh7th/cmp-nvim-lsp",
        },
        opts = {
            -- diagnostics settings remain the same
            diagnostics = {
                virtual_text = false,
                float = {
                    border = "rounded",
                    source = "always",
                    wrap = true,
                    max_width = 80, -- Adjusted from the config block's 200, can be changed back if preferred
                    focusable = false,
                    close_events = { "CursorMoved", "InsertEnter", "BufLeave" },
                },
            },
            -- Move server setup function here, managed by mason-lspconfig
            servers = {}, -- Let mason-lspconfig handle server setup by default
        },
        config = function(_, opts)
            -- Get the lspconfig capabilities function (often customized by completion plugins)
            -- If you use nvim-cmp, it typically provides this:
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            -- If not using nvim-cmp or similar, use default capabilities:
            -- local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- Use mason-lspconfig's setup handler
            -- This iterates through your installed servers and calls lspconfig.server.setup
            require("mason-lspconfig").setup_handlers({
                function(server_name) -- Default handler
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        -- You can add server-specific overrides here if needed
                        -- on_attach = require("config.lsp").on_attach, -- Make sure your on_attach function is required correctly if you use it
                    })
                end,
                -- Example of overriding settings for a specific server:
                -- ["gopls"] = function()
                --   require("lspconfig").gopls.setup({
                --     capabilities = capabilities,
                --     settings = {
                --       gopls = {
                --         -- add gopls specific settings here
                --       }
                --     }
                --   })
                -- end,
            })

            -- Apply the diagnostic settings from opts
            vim.diagnostic.config(opts.diagnostics)

            -- Your CursorHold diagnostic popup autocommand (optional, can be kept or removed)
            vim.api.nvim_create_autocmd("CursorHold", {
                group = vim.api.nvim_create_augroup("AutoShowDiagnostics", { clear = true }),
                callback = function()
                    local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
                    if #diagnostics > 0 then
                        vim.diagnostic.open_float(nil, {
                            scope = "line",
                            border = opts.diagnostics.float.border,
                            source = opts.diagnostics.float.source,
                            wrap = opts.diagnostics.float.wrap,
                            max_width = opts.diagnostics.float.max_width,
                            focusable = opts.diagnostics.float.focusable,
                        })
                    end
                end,
            })

             -- Optional: Add keymaps for LSP actions here if not defined elsewhere
             -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
             -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
             -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
             -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
        end,
    },
}
