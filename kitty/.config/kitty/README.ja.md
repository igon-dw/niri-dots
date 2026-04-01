# Kitty 設定

このディレクトリには、このリポジトリで使っている Kitty 設定が入っています。スクリプト駆動のテーマ切り替えと、実行中の Kitty インスタンスへの即時反映を前提にしています。

---

## 概要

この Kitty 設定は主に以下で構成されています。

- ベース設定としての `kitty.conf`
- active theme を指す `current-theme.conf`
- スクリプトによる theme switcher
- Waybar / Ghostty と連携可能な統合テーマ切り替え

主なファイル:

- `kitty.conf`
- `THEMES.md`
- `themes/`
- `scripts_for_kitty/`

補足:

- `current-theme.conf` は初回利用時に生成され、Git では管理しません。
- `kitty.conf` は `./current-theme.conf` を include します。
- remote control を有効にしているため、theme script から実行中の Kitty に配色を反映できます。

---

## ディレクトリ構成

```text
kitty/.config/kitty/
|- kitty.conf
|- current-theme.conf
|- THEMES.md
|- themes/
|  |- ayu.conf
|  |- catppuccin.conf
|  |- earthsong.conf
|  |- everforest.conf
|  |- flatland.conf
|  |- gruvbox.conf
|  |- night-owl.conf
|  |- nord.conf
|  |- palenight.conf
|  |- shades-of-purple.conf
|  |- solarized.conf
|  `- tokyo-night.conf
`- scripts_for_kitty/
   |- switch-theme.sh
   `- list-themes.sh
```

---

## テーマ切り替え

### インタラクティブモード

```bash
~/.config/kitty/scripts_for_kitty/switch-theme.sh
```

まだ `current-theme.conf` が存在しない場合、script は先にデフォルトテーマ `Earthsong` で初期化してから処理を進めます。

### テーマ名を直接指定

```bash
~/.config/kitty/scripts_for_kitty/switch-theme.sh tokyo-night
~/.config/kitty/scripts_for_kitty/switch-theme.sh nord
~/.config/kitty/scripts_for_kitty/switch-theme.sh gruvbox
```

### テーマ一覧を確認

```bash
~/.config/kitty/scripts_for_kitty/list-themes.sh
~/.config/kitty/scripts_for_kitty/list-themes.sh --simple
```

### Waybar とまとめて切り替える

Waybar と端末テーマをまとめて切り替える場合:

```bash
~/.config/niri/scripts_for_niri/change-all-themes.sh
```

このフローでは、選択した Waybar テーマ名と同名の `.conf` があれば Kitty にも適用します。

---

## 仕組み

theme switcher は以下の順に動きます。

1. `current-theme.conf` の存在を確認する
2. 指定されたテーマファイルが `themes/` にあるか検証する
3. `current-theme.conf` を `./themes/gruvbox.conf` のような相対 symlink に更新する
4. `kitty @ set-colors --all --configured` で実行中の Kitty に適用を試みる
5. デスクトップ通知を出す

これにより:

- 新しく起動した Kitty は `include ./current-theme.conf` から active theme を読む
- 実行中の Kitty も remote control が使えればその場で更新される

### シンボリックリンクの連鎖

Stow で配置した場合、テーマ参照は 2 段階のリンクで構成されます。

```text
~/.config/kitty/current-theme.conf       (switch-theme.sh が作成)
    -> ./themes/earthsong.conf           (stow が作るシンボリックリンク)
    -> ~/niri-dots/kitty/.config/kitty/themes/earthsong.conf  (実ファイル)
```

Linux はこの連鎖を透過的に解決します。Kitty は最終的なファイル内容を読み取ります。

---

## 現在の設定メモ

現在の `kitty.conf` には主に以下が入っています。

- JetBrains Mono Nerd Font Mono
- `current-theme.conf` によるテーマ読み込み
- `allow_remote_control yes`
- `shell_integration no-cursor`
- Niri と合わせるためのウィンドウ装飾無効化

重要な補足:

- 透明度は `kitty.conf` 側で管理せず、Niri の window rule 側で扱う前提です

---

## 利用可能なテーマ

現在のテーマ一覧:

- `ayu` — オレンジとブルーのアクセント、高コントラストでコーディング向き
- `catppuccin` — ラベンダーとピンクのパステル調、長時間作業でも目に優しい
- `earthsong` — ベージュとブラウンの自然な色合い、落ち着いた集中作業向き（デフォルト）
- `everforest` — 緑を基調とした森林パレット、低コントラストで目の負担が少ない
- `flatland` — グレーベースのミニマルデザイン、洗練されたプロフェッショナル向き
- `gruvbox` — 黄色・オレンジ・緑の暖色レトロ配色、プログラマーに人気
- `night-owl` — 深い青紫の背景に明るいアクセント、夜間作業向け
- `nord` — 青とグレーの寒色パレット、北欧の冬をイメージしたクールな配色
- `palenight` — 紫とピンクの Material Design 調、モダンで洗練された印象
- `shades-of-purple` — 鮮やかな紫を大胆に使用、個性的でクリエイティブ向き
- `solarized` — 科学的に設計された 16 色パレット、コントラスト比を最適化
- `tokyo-night` — 深い紺とネオンカラー、夜の東京の雰囲気を表現

これらの名前は Waybar 側のテーマ名と大半が揃っています。Waybar の `original` に対応する Kitty テーマはありません。

テーマの出典や attribution は `THEMES.md` にまとめています。

---

## 新しいテーマを追加する

1. `themes/<name>.conf` を追加する
2. Kitty で正しく読み込めることを確認する
3. 統合テーマ切り替えも使いたいなら、同じ basename の Waybar テーマも追加する

最低限必要な項目:

- `background`
- `foreground`
- `cursor`
- `selection_background`
- `color0` から `color15`

---

## 依存関係

この Kitty 構成でよく使う runtime dependency:

- `kitty`
- `fuzzel`
- `notify-send`
- `pgrep`
- `ln`

live 反映が効かない場合は、Kitty が起動しているか、remote control が有効に使えているかを確認してください。

---

## トラブルシューティング

### 実行中の Kitty にテーマが反映されない

```bash
kitty @ ls
~/.config/kitty/scripts_for_kitty/switch-theme.sh
```

### テーマリンクが作られていない

```bash
ls -l ~/.config/kitty/current-theme.conf
~/.config/kitty/scripts_for_kitty/switch-theme.sh earthsong
```

### 利用可能なテーマを確認したい

```bash
~/.config/kitty/scripts_for_kitty/list-themes.sh
```

---

## リソース

- [Kitty 公式ドキュメント](https://sw.kovidgoyal.net/kitty/)
- [Kitty リモートコントロール](https://sw.kovidgoyal.net/kitty/remote-control/)
- [Kitty カラーテーマ](https://github.com/kovidgoyal/kitty-themes)
- [Niri Compositor](https://github.com/YaLTeR/niri)
