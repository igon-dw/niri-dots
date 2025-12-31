local state_file = vim.fn.stdpath 'state' .. '/colorscheme_state.txt'
local default_scheme = 'everforest'

local function load_colorscheme()
  local file = io.open(state_file, 'r')
  if file then
    local scheme = file:read '*l'
    file:close()
    return scheme and scheme ~= '' and scheme or default_scheme
  end
  return default_scheme
end

local function save_colorscheme(scheme)
  if not scheme or scheme == '' then
    return
  end
  local state_dir = vim.fn.fnamemodify(state_file, ':h')
  vim.fn.mkdir(state_dir, 'p')
  local file = io.open(state_file, 'w')
  if file then
    file:write(scheme)
    file:close()
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('colorscheme-persist', { clear = true }),
  callback = function()
    if vim.g.colors_name then
      save_colorscheme(vim.g.colors_name)
    end
  end,
})

local function apply_saved_colorscheme()
  local scheme = load_colorscheme()
  local ok = pcall(vim.cmd.colorscheme, scheme)
  if not ok then
    vim.notify('Failed to load colorscheme: ' .. scheme, vim.log.levels.WARN)
    pcall(vim.cmd.colorscheme, default_scheme)
  end
end

return {
  { 'catppuccin/nvim', name = 'catppuccin', lazy = false, priority = 1000 },
  { 'rebelot/kanagawa.nvim', lazy = false, priority = 1000 },
  { 'folke/tokyonight.nvim', lazy = false, priority = 1000 },
  { 'navarasu/onedark.nvim', lazy = false, priority = 1000 },
  {
    'neanias/everforest-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup { transparent_background = false }
      require('kanagawa').setup { transparent = false }
      require('tokyonight').setup { transparent = false }
      require('onedark').setup {}
      require('everforest').setup { background = 'hard', transparent_background_level = 0 }
      apply_saved_colorscheme()
    end,
  },
}
