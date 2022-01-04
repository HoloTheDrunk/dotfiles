#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

alias ll='ls -l'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"

function gl()
{
    [ $# -eq 1 ] && [ "$1" -ge 0 ] && visible="$1" || visible=10
    git lol -"$visible"
    lines=$(($(git lol | wc -l) - visible))
    [ $lines -gt 0 ] && echo "$lines older commits..."
}

alias reload='source ~/.bashrc'

alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gt='git tag'
alias gp='git push'

alias gcc='gcc -Werror -Wall -Wextra -std=c99 -fsanitize=address'
alias gccurses='gcc -pedantic -fsanitize=address -lncurses'

function gccasm()
{
    [ $# -lt 1 ] && echo "Missing file argument" && return 1
    [ ! -f "$1.S" ] && echo "File '$1.S' does not exist" && return 1
    [ ! -d "bin" ] && mkdir "bin"

    ASM="$1"
    shift 1

    ! gcc "$ASM.S" $@ -g -O0 -o "bin/$ASM" && echo "Could not compile" && return 1
    [ ! -f "$ASM.bin" ] && ln -s "bin/$ASM" "$ASM.bin"
}

RESET="\033[0m"
BOLD="\033[1m"
FAINT="\033[2m"
ITALIC="\033[3m"
UNDERLINE="\033[4m"
SBLINK="\033[5m"
RBLINK="\033[6m"
INVERT="\033[7m"
HIDE="\033[8m"
STRIKE="\033[9m"

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

function update_ps1()
{
  # Shrunk path
  FOLDER_PATH=$(dirname $(pwd) | sed -E 's/^\/home/~/g' | sed -E 's/(\/?)([^/])([^/]+)(\/)?/\1\2\4/g')
  FILE_NAME=$(basename $(pwd))

  # Start bracket
  PS1="${BOLD}${GREEN}["

  # Folder path
  PS1+="${RESET}${FOLDER_PATH}/"
  # File name
  PS1+="${BOLD}${CYAN}${FILE_NAME}"

  # Display current branch if in a git repository
  if [ -n "$(git rev-parse --git-dir 2>/dev/null)" ]; then
    GIT_BRANCH="$(git branch --show-current)"
    PS1+="${RESET}:"
    PS1+="${BOLD}${YELLOW}${GIT_BRANCH}"
  fi

  # End bracket
  PS1+="${BOLD}${GREEN}]"

  # Line start marker
  PS1+="${BOLD}${GREEN}$ "

  # Color reset
  PS1+="${RESET}"
}

PROMPT_COMMAND='update_ps1'
