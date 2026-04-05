return {
  'carlos-algms/agentic.nvim',
  opts = {
    provider = 'codex-acp',
  },
  keys = {
    {
      '<leader>aa',
      function()
        require('agentic').toggle()
      end,
      mode = { 'n', 'v' },
      desc = 'Toggle Agentic Chat',
    },
    {
      '<leader>ac',
      function()
        require('agentic').add_selection_or_file_to_context()
      end,
      mode = { 'n', 'v' },
      desc = 'Add File or Selection to Agentic',
    },
    {
      '<leader>an',
      function()
        require('agentic').new_session()
      end,
      mode = { 'n', 'v' },
      desc = 'New Agentic Session',
    },
    {
      '<leader>ar',
      function()
        require('agentic').restore_session()
      end,
      mode = { 'n', 'v' },
      desc = 'Restore Agentic Session',
    },
    {
      '<leader>ad',
      function()
        require('agentic').add_current_line_diagnostics()
      end,
      mode = { 'n' },
      desc = 'Add Current Diagnostic to Agentic',
    },
    {
      '<leader>aD',
      function()
        require('agentic').add_buffer_diagnostics()
      end,
      mode = { 'n' },
      desc = 'Add Buffer Diagnostics to Agentic',
    },
  },
}
