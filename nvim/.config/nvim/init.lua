-- init.lua
-- Neovim configuration entry point
-- The leader key is configured in lazy.lua
-- 'leader key' is a special key in Neovim that acts as a prefix for custom shortcuts

-- Load configuration modules in the correct order
-- require() is a Lua function that loads modules from the config directory
require 'config.options' -- Core editor options and settings

-- The leader key configuration is handled by lazy.nvim plugin manager,
-- so lazy must be loaded before keymaps to ensure proper key binding setup
require 'config.lazy' -- Plugin manager (lazy.nvim)
require 'config.keymaps' -- Key mappings and bindings
