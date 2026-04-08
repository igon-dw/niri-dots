-- ---------------------------------------------------------
-- 1. Disable autoread completely
-- ---------------------------------------------------------
vim.o.autoread = false

-- Helper: notification with snacks fallback
local notify = function(msg, opts)
  local has_snacks, snacks = pcall(require, 'snacks')
  if has_snacks then
    snacks.notify(msg, opts)
  else
    vim.notify(opts.icon and (opts.icon .. ' ' .. msg) or msg, opts.level or vim.log.levels.INFO)
  end
end

vim.api.nvim_create_autocmd('FileChangedShell', {
  pattern = '*',
  callback = function()
    notify('External file changes detected.\nUse `<leader>fd` to view Delta diff.', {
      title = 'File Modified on Disk',
      level = vim.log.levels.WARN,
      icon = '⚡',
      timeout = 5000,
    })
  end,
})

-- ---------------------------------------------------------
-- 2. DeltaLive (Display buffer vs disk diff)
-- ---------------------------------------------------------
vim.api.nvim_create_user_command('DeltaLive', function()
  local current_file = vim.fn.expand '%:p'
  local ft = vim.bo.filetype

  -- Get buffer content and write to temporary file
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local temp_old = vim.fn.tempname() .. '.' .. ft
  local f = io.open(temp_old, 'w')
  if not f then
    notify('Error creating temporary file', {
      level = vim.log.levels.ERROR,
      icon = '❌',
    })
    return
  end
  f:write(table.concat(lines, '\n') .. '\n')
  f:close()

  -- Create new tab
  vim.cmd.tabnew()

  -- Build and start delta diff command
  local cmd = {
    'sh',
    '-c',
    string.format('git --no-pager diff --no-index --color=always %s %s | delta; true', temp_old, current_file),
  }

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function()
      os.remove(temp_old)
    end,
  })

  vim.cmd.startinsert()
  vim.api.nvim_tabpage_set_var(0, 'name', 'Delta Diff')
end, {})

-- Keybindings
vim.keymap.set('n', '<leader>fd', ':DeltaLive<CR>', { desc = 'Delta Diff (Buffer vs Disk)' })
