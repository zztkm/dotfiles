#!/bin/zsh

# 1. セッション一覧を取得し、fzfで選択 (複数選択可、プレビュー付き)
#    - Tabキー: 複数選択 / 解除
#    - Enterキー: 決定
selected_sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | \
  fzf --multi \
      --prompt="🗑️  Kill session(s) > " \
      --preview 'tmux list-windows -t {}' \
      --preview-window='right:50%:wrap')

# 2. キャンセルされた場合（空文字）は静かに終了
if [[ -z "$selected_sessions" ]]; then
  exit 0
fi

# 3. 選択されたセッションを削除
#    (改行区切りのリストを xargs で処理)
echo "$selected_sessions" | xargs -I {} tmux kill-session -t {}

# 4. 完了メッセージ（不要なら削除可）
echo "✅ Killed sessions:"
echo "$selected_sessions" | sed 's/^/  - /'

