#!/bin/sh

# 常用
alias ra='joshuto'
alias sra='sudo -E joshuto'
alias lg='lazygit'
alias c='clear'
alias s='/Users/zhao/.config/neofetch/launch-neofetch.sh'
alias g='onefetch'
alias vim="nvim"
alias e="nvim"
alias set_proxy="export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"
alias unset_proxy="unset https_proxy http_proxy all_proxy"

## Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## adding flags
alias df='df -h'                          # human-readable sizes
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'

## confirm before overwriting something
alias cp="cp -iv"
alias mv='mv -iv'
alias rm='rm -vI'
alias bc='bc -ql'

