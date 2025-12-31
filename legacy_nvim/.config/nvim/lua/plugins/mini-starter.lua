return {
  'echasnovski/mini.starter',
  version = '*',
  opts = function()
    local logo = [[
       ____                        _                    _ 
      |  _ \  ___   __ _      __ _| |__   ___  __ _  __| |
      | | | |/ _ \ / _` |    / _` | '_ \ / _ \/ _` |/ _` |
      | |_| | (_) | (_| |_  | (_| | | | |  __/ (_| | (_| |
      |____/ \___/ \__, ( )  \__,_|_| |_|\___|\__,_|\__,_|
                   |___/|/

                                      __
                           .,-;-;-,. /'_\
                         _/_/_/_|_\_\) /
                       '-<_><_><_><_>=/\
                         `/_/====/_/-'\_\
                          ""     ""    ""
  ]]
    local starter = require 'mini.starter'
    local new_section = function(name, action, section)
      return { name = name, action = action, section = section }
    end

    local config = {
      -- Whether to open starter buffer on VimEnter. Not opened if Neovim was
      -- started with intent to show something else.
      autoopen = true,

      -- Whether to evaluate action of single active item
      evaluate_single = false,

      -- Items to be displayed. Should be an array with the following elements:
      -- - Item: table with <action>, <name>, and <section> keys.
      -- - Function: should return one of these three categories.
      -- - Array: elements of these three types (i.e. item, array, function).
      -- If `nil` (default), default items will be used (see |mini.starter|).
      items = {
        starter.sections.recent_files(7, false),
        new_section('Lazy', 'Lazy', 'Custom Sections'),
        new_section('Config', 'Telescope find_files cwd=~/.config/nvim/', 'Custom Sections'),
        new_section('Dotfiles', 'Telescope find_files cwd=~/dotfiles/', 'Custom Sections'),
        starter.sections.builtin_actions(),
      },

      -- Header to be displayed before items. Converted to single string via
      -- `tostring` (use `\n` to display several lines). If function, it is
      -- evaluated first. If `nil` (default), polite greeting will be used.
      header = logo,

      -- Footer to be displayed after items. Converted to single string via
      -- `tostring` (use `\n` to display several lines). If function, it is
      -- evaluated first. If `nil` (default), default usage help will be shown.
      footer = nil,

      -- Array  of functions to be applied consecutively to initial content.
      -- Each function should take and return content for 'Starter' buffer (see
      -- |mini.starter| and |MiniStarter.content| for more details).
      content_hooks = nil,

      -- Characters to update query. Each character will have special buffer
      -- mapping overriding your global ones. Be careful to not add `:` as it
      -- allows you to go into command mode.
      query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',

      -- Whether to disable showing non-error feedback
      silent = false,
    }
    return config
  end,
}
