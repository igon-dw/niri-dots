-- nvim-cmp（Neovimの補完プラグイン）の設定テーブルを返します。
return {
  -- メインの補完プラグインを指定します。
  'hrsh7th/nvim-cmp',
  -- Insertモードに入った時にプラグインを読み込むイベントを指定します。
  event = 'InsertEnter',
  -- 依存プラグインのリストです。
  dependencies = {
    {
      -- スニペットエンジンLuaSnipを追加します。
      'L3MON4D3/LuaSnip',
      -- Windows環境やmakeコマンドが使えない場合はビルドをスキップします。
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        -- make install_jsregexpでLuaSnipの正規表現サポートを追加します。
        return 'make install_jsregexp'
      end)(),
      -- LuaSnipの追加依存はありません。
      dependencies = {},
    },
    -- LuaSnip用のnvim-cmpソースを追加します。
    'saadparwaiz1/cmp_luasnip',
    -- LSP用のnvim-cmpソースを追加します。
    'hrsh7th/cmp-nvim-lsp',
    -- ファイルパス補完用のnvim-cmpソースを追加します。
    'hrsh7th/cmp-path',
    -- 補完候補のアイコン表示用プラグインを追加します。
    'onsails/lspkind-nvim',
  },
  config = function()
    -- cmp, luasnip, lspkindの各プラグインを読み込みます。
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    -- LuaSnipの基本設定を初期化します。
    luasnip.config.setup {}

    -- nvim-cmpの全体設定を行います。
    cmp.setup {
      -- スニペット展開の設定。補完候補からスニペットを展開する際の処理です。
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- 補完ウィンドウとドキュメントウィンドウの見た目を設定します。
      window = {
        completion = cmp.config.window.bordered(), -- 補完ウィンドウに枠線を付ける
        documentation = cmp.config.window.bordered {
          border = 'double', -- ドキュメントウィンドウは二重枠
        },
      },
      -- 補完の挙動を細かく設定します。
      completion = { completeopt = 'menu,menuone,noinsert' },
      -- キーマッピングの設定。補完候補の選択や確定、スクロールなどを割り当てます。
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(), -- 次の候補を選択
        ['<C-p>'] = cmp.mapping.select_prev_item(), -- 前の候補を選択
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),    -- ドキュメントを上にスクロール
        ['<C-f>'] = cmp.mapping.scroll_docs(4),     -- ドキュメントを下にスクロール
        ['<Return>'] = cmp.mapping.confirm { select = true }, -- Enterで確定
        ['<Tab>'] = cmp.mapping.confirm { select = true },    -- Tabでも確定
        ['<C-Space>'] = cmp.mapping.complete {},    -- Ctrl+Spaceで補完を呼び出し
      },
      -- 補完候補のソースを指定します。
      sources = {
        {
          name = 'lazydev', -- lazydev（LSP拡張）用のソース
          group_index = 0,
        },
        { name = 'nvim_lsp' },   -- LSPからの補完
        { name = 'luasnip' },    -- スニペットからの補完
        { name = 'path' },       -- ファイルパス補完
      },
      -- 補完候補の表示形式を設定します。
      formatting = {
        fields = { 'abbr', 'kind', 'menu' }, -- 表示するフィールド
        expandable_indicator = true,         -- 展開可能な候補にインジケータを表示
        format = lspkind.cmp_format {
          mode = 'symbol_text',             -- アイコン＋テキスト表示
          maxwidth = 50,                    -- 最大幅
          ellipsis_char = '...',            -- 長い場合は省略記号
          show_labelDetails = true,         -- 詳細ラベルを表示
          before = function(entry, vim_item)
            -- 補完候補の表示内容をカスタマイズする場合はここで処理します。
            return vim_item
          end,
        },
      },
    }
  end,
}
