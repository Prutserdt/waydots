# ~/.zshrc

# Just for emacs and using tramp, 
[[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return

# Enable persistent history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY

# My prompt, based on xiong-chiamiov-plus.szh-theme
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%a %b %d, %H:%M"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B %{\e[0m%}%b'
pfetch
FORTUNE="fortune"
for COWNAME in `cowsay -l | tail -n +2`
do
COWS+=$COWNAME
COWS+='\n'
done
COWS=${COWS%??}
RANDOMCOW=$(echo -e $COWS | sort -R | head -n 1)
$FORTUNE | cowsay -f $RANDOMCOW | lolcat

# Move to directories without cd
setopt autocd

# Initialize completion
autoload -U compinit; compinit

setopt COMPLETE_ALIASES #autocomplete command line switches for aliases

# Sourcing my aliases
source $HOME/.aliases

# Sourcing some default key-bindings (fzf, )
source /usr/share/fzf/key-bindings.zsh

# Sourcing the key-bindings
source /usr/share/fzf/completion.zsh

###########################
#     Basic config        #
###########################
#export PATH=”$HOME/.config/emacs/bin:$PATH”  # Run Doom Emacs from the shell
#export PATH=”$HOME/.emacs.d/bin:$PATH”  # Run Doom Emacs from the shell

###########################
#     Custom keybinds     #
###########################
# NOTE: if new keys should be added,the keystroke can be recorded by ~cat -v~

# Move cursor to beginning of line ( Home)
bindkey '^[[H' beginning-of-line

# Move cursor to end of line ( End)
bindkey  '^[[F' end-of-line

# Use the delete key!
bindkey "^[[3~" delete-char

# Delete a word to the left (Control + Backspace)
bindkey '^H' backward-kill-word

# Delete a word to the right (Control + Delete)
bindkey '^[[3;5~' kill-word
