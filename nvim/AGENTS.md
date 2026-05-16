# Agent Rules for This LazyVim Config

Purpose
- This directory is the user's LazyVim/Neovim configuration.
- Follow these rules before changing plugin, LSP, Tree-sitter, folding, or startup behavior.
- Prefer current official LazyVim and lazy.nvim documentation over memory.
- Keep guidance and commands portable across devices; do not hard-code machine-specific home paths.

Core LazyVim Policy
- Use `lazyvim.json` as the single source of truth for LazyVim extras.
- Do not manually add `lazyvim.plugins.extras.*` imports to `lua/config/lazy.lua`.
- Keep `lua/config/lazy.lua` focused on bootstrapping LazyVim and importing local specs:

```lua
spec = {
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  { import = "plugins" },
}
```

- Manage extras with `:LazyExtras`; commit intentional `lazyvim.json` changes.
- Avoid duplicating an extra in both `lazyvim.json` and `lua/config/lazy.lua`.

Current Extras
- The current extras list is managed in `lazyvim.json`.
- Extras currently used include Copilot, DAP core, Prettier, ESLint, Go, JSON, Markdown, Python, Rust, TOML, TypeScript, Vue, and YAML.
- If adding/removing extras, update `lazyvim.json` through `:LazyExtras` when possible.

Plugin Spec Rules
- Custom plugin specs live in `lua/plugins/*.lua`.
- Because `defaults.lazy = false`, custom plugins load at startup unless they have lazy-load triggers.
- New custom plugins should normally define one or more of `event`, `cmd`, `ft`, or `keys`.
- When overriding LazyVim-managed plugins, prefer `opts` or `opts = function(_, opts)` over `config = function() require(...).setup(...) end`.
- Do not call a plugin `setup()` twice unless the plugin documentation explicitly requires it.
- Do not pin plugins with `version = "*"` unless there is a concrete compatibility reason.

Performance Guardrails
- Do not set raw Tree-sitter folding globally:
  - Avoid `opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"`.
  - Let LazyVim choose its guarded fold expression.
- Do not override `nvim-treesitter` `build` or `event` just to add parsers.
- Do not duplicate Tree-sitter parsers already provided by LazyVim extras.
- If a manual parser is truly needed, extend `ensure_installed` with a duplicate check.
- Do not add formatters such as `stylua` as LSP servers.
- Avoid re-declaring LSP servers already provided by extras unless adding real custom settings.
- Keep Git/search/UI plugins lazy-loaded when possible. In particular, do not configure `gitsigns.nvim`, `nvim-scrollbar`, or `nvim-hlslens` in a way that forces startup loading.

Known Good Local Patterns
- `gitsigns.nvim` custom options belong in `lua/plugins/gitsigns.lua` via `opts`.
- Scrollbar/search UI should use lazy triggers such as `event = "VeryLazy"`.
- Tree-sitter language support should mostly come from LazyVim language extras.
- `lua/plugins/treesitter.lua` can be absent or empty unless there is a specific parser not covered by enabled extras.
- `rocks.enabled = false` is intentional because no current plugin requires LuaRocks and this keeps lazy.nvim health clean.

Validation
- For headless checks, prefer `nvim -i NONE --headless ...` to avoid ShaDa temp-file noise.
- Run focused checks after config changes:

```sh
stylua --check lua/config/lazy.lua lua/plugins/*.lua
nvim -i NONE --headless '+checkhealth lazy vim.lsp' '+w! $TMPDIR/nvim-health.txt' '+qa'
nvim -i NONE --headless '+lua local s=require("lazy").stats(); print("count="..s.count.." loaded="..s.loaded)' '+qa'
```

- If `stylua` is not on `PATH`, install it with Mason or Homebrew instead of hard-coding one machine's Mason path.

- If changing Tree-sitter or language extras, verify there are no duplicate parsers:

```sh
nvim -i NONE --headless '+lua local list=LazyVim.opts("nvim-treesitter").ensure_installed or {}; local seen,dups={},{}; for _,x in ipairs(list) do if seen[x] then dups[x]=true end; seen[x]=true end; local out={}; for x in pairs(dups) do out[#out+1]=x end; table.sort(out); if #out>0 then error("duplicate parsers: "..table.concat(out, ", ")) end; print("treesitter parser check ok")' '+qa'
```

Before Finishing
- Check whether `lazyvim.json`, `lazy-lock.json`, and local plugin specs changed intentionally.
- Leave unrelated user changes alone.
- Do not delete or reset user files.
