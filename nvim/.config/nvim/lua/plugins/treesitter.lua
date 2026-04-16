return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    init = function()
      local ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
        'go',
        'javascript',
        'typescript',
        'yaml',
        'toml',
        'dockerfile',
      }
      local already_installed = require('nvim-treesitter.config').get_installed()
      local parsers_to_install = vim
        .iter(ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(already_installed, parser)
        end)
        :totable()

      if #parsers_to_install > 0 then
        require('nvim-treesitter').install(parsers_to_install)
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('nvim-treesitter-filetypes', { clear = true }),
        callback = function(event)
          if event.match ~= 'ruby' then
            pcall(vim.treesitter.start)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            return
          end

          vim.bo.indentexpr = ''
        end,
      })
    end,
    config = function(_, opts)
      require('nvim-treesitter').setup(opts)
    end,
    opts = {
      auto_install = true,
    },
  },
}
