# Agent Rules for This Repo

Purpose
- This file is for AI coding agents operating in this repository.
- Follow these rules strictly. If a rule is unclear, read the repo for context first.

Repo Basics
- Repo type: macOS dotfiles.
- Primary audience: AI agents only.
- Preferred package manager: Homebrew.

Quick Start (Manual)
- Install: `./install.sh`
- Uninstall: `./uninstall.sh`

Build, Lint, Test
- This repo is configuration-focused; no centralized build/lint/test runner is defined.
- Prefer validating changes by:
  - Running `./install.sh` in a safe test environment (e.g. new user or VM).
  - Running `./uninstall.sh` to ensure cleanup still works.
  - Running app-specific validation as described in component configs (e.g. Neovim).

Single Test Guidance
- There is no test harness. “Single test” means a scoped validation step.
- Use the smallest command that validates your change. Examples:
  - Neovim plugins: `nvim --headless "+Lazy! sync" +qa`
  - Treesitter: `nvim --headless "+TSUpdate" +qa`
  - Tree-sitter CLI present: `tree-sitter --version`
  - Shell config: start a fresh shell and source config (`zsh -l`).

Must-Read Docs
- `README.md` is user-facing and must stay accurate.
- `install.sh` and `uninstall.sh` define system changes. Keep them in sync with config changes.

Cursor/Copilot Rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` found.
- If any appear later, incorporate them here and obey them.

Update Policy (Strict)
- If you change config files, check whether `install.sh`, `uninstall.sh`, and `README.md` need updates.
- If you add a new tool or dependency, add install steps (Homebrew preferred) and uninstall steps.
- If you change paths or filenames, update symlink logic and docs.
- If you add a new script, document usage in `README.md`.

Code Style (Shell)
- Use bash for scripts unless existing file uses another shell.
- Keep `set -e` semantics consistent with existing scripts.
- Quote variables and paths; avoid globbing surprises.
- Use functions for logical sections; keep them small and single-purpose.
- Prefer explicit error handling and user-facing messages.
- Avoid destructive operations unless clearly documented and gated by confirmation.

Code Style (General)
- Keep files ASCII unless the file already uses non-ASCII.
- Preserve existing style and formatting in the file you edit.
- Keep comments minimal and only for non-obvious behavior.
- Prefer small, focused changes; avoid reformat-only edits.

Imports and Formatting
- Not applicable to shell scripts; follow existing formatting.
- For Lua/Neovim configs: match existing conventions in `nvim/`.

Types and Naming
- Use descriptive function names; avoid abbreviations.
- Use snake_case in shell scripts.
- Use consistent variable naming within a file.

Error Handling and UX
- Fail fast for missing dependencies or invalid OS.
- Print clear errors and next steps.
- When user choices are needed, prompt explicitly and default to safe behavior.

Homebrew Guidance
- Prefer `brew install` for new dependencies.
- If Homebrew is required, ensure the install path is set for Apple Silicon.
- Avoid using `brew install` for tools that should be managed by language-specific managers unless that is already the repo pattern.

Symlinks and Backups
- Use existing `create_symlink` behavior.
- Preserve backup semantics (`.bak.<timestamp>`).
- Do not overwrite user files without backup or prompt.

Neovim/LazyVim Notes
- Plugin sync: `nvim --headless "+Lazy! sync" +qa`
- Treesitter update: `nvim --headless "+TSUpdate" +qa`
- Tree-sitter CLI is required for parser builds.

Scripts
- Scripts live in `scripts/` and should be executable.
- Update usage examples in `README.md` when scripts change.

Branching and Safety
- Never delete or reset user data.
- Avoid `rm -rf` unless scope is restricted and explained.
- Do not modify git config or user secrets.

What to Do When Unsure
- Read the nearest relevant config file.
- Check `install.sh`, `uninstall.sh`, and `README.md` for consistency.
- Ask a single targeted question only if a decision materially changes behavior.

Checklist Before You Finish
- If config changed, confirm install/uninstall/README updates are considered.
- If adding dependencies, ensure brew install/uninstall steps exist.
- If adding scripts, ensure README usage is documented.
- Confirm commands listed above still apply.
