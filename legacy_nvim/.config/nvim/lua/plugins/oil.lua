return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    {
      '<leader>e',
      function()
        require('oil').open(dir)
      end,
      desc = 'Open File Manager (Oil)',
    },
  },
}
