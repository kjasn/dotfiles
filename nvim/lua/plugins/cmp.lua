return {
    "hrsh7th/cmp-cmdline",
    config = function()
        local cmp = require("cmp")

        -- config for editor
        cmp.setup({
            mapping = {
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<Up>"] = cmp.mapping.select_prev_item(),
                ["<Down>"] = cmp.mapping.select_next_item(),

                ["<CR>"] = cmp.mapping(function(fallback)
                    fallback()
                end),
            },
        })

        -- config for cmd line
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = {
                    c = cmp.mapping.confirm({ select = false }),
                },
            }),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })
    end,
}
