return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Continue' },
    { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F12>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Condition: ') end, desc = 'Conditional Breakpoint' },
    { '<leader>dr', function() require('dap').repl.open() end, desc = 'Open REPL' },
    { '<leader>dl', function() require('dap').run_last() end, desc = 'Run Last' },
    { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle DAP UI' },
    { '<leader>dt', function() require('dap-go').debug_test() end, desc = 'Debug Go Test' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      ensure_installed = { 'debugpy', 'delve', 'bash-debug-adapter' },
    }

    -- Setup dap-ui
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 10,
          position = 'bottom',
        },
      },
    }

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Setup dap-go (handles Go/Delve configuration automatically)
    require('dap-go').setup()

    -- Python (debugpy)
    dap.adapters.python = function(cb, config)
      if config.request == 'attach' then
        cb {
          type = 'server',
          port = (config.connect or config).port,
          host = (config.connect or config).host or '127.0.0.1',
        }
      else
        cb {
          type = 'executable',
          command = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python',
          args = { '-m', 'debugpy.adapter' },
        }
      end
    end

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
          local venv = os.getenv 'VIRTUAL_ENV'
          return venv and (venv .. '/bin/python') or '/usr/bin/python3'
        end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Django',
        program = '${workspaceFolder}/manage.py',
        args = { 'runserver', '--noreload' },
        django = true,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Flask',
        module = 'flask',
        args = { 'run', '--no-debugger', '--no-reload' },
      },
    }

    -- Bash (bash-debug-adapter)
    dap.adapters.bashdb = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/bin/bash-debug-adapter',
      name = 'bashdb',
    }

    dap.configurations.sh = {
      {
        type = 'bashdb',
        request = 'launch',
        name = 'Launch file',
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
        pathBashdbLib = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
        trace = true,
        file = '${file}',
        program = '${file}',
        cwd = '${workspaceFolder}',
        pathCat = 'cat',
        pathBash = '/bin/bash',
        pathMkfifo = 'mkfifo',
        pathPkill = 'pkill',
        args = {},
        env = {},
        terminalKind = 'integrated',
      },
    }
  end,
}
