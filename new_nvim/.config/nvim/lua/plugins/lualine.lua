return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        {
          'lsp_status',
          icon = '', -- f013
          symbols = {
            -- Standard unicode symbols to cycle through for LSP progress:
            spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
            -- Standard unicode symbol for when LSP is done:
            done = '✓',
            -- Delimiter inserted between LSP names:
            separator = ' ',
          },
          -- List of LSP names to ignore (e.g., `null-ls`):
          ignore_lsp = {},
          -- Display the LSP name
          show_name = true,
        },
      },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    tabline = {
      lualine_a = { 'buffers' },
      lualine_z = { 'tabs' },
    },
  },
}
