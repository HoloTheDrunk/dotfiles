#
# ~/.bashrc
#

[[ $- != *i* ]] && return

export VISUAL=nvim
export EDITOR="$VISUAL"
export BROWSER='/usr/bin/firefox'

export COLOR_PATH="$HOME/.colors"

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

    alias ls='exa'
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

function truerm() {
  test $# -lt 1 && echo "Usage: truerm FILE" && return 1
  head -c $(wc -c $1 | cut -d ' ' -f 1) /dev/random > $1
  rm $1
}

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

# Setup PostgreSQL
export PGDATA="$HOME/.postgres_data"
export PGHOST="/tmp"

# Setup Cargo
. "$HOME/.cargo/env"

# ex - archive extractor
# usage: ex <file>
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

function home()
{
  if [ -n "$1" ]; then
    sed -E "s/\/home\/$USER/~/g" <<< "$1"
  fi
}

function hist()
{
  [ $# -ne 1 ] && echo "Usage: $0 [on|off]" && return 1

  [ "$1" = 'on' ] && set -o history && return 0
  [ "$1" = 'off' ] && set +o history && return 0
}

alias j='jobs'
alias lsa='exa -hl'
alias ll='exa -l'
alias lt='exa -TL'
alias cs='clear; ls'

function cpm() {
    [ $# -ne 2 ] && echo "Usage: cpm <source> <dest folder>." && return 1
    test -f "$2" && echo "Destination must be a folder." && return 1

    mkdir -p "$2"
    cp "$1" "$2"
}

alias brc='nvim ~/.bashrc'
alias vrc='nvim ~/.vimrc'
alias zrc='nvim ~/.zshrc'
alias krc='nvim ~/.config/kitty/kitty.conf'
alias nvrc='nvim ~/.config/nvim/init.vim'

alias reload='source ~/.bashrc'

function gl()
{
  [ $# -eq 1 ] && [ "$1" -ge 0 ] && visible="$1" || visible=10
  git lol -"$visible"
  lines=$(($(git lol | grep -E '^([*/|\]|\s)*[0-9a-f]' |  wc -l) - visible - 1))
  [ $lines -gt 0 ] && echo "$lines older commits..."
}

function gu()
{
    git fetch --all
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git pull --all
}

alias lg='lazygit'

alias gs='git status'
alias ga='git add'
alias gc='git commit -v'
alias gt='git tag'
alias gp='git push'
alias gd='git diff'
alias gr='git restore'

alias gpl='git pull'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias grs='git restore --staged'
alias gsw='git switch'
alias gri='git rebase -i'

alias gcce='gcc -Werror -Wall -Wextra -std=c99 -fsanitize=address'
alias gccurses='gcc -pedantic -fsanitize=address -lncurses'

alias greg='eval `ssh-agent`; ssh-add'

alias vroom='cargo run'

function connect-headphones()
{
  bluetoothctl power on
  bluetoothctl devices | grep "OneOdio A70" | cut -d ' ' -f 2 | xargs bluetoothctl connect
}

function changecase()
{
  if [ $# -ne 2 ]; then
    echo "Usage: $0 [-l|-u] string"
    return 1
  fi

  [ "$1" = '-l' ] && tr A-Z a-z <<< $2
  [ "$1" = '-u' ] && tr a-z A-Z <<< $2
}

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

function gccada()
{
    [ $# -eq 0 ] && echo "Usage: gccada main [file...]" && return 1

    BIN="${1%.*}"

    # gcc -c "$@" && gnatbind "$BIN" && gnatlink "$BIN"
    gnat make -gnata "$@" &>/dev/null
    gnatclean -c "$@" &>/dev/null

    COMMAND="./$BIN"

    echo "'$COMMAND' copied to clipboard"
    echo -n "$COMMAND" | xsel -b
}

RESET="\[\033[0m\]"
BOLD="\[\033[1m\]"
FAINT="\[\033[2m\]"
ITALIC="\[\033[3m\]"
UNDERLINE="\[\033[4m\]"
SBLINK="\[\033[5m\]"
RBLINK="\[\033[6m\]"
INVERT="\[\033[7m\]"
HIDE="\[\033[8m\]"
STRIKE="\[\033[9m\]"

BLACK="\[\033[30m\]"
RED="\[\033[31m\]"
GREEN="\[\033[32m\]"
YELLOW="\[\033[33m\]"
BLUE="\[\033[34m\]"
MAGENTA="\[\033[35m\]"
CYAN="\[\033[36m\]"
WHITE="\[\033[37m\]"

function update_ps1()
{
  LAST_CMD_RES="$?"
  # Shrunk path
  FOLDER_PATH=$(dirname "$(pwd)" | sed -E 's/^\/home/~/g' | sed -E 's/(\/?)([^/])([^/]+)(\/)?/\1\2\4/g')
  FILE_NAME=$(basename "$(pwd)")

  # Start bracket
  PS1="${BOLD}${GREEN}[${RESET}"

  JOB_COUNT="$(jobs | wc -l)"
  if [ "$JOB_COUNT" -gt 0 ]; then
    PS1+="${BOLD}${BLUE}${JOB_COUNT}${RESET}:"
  fi

  # Folder path
  # PS1+="${FOLDER_PATH}"
  # File name
  PS1+="${BOLD}${CYAN}${FILE_NAME}${RESET}"

  # Display current branch if in a git repository
  if [ -n "$(git rev-parse --git-dir 2>/dev/null)" ]; then
    GIT_BRANCH="$(git branch --show-current)"

    PS1+=":"

    # Display state of repository
    # RED => uncommitted changes
    # MAGENTA => both ahead and behind
    # YELLOW => ahead
    # BLUE => behind
    # GREEN => everything up-to-date
    AHEAD="$(git status -sb | grep ahead | wc -l)"
    BEHIND="$(git status -sb | grep behind | wc -l)"
    PS1+="${BOLD}"
    if [ "$(git diff | wc -l)" -gt 0 ] || [ "$(git status | grep -E "(new|modified|deleted)" | wc -l)" -gt 0 ] ; then
      PS1+="${RED}"
    elif [ "$AHEAD" -gt 0 ] && [ "$BEHIND" -gt 0 ]; then
      PS1+="${MAGENTA}"
    elif [ "$AHEAD" -gt 0 ]; then
      PS1+="${YELLOW}"
    elif [ "$BEHIND" -gt 0 ]; then
      PS1+="${BLUE}"
    else
      PS1+="${GREEN}"
    fi

    if [ "$(git rev-parse --show-toplevel)" = "$HOME" ]; then
      PS1+='~'

      if [ "${GIT_BRANCH}" != "master" ] && [ "${GIT_BRANCH}" != "main" ]; then
        PS1+="${GIT_BRANCH}"
      fi
    else
      PS1+="${GIT_BRANCH}"
    fi
  fi

  # End bracket
  PS1+="${BOLD}${GREEN}]${RESET}"

  if [ "$LAST_CMD_RES" -ne 0 ]; then
    PS1+="${BOLD}${GREEN}{${RED}$LAST_CMD_RES${GREEN}}${RESET}"
  fi

  # Line start marker
  PS1+="${BOLD}${GREEN}$ ${RESET}"
}

PROMPT_COMMAND='update_ps1'

function find-package()
{
  pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse
}

# XXX
function blame-all()
{
    #FILENAMES="$(find . -name '*.cc' -o -name '*.hh' -o -name '*.hxx' -o -name '*.yy' -o -name '*.ll')"
    RAW_FILENAMES="$(git ls-tree -r "$(git branch --show-current)" --name-only)"
    FILENAMES=""
    FILENAMES+="$(grep '\.cc$' <<< "$RAW_FILENAMES")
$(grep '\.hh$' <<< "$RAW_FILENAMES")
$(grep '\.hxx$' <<< "$RAW_FILENAMES")
$(grep '\.ll$' <<< "$RAW_FILENAMES")
$(grep '\.yy$' <<< "$RAW_FILENAMES")
"

    declare -A AUTHORS

    while IFS= read -r file; do
        [ -z "$file" ] && continue
        echo "Handling file $file"

        ENTRIES="$(git blame -f "$file" | cut -d ' ' -f 3-4 | cut -c2- | sort | uniq -c | sort -nr | tr -s ' ' | cut -c2-)"

        while IFS= read -r entry; do
            COUNT="$(cut -d ' ' -f 1 <<< "$entry")"
            AUTHNAME="$(cut -d ' ' -f 2- <<< "$entry" | sed -e 's/ë/e/i')"

            ([ -z "$AUTHNAME" ] || [ -z "$COUNT" ]) && echo -e "\nError parsing" && return 1

            if [[ "${!AUTHORS[*]}" =~ "$AUTHNAME" ]]; then
                AUTHORS["$AUTHNAME"]=$((AUTHORS["$AUTHNAME"] + COUNT))
            else
                AUTHORS["$AUTHNAME"]=0
            fi
        done <<< "$ENTRIES"
    done <<< "$FILENAMES"

    echo "${#AUTHORS[@]} authors:"
    for key in "${!AUTHORS[@]}"; do
        # AUTHNAMEKEY="${AUTHORS["${${!AUTHORS[@]}[$i]}"]} ${AUTHORS[$((i + 1))]}"
        COMMIT_COUNT="$(git log --format='%an' | sed -e 's/ë/e/i' | grep "$key" | wc -l)"
        echo "$key: ${AUTHORS["$key"]} in $COMMIT_COUNT commits"
    done | sort -nrk3
}

function todo()
{
    [ ! -f "$HOME/.todo" ] && echo "No file at '$HOME/.todo'" && return 1
    # clear
    cat -n "$HOME/.todo" | tail -n 10
}

function todo-reg()
{
    [ ! -f "$HOME/.todo" ] && echo "No file at '$HOME/.todo'" && return 1
    echo "$@" >> "$HOME/.todo"
    todo
}

function todo-pop()
{
    [ ! -f "$HOME/.todo" ] && echo "No file at '$HOME/.todo'." && return 1
    [ "$#" -ne 1 ] && echo "Usage: todo-pop LINE" && return 1
    [ "$1" -gt "$(wc -l <> "$HOME/.todo")" ] || [ "$1" -lt 1 ] && echo "Out of bounds line number." && return 1
    sed -i "$1d" "$HOME/.todo"
    todo
}

function lcfiles()
{
    RECURSE="$1"

    LIMIT="$2"
    [ -z "$LIMIT" ] && LIMIT=1

    DEPTH="$3"
    [ -z "$DEPTH" ] && DEPTH=0


    for file in *; do
        [ "$file" = '*' ] && return 1

        NEW_NAME="$(tr A-Z a-z <<< "$file")"

        for i in $(seq 1 "$DEPTH"); do
            echo -ne "  "
        done
        echo -n "<> "

        if [ ! "$file" = "$NEW_NAME" ]; then
            if [ -d "$NEW_NAME" ]; then
                echo "$file/ -> $NEW_NAME/"
            else
                echo "$file -> $NEW_NAME"
            fi

            mv "$file" "$NEW_NAME"
        else
            if [ -d "$NEW_NAME" ]; then
                echo "$NEW_NAME/"
            else
                echo "$NEW_NAME"
            fi
        fi

        if [ "$DEPTH" -lt "$LIMIT" ] && [ "$RECURSE" = "-r" ] && [ -d "$NEW_NAME" ]; then
            cd "$NEW_NAME"
            lcfiles "-r" "$LIMIT" "$((DEPTH + 1))"
            DEPTH=$((DEPTH - 1))
            cd ..
        fi
    done
}

function cmake-gen() {
    [ -f 'CMakeLists.txt' ] && rm 'CMakeLists.txt'
    touch 'CMakeLists.txt'

    echo 'cmake_minimum_required(VERSION 3.21.2)' >> 'CMakeLists.txt'
    echo 'project(cmake)' >> 'CMakeLists.txt'

    # SRC listing
    echo -n "set(SRC " >> 'CMakeLists.txt'

    SOURCE_FILES="$(find -name '*.cc' | cut -d '/' -f 2)"

    i=0
    len="$(wc -l <<< "$SOURCE_FILES")"
    for file in $SOURCE_FILES; do
        [ $i -ne 0 ] && echo -n "        " >> 'CMakeLists.txt'
        if [ $i -ne $((len - 1)) ]; then
            echo "$file" >> 'CMakeLists.txt'
        else
            echo -n "$file" >> 'CMakeLists.txt'
        fi
        i=$((i + 1))
    done
    echo ')' >> 'CMakeLists.txt'

    echo 'set(CMAKE_CXX_STANDARD 20)' >> 'CMakeLists.txt'
    echo 'set(CMAKE_CXX_FLAGS "-Wall -Wextra -Werror -pedantic")' >> 'CMakeLists.txt'

    echo 'add_executable(main ${SRC})' >> 'CMakeLists.txt'
}

function cmake-lsp() {
  cmake $@ -DCMAKE_EXPORT_COMPILE_COMMANDS=1
}

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION

export PATH="$HOME/.config/bash/nannou:$PATH"

# XXX REMOVE XXX
alias tiger='cd $HOME/EPITA/s6/cpp/tiger/'

todo
export GPG_TTY=$(tty)

# Activate completion scripts
if [ -d "$HOME/.config/bash/completion/" ]; then
  for file in "$HOME"/.config/bash/completion/*.sh; do
    [ -f "$file" ] && source "$file"
  done
fi

alias yeet-orphans='sudo pacman -Qtdq | sudo pacman -Rns -'

function kittyc {
  kitty @ set-colors -a "$HOME/.config/kitty/$1.conf"
}

alias icat="kitty +kitten icat"

if command -v pipes-rs &>/dev/null; then
  alias pipes='pipes-rs -p 100 -k heavy,light -c rgb -d 10 -r 1 -t 0.1 --palette matrix'
fi

if test "$(cat /etc/hostname)" = "efarch"; then
  alias bloomrpc='~/Stockly/BloomRPC-1.5.3.AppImage --disable-features=VizDisplayCompositor'
fi

# pnpm
export PNPM_HOME="/home/raphaeld/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

export STOCKLY_MAIN="$HOME/Stockly/Main"
# pnpm end
export PGDATA="$HOME/postgres_data"
export PGHOST="/tmp"

PATH="/home/raphaeld/.scripts/scripts/.symlinks:$PATH"

export JUPYTERLAB_DIR="$HOME/.local/share/jupyter/lab"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

export EPITA_LOGIN="raphael.duhen"
