# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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

alias zshconfig="nvim ~/.zshrc"
alias tmuxconfig="nvim ~/.config/tmux/tmux.conf"
alias scd='(){if [[ -n $1 ]]; then cd $(find $1/* -type d | fzf); else cd $(find * -type d | fzf); fi}'
alias grepc="grep --color=always"
alias gete='(){LC_CTYPE=C sed -n "/$1/,/^[^[:blank:]]/p" $2}'
alias svndiff='(){svn diff -r PREV:HEAD $1 | delta}'

# Using 256-colors mode
# export TERM="xterm-256color"
export XDG_CONFIG_HOME="$HOME/.config" 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# export PATH="/usr/local/opt/python/libexec/bin:$PATH"
#
# zle_highlight+=(paste:none)
# export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
bindkey '^j' autosuggest-accept

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_COMPLETION_OPTS='--border --info=inline'
if [ -n "$NVIM" ]; then
    alias nvim="nvr -l --remote"
fi

export PATH="$HOME/.local/bin:$PATH"

if [ -n "$NVIM" ]; then
    alias nvim="nvr -l --remote"
else
    alias nvim="nvim"
fi

export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(zoxide init zsh)"

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gshow() {
    is_in_git_repo || return
    git log --color=always \
        --format="%Cred%h%Creset %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset %s" "$@" |
    fzf --height 100% --ansi --no-sort --reverse --tiebreak=index \
        --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
    (grep -o '[a-f0-9]\{7\}' | head -1 |
    xargs -I % zsh -c 'git show % --color=always | less -R') << 'FZF-EOF'
    {}
    FZF-EOF"
}
gdiff() {
    is_in_git_repo || return
    cp $(git diff --name-only HEAD $2) $1
    cd $1
}
