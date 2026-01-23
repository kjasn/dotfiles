return {
	"yetone/avante.nvim",
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	version = false,
	lazy = false,
	---@module 'avante'
	---@type avante.Config
	opts = {
		provider = "copilot",
		auto_suggestions_provider = "copilot", -- 使用 copilot 作为自动提示 provider
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 600, -- 延迟 600ms 触发，避免频繁请求
		},
		selection = {
			hint_display = "true",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"ibhagwan/fzf-lua",
		"zbirenbaum/copilot.lua",
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
		{
			"folke/which-key.nvim",
			optional = true,
			opts = {
				spec = {
					{ "<leader>a", group = "ai" },
				},
			},
		},
	},
}
