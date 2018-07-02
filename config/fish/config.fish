# my fish config

# set locale
set -x LANG en_US.utf8

alias nv='nvim'

alias cdvim='cd ~/.vim'
alias cddot='cd ~/.dotfiles'
#git aliases
alias gd="git diff --color-words"
alias gl="git log --graph --pretty=format:'%C(yellow)%s%Creset%n%an %C(blue)%cr%Creset %h%C(red)%d%Creset ' --numstat"
alias gu='git pull --rebase'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcf='git config --list'
alias gclean='git clean -fd'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gm='git merge'
alias gp='git push'

function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

