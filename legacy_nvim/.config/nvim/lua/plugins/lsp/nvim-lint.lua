return {
  'mfussenegger/nvim-lint',
  events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
  config = function()
    require('lint').linters_by_ft = {
      fish = { 'fish' },
      markdown = { 'markdownlint' },
      yaml = { 'yamllint' },
      dockerfile = { 'hadolint' },
    }
    -- "LintInfo" command was Copied from https://github.com/mfussenegger/nvim-lint/issues/559#issuecomment-2263995711 on 2024/10/08
    -- Copyright (c) 2020-present mfussenegger
    -- MIT License
    -- Permission is hereby granted, free of charge, to any person obtaining a copy
    -- of this software and associated documentation files (the "Software"), to deal
    -- in the Software without restriction, including without limitation the rights
    -- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    -- copies of the Software, and to permit persons to whom the Software is
    -- furnished to do so, subject to the following conditions:
    -- The above copyright notice and this permission notice shall be included in all
    -- copies or substantial portions of the Software.
    -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    -- SOFTWARE.
    -- Show linters for the current buffer's file type
    vim.api.nvim_create_user_command('LintInfo', function()
      local filetype = vim.bo.filetype
      local linters = require('lint').linters_by_ft[filetype]
      if linters then
        print('Linters for ' .. filetype .. ': ' .. table.concat(linters, ', '))
      else
        print('No linters configured for filetype: ' .. filetype)
      end
    end, {})
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      callback = function()
        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        require('lint').try_lint()
      end,
    })
  end,
}
