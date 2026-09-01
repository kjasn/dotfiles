return {
	"akinsho/bufferline.nvim",
	opts = {
		options = {
			-- Enale/disable file icon path for bufferline
			show_buffer_path = true,
		},
		highlights = {
			-- Use emphasis instead of a background so diagnostic colors stay readable.
			buffer_selected = {
				fg = "#cba6f7",
				bg = "NONE",
				bold = true,
				underline = true,
			},
			close_button_selected = {
				bg = "NONE",
			},
			separator_selected = {
				bg = "NONE",
			},
			-- Keep the diagnostic indicator colors while removing the selected-tab background.
			diagnostic_selected = { bg = "NONE" },
			error_selected = { bg = "NONE" },
			error_diagnostic_selected = { bg = "NONE" },
			warning_selected = { bg = "NONE" },
			warning_diagnostic_selected = { bg = "NONE" },
			info_selected = { bg = "NONE" },
			info_diagnostic_selected = { bg = "NONE" },
			hint_selected = { bg = "NONE" },
			hint_diagnostic_selected = { bg = "NONE" },
		},
	},
}

