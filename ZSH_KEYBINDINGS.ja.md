# Zsh Keybindings

このドキュメントは、`zsh/.config/zsh` 配下の現在の設定から読み取れる `zsh` のキーバインドと、その周辺挙動を整理したものです。

対象ファイル:

- `zsh/.config/zsh/zshrc.d/00-base.zsh`
- `zsh/.config/zsh/zshrc.d/10-tools.zsh`
- `zsh/.config/zsh/zshrc.d/20-abbr.zsh`

## 明示的に設定されているキーバインド

### Emacs キーマップ

`bindkey -e` により、ZLE は Emacs 系キーバインドを使います。

- 設定箇所: `zsh/.config/zsh/zshrc.d/00-base.zsh`
- 影響: `Ctrl-A` で行頭、`Ctrl-E` で行末、`Ctrl-F` / `Ctrl-B` でカーソル移動など、`zsh` 標準の Emacs 系操作が有効

### `Ctrl-S` の解除

`Ctrl-S` は明示的に unbind されています。

- 設定: `bindkey -r '^S'`
- 設定箇所: `zsh/.config/zsh/zshrc.d/00-base.zsh`
- 目的: 端末側のフロー制御や既存割り当てとの衝突回避を意図している可能性が高い

### `Alt-S` で履歴のインクリメンタル検索

`Alt-S` は `history-incremental-search-forward` に割り当てられています。

- 設定: `bindkey '^[s' history-incremental-search-forward`
- 設定箇所: `zsh/.config/zsh/zshrc.d/00-base.zsh`
- 挙動: コマンドライン編集中に前方方向の履歴インクリメンタル検索を開始

### スペースキーで略語展開

スペースキーは `abbr-expand-and-insert` に割り当てられています。

- 設定: `bindkey " " abbr-expand-and-insert`
- 設定箇所: `zsh/.config/zsh/zshrc.d/20-abbr.zsh`
- 前提: `abbr` コマンドが利用可能な場合のみ有効
- 挙動: 登録済み abbreviation を展開した上でスペースを挿入

例:

- `ls` -> `eza -a --icons`
- `ll` -> `eza -al --icons`
- `lzg` -> `lazygit`
- `cdf` -> `cd $(fd --type d --hidden --exclude .git --exclude node_modules . ~ | fzf)`

## 条件付きで有効になるキーバインド

### `fzf` 標準キーバインド

対話シェルで、かつ `/usr/share/fzf/key-bindings.zsh` が存在する場合は、そのファイルを source します。

- 設定箇所: `zsh/.config/zsh/zshrc.d/10-tools.zsh`
- 読み込み条件:
  - シェルが interactive
  - `/usr/share/fzf/key-bindings.zsh` が存在

一般的には次のような `fzf` 標準バインドが有効になります。

- `Ctrl-T`: ファイル選択
- `Ctrl-R`: 履歴検索
- `Alt-C`: ディレクトリ移動

ただし、最終的な実際の割り当ては、その環境にある `key-bindings.zsh` の内容に依存します。

## キーバインドではないが入力体験に影響する設定

### `abbr` による短縮入力

`20-abbr.zsh` では複数の abbreviation が定義されています。これはキーバインドそのものではありませんが、スペースキー展開と組み合わさるため、実質的に入力体験へ強く影響します。

主な登録内容:

- `ls`, `ll`, `lt2`, `lt3`, `lt4`, `lt5`
- `cdf`
- `lzg`
- `cvim`
- `cplt`, `cpltr`
- `oc`, `ocw`
- `ttc`
- `ffclip`

### `setopt autocd`

ディレクトリ名だけ入力して実行すると `cd` 扱いになります。

- 設定箇所: `zsh/.config/zsh/zshrc.d/00-base.zsh`
- これはキーバインドではないが、コマンド入力時の挙動として体感差が大きい設定

## 現時点で見当たらないもの

このリポジトリ内の `zsh` 設定を見る限り、次は確認できませんでした。

- 独自の `zle -N` ウィジェット定義
- `terminfo` を使った複雑な特殊キー割り当て
- `stty` を使った端末制御変更
- 独自のマルチキーシーケンスを大量に定義する設定

## 実運用上のまとめ

現在の `zsh` は、次の構成です。

1. ベースは Emacs キーマップ
2. 独自追加は `Alt-S` とスペースキー展開が中心
3. `fzf` が入っていれば、その標準キーバインドが追加される
4. abbreviation と `autocd` により、通常の素の `zsh` よりも入力補助が強い

実際にその場で有効な最終バインドを確認したい場合は、対話 `zsh` 上で次を実行します。

```zsh
bindkey
```

特定キーだけ確認したい場合:

```zsh
bindkey | rg '\^S|\^\[s|abbr-expand-and-insert'
```
