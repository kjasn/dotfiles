return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Configure the servers that will be set up
      servers = {
        -- gopls will be automatically installed with mason and loaded with lspconfig
        gopls = {},
      },
    },
    ---@param client lsp.Client
    ---@param bufnr integer
    on_attach = function(client, bufnr)
      -- Reference the utility function for organizing imports
      local lsp_utils = require("utils.lsp")

      -- Set up autocmd for BufWritePre in the on_attach function for Go files
      if client.name == "gopls" then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            lsp_utils.organize_imports(1000)
            vim.lsp.buf.format({ timeout_ms = 2000 })
          end,
          desc = "Organize imports and format on save for Go files",
        })
      end
    end,
  },
}