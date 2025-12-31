-- Returns configuration table for nvim-autopairs plugin
return {
  -- Plugin repository name (GitHub: windwp/nvim-autopairs)
  'windwp/nvim-autopairs',
  -- Lazy load on InsertEnter event
  event = 'InsertEnter',
  -- Enable default configuration (config = true auto-executes setup function)
  config = true,
  -- Plugin options (empty table uses default settings)
  opts = {},
}
