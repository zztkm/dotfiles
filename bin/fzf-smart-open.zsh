#!/usr/bin/env zsh

# --- 設定 ---
# プレビュー用のコマンド (bat がなければ cat にフォールバックなど)
PREVIEW_CMD='bat --style=numbers --color=always --line-range :500 {}'

# --- 1. 検索の起点を決める ---
# git リポジトリ内にいるなら、そのルートディレクトリに移動してから検索する
# (これがないと、サブディレクトリにいる時に全ファイルを検索できない)
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  GIT_ROOT=$(git rev-parse --show-toplevel)
  cd "$GIT_ROOT"
fi

# --- 2. FZF 実行 ---
# rg で検索 -> fzf で選択
# - m: マルチセレクトを無効化 (単一ファイルジャンプ用)
SELECTED_FILE=$(rg --files --hidden --follow --glob "!.git/*" 2>/dev/null | fzf -m \
    --preview "$PREVIEW_CMD" \
    --preview-window 'right:60%' \
    --height 100% \
    --layout reverse \
    --border \
    --prompt="Project Files > "
)

# キャンセルされたら終了
if [[ -z "$SELECTED_FILE" ]]; then
    exit 0
fi

# 検索時は Git ルートにいたので、フルパスに変換しておく
# (エディタに渡すときに相対パスだと、元のペインのカレントディレクトリとズレて開けないため)
FULL_PATH=$(realpath "$SELECTED_FILE")

# --- 3. プロセス判定とキー送信 ---
# 現在アクティブなペインで動いているコマンドを取得
CURRENT_PANE_CMD=$(tmux display-message -p "#{pane_current_command}")

# ログ用 (デバッグしたい時用)
# echo "Cmd: $CURRENT_PANE_CMD, File: $FULL_PATH" >> /tmp/tmux-debug.log

if [[ "$CURRENT_PANE_CMD" =~ "(n?vim|git)" ]]; then
    # --- Case A: Vim / Neovim が開いている場合 ---
    # 1. Escape: ノーマルモードに戻す
    # 2. :e "path": ファイルを開く (スペース対策でダブルクォートで囲む)
    tmux send-keys "Escape" ":e $FULL_PATH" "Enter"
else
    # --- Case B: シェル (zsh) の場合 ---
    # 1. C-u: 入力中のコマンドがあればクリアする (事故防止)
    # 2. $EDITOR "path": エディタで開く
    # EDITOR変数が空なら vim を使う
    EDITOR_CMD=${EDITOR:-vim}
    tmux send-keys "C-u" "$EDITOR_CMD $FULL_PATH" "Enter"
fi
