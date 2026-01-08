return {
  'github/copilot.vim',
  cmd = 'Copilot',
  event = { 'InsertEnter', 'BufReadPre', 'BufNewFile' },
  init = function()
    -- Keybindings using Alt key combinations to avoid conflicts with blink.cmp
    -- Alt+Y: Accept suggestion
    vim.keymap.set('i', '<M-y>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      silent = true,
    })
    
    -- Disable Tab mapping to avoid conflicts
    vim.g.copilot_no_tab_map = true
    
    -- Alt+W: Accept next word
    vim.keymap.set('i', '<M-w>', '<Plug>(copilot-accept-word)', { silent = true })
    
    -- Alt+L: Accept next line
    vim.keymap.set('i', '<M-l>', '<Plug>(copilot-accept-line)', { silent = true })
    
    -- Alt+]: Next suggestion
    vim.keymap.set('i', '<M-]>', '<Plug>(copilot-next)', { silent = true })
    
    -- Alt+[: Previous suggestion
    vim.keymap.set('i', '<M-[>', '<Plug>(copilot-previous)', { silent = true })
    
    -- Ctrl+]: Dismiss suggestion
    vim.keymap.set('i', '<C-]>', '<Plug>(copilot-dismiss)', { silent = true })
  end,
}
