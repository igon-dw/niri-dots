-- init.lua
-- leaderキーはlazy.luaで設定されます

-- 各種設定ファイルを読み込む
-- require()は、指定されたLuaモジュールを読み込むための関数
require 'config.options' -- 基本的なエディタオプション
-- leaderキーの設定はlazy.nvimで行うため、keymapsより前にlazyを読み込む必要があります
require 'config.lazy' -- プラグインマネージャー(lazy.nvim)
require 'config.keymaps' -- キーマッピング
