-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load saved colorscheme name for lazy.nvim install screen
local function get_saved_colorscheme()
  local state_file = vim.fn.stdpath 'state' .. '/colorscheme_state.txt'
  local file = io.open(state_file, 'r')
  if file then
    local scheme = file:read '*l'
    file:close()
    if scheme and scheme ~= '' then
      return scheme
    end
  end
  return 'everforest'
end

require('lazy').setup {
  spec = {
    { import = 'plugins' },
    { import = 'plugins.lsp' },
  },
  install = {
    colorscheme = { get_saved_colorscheme(), 'habamax' },
  },
  rocks = {
    enabled = false,
  },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
