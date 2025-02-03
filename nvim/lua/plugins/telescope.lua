local layout_strategies = require("telescope.pickers.layout_strategies")
local previewer = require("telescope.previewers.previewer")
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        -- layout_strategy = "horizontal",
        path_display = { "shorten" },
        dynamic_preview_title = true,
        layout_config = {
          horizontal = {
            preview_width = 0.5,
            preview_cutoff = 30,
          },
          vertical = {
            preview_width = 0.5,
            preview_cutoff = 30,
          },
          width = { padding = 6 },
          height = { padding = 3 },
        },
      },
    })
    telescope.load_extension("live_grep_args")
  end,
}
