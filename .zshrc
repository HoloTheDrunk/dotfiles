# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/raphaeld/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="alanpeabody"

USE_POWERLINE="true"

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
	source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
	source /usr/share/zsh/manjaro-zsh-prompt
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

setopt nobeep
setopt autocd

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	fzf
	history-substring-search
	colored-man-pages
	zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-z
)

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#	export EDITOR='vim'
# else
#	export EDITOR='mvim'
# fi
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias reload='source ~/.zshrc'

alias zrc='vim ~/.zshrc'
alias vrc='vim ~/.vimrc'

alias ls='ls --color'
alias ll='ls -FBg --group-directories'
alias lla='ll -a'

alias cs='clear; ls'

alias :q='exit'

alias gcc='gcc -Wall -Wextra -Werror -std=c99'

alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gt='git tag'
alias gp='git push --follow-tags'
alias gooo='ga -u; gc "feat: Automated quick commit"; gp'

alias gcc='gcc -Werror -Wall -Wextra -std=c99 -fsanitize=address'
alias gccurses='gcc -pedantic -fsanitize=address -lncurses'

function gl()
{
    [ $# -eq 1 ] && [ "$1" -ge 0 ] && visible="$1" || visible=10
    git lol -"$visible"
    lines=$(($(git lol | wc -l) - visible))
    [ $lines -gt 0 ] && echo "$lines older commits..."
}

function vidconvert() {
	[ $# -lt 1 ] && echo "Missing filename(s)" && return 1
	echo -ne "Output format: "
	read format
	for i in $(seq $#); do
		rm -f "${1:0:-4}.mp4"
		ffmpeg -i "$1" -codec copy "${1:0:-4}.$format" 2>/dev/null
		echo "Converted $1 to ${1:0:-4}.$format"
		shift 1
	done
}

function krc() {
	case $# in
		0)
			vim ~/.config/kitty/kitty.conf;;
		2)
			if [ $1 = "-t" ]; then
				vim ~/.config/kitty/$2.conf
				fi;;
			*)
				echo "Usage: krc [-t (theme file name)]\n"
		esac
	}

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fdfind --type f'
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --height=80%"

# opam configuration
[[ ! -r /home/raphaeld/.opam/opam-init/init.zsh ]] || source /home/raphaeld/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
PATH="/home/raphaeld/Stockly/Main/integrations/scripts/.symlinks:$PATH"
PATH="/home/raphaeld/scripts/.symlinks:$PATH"
PATH="/home/raphaeld/.scripts/scripts/.symlinks:$PATH"
