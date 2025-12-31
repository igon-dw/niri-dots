return {
  'hat0uma/csvview.nvim',
  ft = { 'csv' },
  opts = {
    parser = { async_chunksize = 50 },
    view = {
      min_column_width = 5,
      spacing = 2,
      display_mode = 'border',
    },
  },
  config = function(_, opts)
    require('csvview').setup(opts)
    require('csvview').enable()
  end,
}
