-- conform.nvim プラグインの設定
-- このプラグインはファイル保存時やコマンド実行時にコードをフォーマット

return {
  'stevearc/conform.nvim', -- プラグイン名
  event = { 'BufWritePre' }, -- ファイル保存前に有効化
  cmd = { 'ConformInfo' }, -- コマンドで有効化可能
  keys = {
    {
      '<leader>f', -- キーマッピング: <leader>f でフォーマット実行
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '', -- どのモードでも有効
      -- desc は which-key.lua で定義
    },
  },
  opts = {
    notify_on_error = false, -- エラー通知を無効化
    format_on_save = function(bufnr)
      -- C/C++ファイルはLSPフォーマットを無効化
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 500, -- フォーマットのタイムアウト設定（ミリ秒）
        lsp_format = lsp_format_opt, -- LSPフォーマットのオプション
      }
    end,
    formatters_by_ft = {
      -- ファイルタイプごとに使用するフォーマッタを指定
      -- stop_after_first: 最初に利用可能なフォーマッタのみ実行
      lua = { 'stylua', stop_after_first = true }, -- Lua用
      shell = { 'shfmt', stop_after_first = true }, -- シェルスクリプト用
      fish = { 'fish_indent', stop_after_first = true }, -- Fish shell用
      markdown = { 'markdownlint', stop_after_first = true }, -- Markdown用
      python = { 'black', stop_after_first = true }, -- Python用
      json = { 'prettierd', stop_after_first = true }, -- JSON用
      jsonc = { 'prettierd', stop_after_first = true }, -- JSONC用
      dockerfile = { 'docker-language-server', stop_after_first = true }, -- Dockerfile用
      yml = { 'yamllint', stop_after_first = true }, -- YAML用
    },
    formatters = {
      prettierd = {
        -- JSONCで末尾のカンマを削除
        prepend_args = { '--trailing-comma', 'none' },
      },
    },
  },
}
