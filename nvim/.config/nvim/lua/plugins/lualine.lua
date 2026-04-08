local section_sep_left = ''
local section_sep_right = ''
local section_sep_left_alt = ''
local section_sep_right_alt = ''
local component_sep_left = ''
local component_sep_right = ''

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      component_separators = { left = component_sep_left, right = component_sep_left },
      section_separators = { left = section_sep_left, right = section_sep_left_alt },
      disabled_filetypes = {
        statusline = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles', 'AgenticDiagnostics' },
        winbar = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles', 'AgenticDiagnostics' },
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        {
          function()
            local parts = {}
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if #clients > 0 then
              local names = {}
              for _, c in ipairs(clients) do
                table.insert(names, c.name)
              end
              table.insert(parts, ' LSP  ' .. table.concat(names, '  '))
            end
            local conform = package.loaded['conform']
            if conform then
              local formatters = conform.list_formatters(0)
              if #formatters > 0 then
                local names = {}
                for _, f in ipairs(formatters) do
                  table.insert(names, f.name)
                end
                table.insert(parts, '󰉼 FMT  ' .. table.concat(names, ' ' .. component_sep_left .. ' '))
              end
            end
            local lint = package.loaded['lint']
            if lint then
              local linters = lint.linters_by_ft[vim.bo.filetype] or {}
              if #linters > 0 then
                table.insert(parts, '󱉶 LINT  ' .. table.concat(linters, ' ' .. component_sep_left .. ' '))
              end
            end
            return table.concat(parts, ' ' .. component_sep_left .. ' ')
          end,
        },
      },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    tabline = {
      lualine_a = {
        {
          'buffers',
        },
      },
      lualine_z = {
        {
          'tabs',
        },
      },
    },
  },
}
