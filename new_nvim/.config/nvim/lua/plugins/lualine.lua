return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        {
          function()
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if #clients == 0 then
              return ''
            end
            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, '[' .. client.name .. ']')
            end
            return ' ' .. table.concat(names, ' ') .. ' running'
          end,
          icon = '',
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
