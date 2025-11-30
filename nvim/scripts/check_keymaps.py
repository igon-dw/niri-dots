#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
from pathlib import Path
from collections import defaultdict

config_dir = Path(__file__).resolve().parent.parent / ".config" / "nvim"

# キーマップを格納
keymaps = []

# Leaderキーを取得
leader_key = " "  # デフォルト
for lua_file in config_dir.rglob("*.lua"):
    with open(lua_file, 'r', encoding='utf-8') as f:
        content = f.read()
        match = re.search(r"vim\.g\.mapleader\s*=\s*['\"]([^'\"]*)['\"]", content)
        if match:
            leader_key = match.group(1)
            break

# Luaファイルを探索
for lua_file in config_dir.rglob("*.lua"):
    with open(lua_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        for i, line in enumerate(lines, 1):
            # コメント行をスキップ
            stripped = line.strip()
            if stripped.startswith('--') and not 'keymap.set' in line:
                continue
            
            # vim.keymap.set や keymap.set や nvim_set_keymap を探す
            if 'keymap.set' in line or 'nvim_set_keymap' in line or 'nvim_buf_set_keymap' in line:
                # モードを抽出（最初の文字列引数）
                mode_match = re.search(r"['\"]([nivxstco]+)['\"]", line)
                if not mode_match:
                    continue
                mode = mode_match.group(1)
                
                # キーを抽出（2番目の文字列引数）
                key_matches = re.findall(r"['\"]([^'\"]+)['\"]", line)
                if len(key_matches) < 2:
                    continue
                key = key_matches[1]
                
                # 説明を抽出
                desc_match = re.search(r"desc\s*=\s*['\"]([^'\"]+)['\"]", line)
                desc = desc_match.group(1) if desc_match else ""
                
                # ファイル名を短縮
                short_file = str(lua_file).replace(str(config_dir) + "/", "")
                
                keymaps.append({
                    'mode': mode,
                    'key': key,
                    'desc': desc,
                    'file': short_file,
                    'line': i
                })

# ヘッダー
print("╔════════════════════════════════════════════════════════════╗")
print("║         Neovim キーバインド 完全レポート                   ║")
print("╚════════════════════════════════════════════════════════════╝")
print()

# Leaderキーの表示
print("【Leaderキーの設定】")
if leader_key == " ":
    print("  Leader キー: <Space>")
else:
    print(f"  Leader キー: '{leader_key}'")
print()

# キーマップ設定ファイルのリスト
print("【キーマップ設定ファイル】")
files_with_keymaps = sorted(set(km['file'] for km in keymaps))
for f in files_with_keymaps:
    print(f"  • {f}")
print()

# モード別に分類して表示
modes = {
    'n': 'Normal',
    'i': 'Insert', 
    'v': 'Visual',
    'x': 'Visual Block',
    't': 'Terminal',
    'c': 'Command',
    's': 'Select',
    'o': 'Operator-pending'
}

for mode_key, mode_name in modes.items():
    mode_maps = [km for km in keymaps if mode_key in km['mode']]
    if mode_maps:
        print("━" * 62)
        print(f"【{mode_name} モード ({mode_key})】")
        print("━" * 62)
        print()
        
        # キーでソート
        mode_maps.sort(key=lambda x: (x['key'].lower(), x['key']))
        
        for km in mode_maps:
            # キーの表示を整形
            key_display = km['key'].ljust(25)
            if km['desc']:
                print(f"  {key_display} {km['desc']}")
            else:
                print(f"  {key_display}")
            print(f"    └─ {km['file']}:{km['line']}")
        print()

# 統計情報
print("=" * 62)
print(f"合計: {len(keymaps)} 個のキーマップが定義されています")
print("=" * 62)
print()

# Leader プレフィックス別の統計
print("━" * 62)
print("【<leader> プレフィックス別グループ】")
print("━" * 62)
print()

leader_groups = defaultdict(list)
for km in keymaps:
    if '<leader>' in km['key'].lower():
        # <leader>の後の最初の文字を取得
        match = re.search(r'<[Ll]eader>([a-zA-Z0-9/.<>])', km['key'])
        if match:
            prefix = match.group(1)
            leader_groups[prefix].append(km)

for prefix in sorted(leader_groups.keys()):
    count = len(leader_groups[prefix])
    desc = ""
    if prefix == 's': desc = "Search 関連"
    elif prefix == 'b': desc = "Buffer 関連"
    elif prefix == 'w': desc = "Workspace 関連"
    elif prefix == 'd': desc = "Diagnostic/Document 関連"
    elif prefix == 'r': desc = "Refactor/Rename 関連"
    elif prefix == 'c': desc = "Code 関連"
    elif prefix == 'a': desc = "AI 関連 (オプション)"
    elif prefix == 'l': desc = "その他"
    elif prefix == '/': desc = "Search バッファ内"
    elif prefix == 'D': desc = "Type Definition"
    
    print(f"  <leader>{prefix}*  : {count:2d}個  {desc}")

print()

# 利用可能なプレフィックスの提案
print("━" * 62)
print("【新しいキーバインドの提案】")
print("━" * 62)
print()

used_prefixes = set(leader_groups.keys())
print("  【使用済み <leader> プレフィックス】")
print(f"    {', '.join(sorted(used_prefixes))}")
print()

available = []
suggestions = {
    'e': 'Edit/Error',
    'f': 'Files/Find', 
    'g': 'Git',
    'h': 'Help/Hunk',
    'm': 'Mark/Macro',
    'n': 'Notes/New',
    'o': 'Open/Outline',
    'p': 'Project/Preview',
    'q': 'Quit/Quickfix',
    't': 'Test/Tab/Toggle',
    'u': 'UI/Undo',
    'v': 'View/Version',
    'x': 'Execute',
    'y': 'Yank',
    'z': 'Fold'
}

print("  【利用可能な <leader> プレフィックス（推奨）】")
for letter in sorted(suggestions.keys()):
    if letter not in used_prefixes:
        print(f"    <leader>{letter}*  → {suggestions[letter]}")

print()

# Ctrl キーの使用状況
ctrl_keys = [km for km in keymaps if '<C-' in km['key'] or '<c-' in km['key'].lower()]
print("  【Ctrl (Control) キーの使用状況】")
print(f"    使用済み: {', '.join(sorted(set(km['key'] for km in ctrl_keys)))}")
print("    利用可能: <C-n>, <C-p>, <C-u>, <C-d>, <C-w>, <C-e>, <C-y>, <C-o>, など")
print()

# Alt/Meta キー
alt_keys = [km for km in keymaps if '<M-' in km['key'] or '<A-' in km['key']]
print("  【Alt/Meta キーの使用状況】")
if alt_keys:
    print(f"    使用済み: {', '.join(sorted(set(km['key'] for km in alt_keys)))}")
else:
    print("    現在未使用")
    print("    例: <M-j>, <M-k> (バッファ移動)")
    print("        <M-h>, <M-l> (タブ移動)")
    print("        <M-1>～<M-9> (タブ番号指定)")

print()
print("╔════════════════════════════════════════════════════════════╗")
print("║  Neovim内で :Telescope keymaps でも確認できます            ║")
print("╚════════════════════════════════════════════════════════════╝")
