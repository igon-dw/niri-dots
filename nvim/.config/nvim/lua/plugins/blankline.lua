-- Returns configuration table for indent-blankline.nvim plugin
return {
  -- Plugin repository name (GitHub: lukas-reineke/indent-blankline.nvim)
  'lukas-reineke/indent-blankline.nvim',
  -- Plugin main module name
  main = 'ibl',
  ---@module "ibl"  -- Neovim type annotation
  ---@type ibl.config -- ibl configuration type
  opts = {
    indent = {
      -- Highlight groups for color-coded indentation levels
      highlight = {
        'RainbowRed',    -- Red indent level
        'RainbowYellow', -- Yellow indent level
        'RainbowBlue',   -- Blue indent level
        'RainbowOrange', -- Orange indent level
        'RainbowGreen',  -- Green indent level
        'RainbowViolet', -- Violet indent level
        'RainbowCyan',   -- Cyan indent level
      },
    },
  },
  -- Plugin setup function
  config = function(_, opts)
    -- Load ibl.hooks module
    local hooks = require 'ibl.hooks'
    -- Register highlight setup hook
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- Assign colors to each highlight group
      vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
      vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
      vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
      vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
      vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
      vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
      vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
    end)
    -- Execute plugin setup
    require('ibl').setup(opts)
  end,
}
