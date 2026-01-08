return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      dockerfile = { 'hadolint' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })

    -- Integrate linter diagnostics with Neovim's diagnostic system
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Run linter and update diagnostics
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
          -- Force diagnostic refresh
          vim.diagnostic.show()
        end
      end,
    })
  end,
}
