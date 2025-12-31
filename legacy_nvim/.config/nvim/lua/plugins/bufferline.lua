-- Returns configuration table for bufferline.nvim plugin
return {
  -- Plugin repository name (GitHub: akinsho/bufferline.nvim)
  'akinsho/bufferline.nvim',
  -- Version specification (* means latest version)
  version = '*',
  -- Dependency plugins (for icon display)
  dependencies = 'nvim-tree/nvim-web-devicons',
  -- Plugin setup function
  config = function()
    require('bufferline').setup {}
  end,
}
