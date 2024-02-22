# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
alias govim='export EDITOR=/usr/bin/vim'
alias bat=/usr/bin/batcat
alias fzfbat="fzf --preview 'batcat --color=always --style=numbers --line-range=:500 {}'"

if [ -x "$(command -v fzf)"  ]
then
	    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
export PATH="/root/.cargo/bin:/root/.fzf/bin:$PATH"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(/root/.cargo/bin/navi widget bash)"
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
[[ -v SSH_CONNECTION ]] && return
[[ -v SUDO_UID ]] && return


/home/bin/startup.sh
