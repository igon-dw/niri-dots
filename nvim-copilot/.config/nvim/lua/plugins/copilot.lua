-- Copilot.lua plugin configuration
-- https://github.com/zbirenbaum/copilot.lua

return {
  'zbirenbaum/copilot.lua',
  -- Lazy load the plugin on InsertEnter event
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = { enabled = true, auto_trigger = true, hide_during_completion = false },
      panel = { enabled = true },
      filetypes = {
        sh = true, -- enable for shell scripts
        py = true, -- enable for Python files
        go = true, -- enable for Go files
        markdown = true, -- enable for Markdown files
        -- Note: filetypes not explicitly listed here are enabled by default
        -- Use default = false to disable completion for unlisted filetypes
      },
    }
    -- Copilot suggestion keymaps
    -- Ctrl-y: Accept full suggestion
    vim.keymap.set('i', '<C-y>', function()
      require('copilot.suggestion').accept()
    end, { desc = 'Copilot: Accept suggestion' })

    -- Ctrl-i: Accept next word
    vim.keymap.set('i', '<C-i>', function()
      require('copilot.suggestion').accept_word()
    end, { desc = 'Copilot: Accept next word' })

    -- Register AI group in which-key (dynamic registration)
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add {
        { '<leader>a', group = '[A]I' },
      }
    end
  end,
}
