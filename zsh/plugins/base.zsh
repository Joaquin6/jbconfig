source $HOME/antigen/antigen.zsh

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -d "$$HOME/.phpbrew" ] && \. "$HOME/.phpbrew/bashrc"
[ -f "/usr/local/etc/bash_completion" ] && \. "/usr/local/etc/bash_completion"
if [ -f $USER_LOCAL_BIN/virtualenvwrapper.sh ]; then
  source $USER_LOCAL_BIN/virtualenvwrapper.sh
  export WORKON_HOME=$HOME/Code/VirtualEnvs
fi
if which rbenv &> /dev/null; then
	if [ -d $HOME/.rbenv ]; then
	  	export PATH=$HOME/.rbenv/bin:$PATH
		eval "$(rbenv init -)"
	fi
fi

antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
	autoenv
	battery
	command-not-found
	dotenv
	history
	history-substring-search
	sudo
	gpg-agent
	ssh-agent
	jsontools
	profiles
	git
	node
	npm
	npx
	yarn
	gnu-utils
	cygwin
	debian
	systemd
	systemadmin
EOBUNDLES

# OS Based Plugins
if [[ "$OSTYPE" == darwin* ]]; then
 	antigen bundle iterm2
	antigen bundle gem
	antigen bundle osx
	antigen bundle brew
	antigen bundle cask
elif [[ "$OSTYPE" == linux* ]]; then
	antigen bundle brew
	antigen bundle cask
fi

antigen bundle zsh-users/zsh-syntax-highlighting 		# https://github.com/zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search 	# https://github.com/zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions            # https://github.com/zsh-users/zsh-autosuggestions
antigen bundle ascii-soup/zsh-url-highlighter
antigen bundle djui/alias-tips                          # https://github.com/djui/alias-tips
antigen bundle jocelynmallon/zshmarks                   # https://github.com/jocelynmallon/zshmarks
antigen bundle Joaquin6/git-aliases                     # https://github.com/Joaquin6/git-aliases

# Suuply the theme
antigen theme denysdovhan/spaceship-prompt spaceship
# Tell antigen that you're done.
antigen apply

# User configuration

# Theme configuration
typeset -gA ZSH_HIGHLIGHT_STYLES
# All options must be overridden in your .zshrc file after the theme.
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern url)
export ZSH_HIGHLIGHT_URL_HIGHLIGHTER_TIMEOUT=4
export ZSH_HIGHLIGHT_STYLES[url-good]='fg=blue,bold'
export ZSH_HIGHLIGHT_STYLES[url-bad]='fg=magenta,bold'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=green,bold'

# Spaceship Prompt Options -  https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Options.md
export SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  golang        # Go section
  php           # PHP section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  pyenv         # Pyenv section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

export SPACESHIP_RPROMPT_ORDER=(
	time          # Time stampts section
	battery       # Battery level and status
)

export SPACESHIP_TIME_SHOW=true
export SPACESHIP_TIME_12HR=true
