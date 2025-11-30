--[[
Telescopeプラグイン設定

Neovim用ファジーファインダー。ファイル検索、コマンド検索、キーマップ検索、バッファ検索、診断検索などを高速実行。

主なポイント：
- ファイル、ヘルプ、キーマップ、バッファ、診断などの簡易検索
- キーマップ入力時に遅延読み込み（起動高速化）
- 追加機能用依存プラグイン（高速化、アイコン表示など）
- 検索系キーマップは<leader>s（通常は<Space>s）で統一
- 各部分の役割をコメントで解説
]]

return {
  -- Telescope本体。ファイル・テキスト・各種項目の検索
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x', -- 安定版ブランチ指定
  dependencies = {
    -- Telescope必須依存
    'nvim-lua/plenary.nvim',
    -- オプション依存。検索高速化（makeコマンド必要）
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make', -- ネイティブコードビルドで高速化
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    -- オプション依存。ドロップダウンUI追加
    { 'nvim-telescope/telescope-ui-select.nvim' },
    -- オプション依存。アイコン表示（Nerd Font必要）
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescopeの基本設定と拡張機能セットアップ
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- 拡張機能の読み込み（存在時のみ）
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Telescope主要検索用キーマップ
    -- <leader>は通常<Space>キー
    local builtin = require 'telescope.builtin'
    -- Neovimヘルプタグ検索
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    -- 全キーマップ検索
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    -- プロジェクト内ファイル検索（隠しファイル含む）
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files { hidden = true }
    end, { desc = '[S]earch [F]iles (including hidden)' })
    -- Telescope全ピッカー検索
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    -- カーソル下の単語検索
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    -- テキスト検索（ライブgrep）
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    -- 診断メッセージ検索（エラー・警告）
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    -- 直前の検索再開
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    -- 最近開いたファイル検索
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    -- 開いているバッファ検索
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    -- カラースキーム検索・変更
    vim.keymap.set('n', '<leader>sc', builtin.colorscheme, { desc = '[S]earch [C]olorscheme' })

    -- 応用：現在バッファ内ファジー検索
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- 応用：開いているファイル限定ライブgrep
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- ショートカット：Neovim設定ファイル検索
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
