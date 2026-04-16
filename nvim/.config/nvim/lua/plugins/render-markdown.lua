return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown', 'AgenticChat' },
  keys = {
    { '<leader>mt', '<cmd>RenderMarkdown toggle<CR>', desc = 'Toggle rendered markdown' },
  },
  opts = {
    enabled = false,
    file_types = { 'markdown', 'AgenticChat' },
  },
}
