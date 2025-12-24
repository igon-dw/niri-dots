-- Path to the file used to persist the chosen colorscheme (stores the active scheme between sessions)
-- Explanation: This file lets Neovim remember the user's last picked colorscheme across restarts.
-- Uses XDG Base Directory specification: ~/.local/state/nvim/colorscheme_state.txt
local state_file = vim.fn.stdpath 'state' .. '/colorscheme_state.txt'

-- Default fallback colorscheme used when no saved state exists or file is empty
-- Tip: Change this to any installed scheme name to alter the default on fresh setups
local default_scheme = 'everforest'

-- Load the saved colorscheme (returns default if none is saved)
-- What it does: opens the state file, reads the first line as the scheme name,
-- and falls back to `default_scheme` when the file is missing or empty.
local function load_colorscheme()
  local file = io.open(state_file, 'r')
  if file then
    local scheme = file:read '*l'
    file:close()
    return scheme and scheme ~= '' and scheme or default_scheme
  end
  return default_scheme
end

-- Save the current colorscheme to disk
-- What it does: writes the active colorscheme name to the state file so it can be
-- restored on the next Neovim start. This is safe and lightweight (single-line file).
local function save_colorscheme(scheme)
  local file = io.open(state_file, 'w')
  if file then
    file:write(scheme)
    file:close()
  end
end

-- Auto-save the colorscheme whenever it changes
-- Note: This autocommand triggers on the ColorScheme event which many theme plugins
-- emit after they apply highlights. It ensures the saved state matches what the
-- user actually sees.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    save_colorscheme(vim.g.colors_name)
  end,
})

-- Setup function for each colorscheme plugin (configure defaults and apply stored scheme)
-- Purpose: Configure plugin-specific options (if provided) so themes behave consistently,
-- then apply the previously saved colorscheme. Keep plugin setup minimal here; if a
-- theme requires complex configuration prefer configuring it in its own module.
local function setup_plugins()
  -- Configure popular themes with conservative defaults
  require('catppuccin').setup { transparent_background = false }
  require('kanagawa').setup { transparent = false }
  require('tokyonight').setup { transparent = false }
  require('onedark').setup {}
  require('everforest').setup { background = 'hard', transparent_background_level = 0 }

  -- Apply the saved or default colorscheme. This must come after plugin setup.
  vim.cmd('colorscheme ' .. load_colorscheme())
end

-- Plugin specification returned to the plugin manager (lazy.nvim)
-- Each table entry registers a colorscheme plugin. `everforest` is loaded eagerly
-- and sets up all themes; this pattern allows switching themes at runtime while
-- keeping sensible defaults.
return {
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'rebelot/kanagawa.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'navarasu/onedark.nvim' },
  {
    'neanias/everforest-nvim',
    -- Load this one eagerly so setup_plugins runs and applies the saved scheme
    lazy = false,
    priority = 1000,
    config = setup_plugins,
  },
}
