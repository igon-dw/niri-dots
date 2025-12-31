--[[
LSP Configuration

Language Server Protocol configuration with Mason-managed server installation.
Provides code completion, diagnostics, navigation, and code actions.

Key features:
- Automatic LSP server installation via Mason
- Snacks.nvim picker integration for fuzzy-finding definitions/references
- Document highlight on cursor hold
- Per-language server customization
- Integration with blink.cmp for completion
]]

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason: LSP server, formatter, and linter installer
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Fidget: LSP progress notifications
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- LSP keymaps are set when an LSP attaches to a buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- Helper function for setting keymaps
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Navigation using Snacks picker for fuzzy finding
        -- Press <C-t> to jump back after navigation
        map('gd', function()
          require('snacks').picker.lsp_definitions()
        end, '[G]oto [d]efinition')
        map('gr', function()
          require('snacks').picker.lsp_references()
        end, '[G]oto [R]eferences')
        map('gI', function()
          require('snacks').picker.lsp_implementations()
        end, '[G]oto [I]mplementation')
        map('<leader>D', function()
          require('snacks').picker.lsp_type_definitions()
        end, 'Type [D]efinition')

        -- Declaration jump (mainly for C/C++/Go header files)
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Code actions
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Document highlight: highlight symbol under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          
          -- Highlight on cursor hold
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          -- Clear highlight on cursor move
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          -- Clean up on LSP detach
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
            end,
          })
        end
      end,
    })

    -- Integrate blink.cmp capabilities into default LSP config
    local lspconfig_defaults = require('lspconfig').util.default_config
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
      'force',
      lspconfig_defaults.capabilities,
      require('blink.cmp').get_lsp_capabilities()
    )

    -- Define LSP servers and their configurations
    -- Keys: server names (recognized by mason-lspconfig)
    -- Values: server-specific settings (settings, cmd, filetypes, etc.)
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      },
      pyright = {},
      bashls = {},
      ts_ls = {},
      dockerls = {},
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              ['https://json.schemastore.org/docker-compose.json'] = 'docker-compose*.{yml,yaml}',
            },
          },
        },
      },
      gopls = {},
    }

    -- Setup Mason for LSP server installation
    require('mason').setup()

    -- Build list of tools to auto-install
    -- Includes LSP servers from `servers` table + formatters/linters
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
      'black',
      'shfmt',
      'markdownlint',
      'yamllint',
    })

    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

    -- Setup mason-lspconfig to bridge Mason and lspconfig
    -- Default handler applies to all servers
    require('mason-lspconfig').setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- Merge default capabilities with server-specific overrides
          server.capabilities = vim.tbl_deep_extend(
            'force',
            {},
            lspconfig_defaults.capabilities,
            server.capabilities or {}
          )
          require('lspconfig')[server_name].setup(server)
        end,
      },
    })
  end,
}
