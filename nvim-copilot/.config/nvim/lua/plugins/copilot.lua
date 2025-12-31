-- Copilot.lua plugin configuration
-- https://github.com/zbirenbaum/copilot.lua

return {
	"zbirenbaum/copilot.lua",
	-- Lazy load the plugin on InsertEnter event
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				keymap = {
					accept = "<C-y>",
					accept_word = "<C-i>",
				},
			},
			panel = { enabled = true },
			filetypes = {
				sh = true, -- enable for shell scripts
				py = true, -- enable for Python files
				go = true, -- enable for Go files
				markdown = true, -- enable for Markdown files
				dockerfile = true, -- enable for Dockerfiles
				yml = true, -- enable for YAML files
				yaml = true, -- enable for YAML files
				-- Note: filetypes not explicitly listed here are enabled by default
				-- Use default = false to disable completion for unlisted filetypes
			},
		})

		-- Register AI group in which-key (dynamic registration)
		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>a", group = "[A]I" },
			})
		end
	end,
}
