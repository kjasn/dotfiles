-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require('config.clipboard')

-- import lsp config
local on_attach = require("config.lsp").on_attach
require("lspconfig").tsserver.setup({
  on_attach = on_attach,
})

-- set code wrap, display one line in more lines when it can not shows in one line
vim.opt.wrap = true
vim.opt.linebreak = true
