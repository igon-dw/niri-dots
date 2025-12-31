return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline_popup', -- centered popup
    },
    messages = { enabled = false }, -- use default messages (Snacks.notifier handles notify)
    popupmenu = { enabled = true },
    notify = { enabled = false }, -- Snacks.notifier handles this
    lsp = {
      progress = { enabled = false }, -- fidget.nvim handles this
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      command_palette = true, -- centered cmdline with popup menu
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
}
