-- カラースキーム永続化ファイルのパス
local state_file = vim.fn.stdpath('config') .. '/colorscheme_state.txt'
local default_scheme = 'everforest'

-- 保存されたカラースキームを読み込む
local function load_colorscheme()
  local file = io.open(state_file, 'r')
  if file then
    local scheme = file:read('*l')
    file:close()
    return scheme and scheme ~= '' and scheme or default_scheme
  end
  return default_scheme
end

-- カラースキームを保存する
local function save_colorscheme(scheme)
  local file = io.open(state_file, 'w')
  if file then
    file:write(scheme)
    file:close()
  end
end

-- カラースキーム変更時に自動保存
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    save_colorscheme(vim.g.colors_name)
  end,
})

-- 各プラグインのsetup関数
local function setup_plugins()
  require('catppuccin').setup { transparent_background = false }
  require('kanagawa').setup { transparent = false }
  require('tokyonight').setup { transparent = false }
  require('onedark').setup {}
  require('everforest').setup { background = 'hard', transparent_background_level = 0 }
  vim.cmd('colorscheme ' .. load_colorscheme())
end

return {
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'rebelot/kanagawa.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'navarasu/onedark.nvim' },
  {
    'neanias/everforest-nvim',
    lazy = false,
    priority = 1000,
    config = setup_plugins,
  },
}
