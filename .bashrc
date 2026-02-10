#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

pfetch

PS1='[\u@\h \W]\$ '

# Alias definitions. Sourced in bash and zsh.
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

