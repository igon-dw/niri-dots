return {
  -- Plugin: which-key.nvim
  'folke/which-key.nvim',
  -- Load on very lazy event
  event = 'VeryLazy',
  -- Plugin options
  opts = {
    win = {
      border = 'double',
    },
    -- Descriptions for keymaps provided by each plugin are unified and documented here
    spec = {
      { '<leader>b', group = '[B]uffer' },
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>e', group = '[E]xplorer: Oil' },
      { '<leader>f', group = '[F]ormat buffer' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>o', group = '[O]utline' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle Console' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader><leader>', group = 'Find existing buffers' },
    },
  },
  -- Keymaps to be added
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
