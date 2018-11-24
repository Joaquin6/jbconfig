# 	REFERENCES
#	-------------------------------
#	http://zsh.sourceforge.net/Guide/zshguide.html


############################################# private ##############################################
# Set debug level. If enabled (> 0) it will print information to stderr.
# 	0: no debug messages (Default)
# 	1: generic debug logging
# 	2: more verbose messages
# 		messages about adding/removing files on the internal stack
# 	3: everything
# 		sets xtrace option (set -x) while sourcing env files

jb-zsh-debug()
{
  local level=${2:-1}
  if (( JB_ZSH_DEBUG < level )); then
    return
  fi
  local msg="$1"  # Might trigger a bug in Zsh 5.0.5 with shwordsplit.
  # Load zsh color support.
  if [[ -z $color ]]; then
    autoload colors
    colors
  fi
  # Build $indent prefix.
  local indent=
  if [[ $_jb_zsh_debug_indent -gt 0 ]]; then
    for i in {1..${_jb_zsh_debug_indent}}; do
      indent="  $indent"
    done
  fi

  # Split $msg by \n (not newline).
  lines=(${(ps:\\n:)msg})
  for line in $lines; do
    echo -n "${fg_bold[blue]}[jb-zsh-config]${fg_no_bold[default]}	" >&2
    echo ${indent}${line} >&2
  done
}

handle-add-path()
{
	local incoming_path="$1"
	# Check if $incoming_path exists.
	if [ -d "$incoming_path" ]; then
		# Control will enter here if $incoming_path exists.
		# My check to make sure the new node path is added to the PATH variable
		if [[ "$PATH" != *"$incoming_path"* ]]; then
			# Check if $PATH is set
			if [ -z ${PATH+x} ]; then
				# Control will enter here if $PATH is not set.
				export PATH="$incoming_path"
			else
				# Control will enter here if $PATH is set.
				export PATH="$incoming_path:$PATH"
			fi
		fi
	else
		# Control will enter here if $incoming_path doesn't exist.
		# Check if we have $JB_ZSH_DEBUG set to true
		jb-zsh-debug "[PATH DEBUG]: 	$incoming_path doesn't exist. Not adding to PATH"
	fi
}

handle-add-manpath()
{
	local incoming_path="$1"
	# Check if $incoming_path exists.
	if [ -d "$incoming_path" ]; then
		# Control will enter here if $incoming_path exists.
		# My check to make sure the new pkg config path is added to the MANPATH variable
		if [[ "$MANPATH" != *"$incoming_path"* ]]; then
			# Check if $MANPATH is set
			if [ -z ${MANPATH+x} ]; then
				# Control will enter here if $MANPATH is not set.
				export MANPATH="$incoming_path"
			else
				# Control will enter here if $MANPATH is set.
				export MANPATH="$incoming_path:$MANPATH"
			fi
		fi
	else
		# Control will enter here if $incoming_path doesn't exist.
		# Check if we have $JB_ZSH_DEBUG set to true
		jb-zsh-debug "[MANPATH DEBUG]: 	$incoming_path doesn't exist. Not adding to MANPATH"
	fi
}

handle-add-infopath()
{
	local incoming_path="$1"
	# Check if $incoming_path exists.
	if [ -d "$incoming_path" ]; then
		# Control will enter here if $incoming_path exists.
		# My check to make sure the new pkg config path is added to the INFOPATH variable
		if [[ "$INFOPATH" != *"$incoming_path"* ]]; then
			# Check if $INFOPATH is set
			if [ -z ${INFOPATH+x} ]; then
				# Control will enter here if $INFOPATH is not set.
				export INFOPATH="$incoming_path"
			else
				# Control will enter here if $INFOPATH is set.
				export INFOPATH="$incoming_path:$INFOPATH"
			fi
		fi
	else
		# Control will enter here if $incoming_path doesn't exist.
		# Check if we have $JB_ZSH_DEBUG set to true
		jb-zsh-debug "[INFOPATH DEBUG]: 	$incoming_path doesn't exist. Not adding to INFOPATH"
	fi
}

handle-add-pkgconfigpath()
{
	local incoming_path=/usr/local/opt/$1/lib/pkgconfig
	# Check if $incoming_path exists.
	if [ -d "$incoming_path" ]; then
		# Control will enter here if $incoming_path exists.
		# My check to make sure the new pkg config path is added to the PKG_CONFIG_PATH variable
		if [[ "$PKG_CONFIG_PATH" != *"$incoming_path"* ]]; then
			# Check if $PKG_CONFIG_PATH is set
			if [ -z ${PKG_CONFIG_PATH+x} ]; then
				# Control will enter here if $PKG_CONFIG_PATH is not set.
				export PKG_CONFIG_PATH="$incoming_path"
			else
				# Control will enter here if $PKG_CONFIG_PATH is set.
				export PKG_CONFIG_PATH="$incoming_path:$PKG_CONFIG_PATH"
			fi
		fi
	else
		# Control will enter here if $incoming_path doesn't exist.
		# Check if we have $JB_ZSH_DEBUG set to true
		jb-zsh-debug "[PKG_CONFIG_PATH DEBUG]: 	$incoming_path doesn't exist."
		# Check if brew is a command. If so, suggest installing with brew
		if which brew &> /dev/null; then
			jb-zsh-debug "[PKG_CONFIG_PATH DEBUG]: 	Suggestion => \"brew install $1\"" 2
		fi
	fi
}
load-syntax-highlighting() {
	local plugins=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
	local syntax_highlighting=${ANTIGEN_BUNDLES:-~/.antigen/bundles}/zsh-users/zsh-syntax-highlighting
	local highlighter_repo=git@github.com:zsh-users/zsh-syntax-highlighting.git

	if [ ! -d $plugins/zsh-syntax-highlighting ]; then
		jb-zsh-debug "[LOAD SYNTAX HIGHLIGHTING DEBUG]: 	creating $plugins/zsh-syntax-highlighting"
		mkdir -p $plugins/zsh-syntax-highlighting
		jb-zsh-debug "[LOAD SYNTAX HIGHLIGHTING DEBUG]: 	$plugins/zsh-syntax-highlighting created."

		jb-zsh-debug "[LOAD SYNTAX HIGHLIGHTING DEBUG]: 	cloning $highlighter_repo into $plugins/zsh-syntax-highlighting" 2
		git clone $highlighter_repo $plugins/zsh-syntax-highlighting
		jb-zsh-debug "[LOAD SYNTAX HIGHLIGHTING DEBUG]: 	$highlighter_repo was cloned successfully" 2
	fi
}
load-url-highlighter() {
	local plugins=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
	local syntax_highlighting=${ANTIGEN_BUNDLES:-~/.antigen/bundles}/zsh-users/zsh-syntax-highlighting
	local highlighter_repo=git@github.com:ascii-soup/zsh-url-highlighter.git

	if [ ! -d $plugins/zsh-url-highlighter ]; then
		jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	creating $plugins/zsh-url-highlighter"
		mkdir -p $plugins/zsh-url-highlighter
		jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	$plugins/zsh-url-highlighter created."

		jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	cloning $highlighter_repo into $plugins/zsh-url-highlighter" 2
		git clone $highlighter_repo $plugins/zsh-url-highlighter
		jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	$highlighter_repo was cloned successfully" 2
	fi

  if [ ! -L $syntax_highlighting/highlighters/url ]; then
	  jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	linking $plugins/zsh-url-highlighter/url to $syntax_highlighting/highlighters/url" 2
	  ln -s $plugins/zsh-url-highlighter/url $syntax_highlighting/highlighters
	  jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	$plugins/zsh-url-highlighter/url to $syntax_highlighting/highlighters/url linked successfully" 2
  fi
}
command_exists () {
  type "$1" &> /dev/null;
}


#   CONFIGURATION VARIABLES
#   -------------------------------

export USER_BIN=/usr/bin
export USER_LOCAL=/usr/local
export USER_SHARE=/usr/share
export SYS_LIB_PATH=/System/Library

export PATH=$HOME/bin:/usr/local/bin:$PATH
export HOME_LIB_PATH=$HOME/Library
export SYS_FRWKS_PATH=$SYS_LIB_PATH/Frameworks
export USER_LOCAL_GO=$USER_LOCAL/go
export USER_LOCAL_BIN=$USER_LOCAL/bin
export USER_LOCAL_ETC=$USER_LOCAL/etc
export USER_LOCAL_LIB=$USER_LOCAL/lib
export USER_LOCAL_OPT=$USER_LOCAL/opt
export USER_LOCAL_MAN=$USER_LOCAL/man
export USER_LOCAL_SHARE=$USER_LOCAL/share
export USER_LOCAL_FRWKS=$USER_LOCAL/Frameworks
export MANPATH=$USER_LOCAL_MAN

export RBENV_SHELL=zsh
export PYTHON_VERSION=Current
export RUBY_VERSION="2.5.3p105"
export RBENV_VERSION="rbx-3.105"
export RBENV_ROOT=$HOME/.rbenv
export RBENV_DIR=$RBENV_ROOT/bin
export MONO_GAC_PREFIX=$USER_LOCAL
if command_exists python; then
  export PYTHON_VERSION=$(python -c 'import platform; print(platform.python_version())')
else
  echo "Python has not been installed!"
fi


# If you come from bash you might have to change your $PATH.
handle-add-path $USER_BIN
handle-add-path $HOME/antigen
handle-add-path $USER_LOCAL_FRWKS/Python.framework/Versions/Current/bin
handle-add-path $USER_LOCAL_OPT/gettext/bin
handle-add-path $USER_LOCAL_OPT/llvm/bin
handle-add-path $USER_LOCAL_OPT/apr/bin
handle-add-path $USER_LOCAL_OPT/apr-util/bin
handle-add-path $USER_LOCAL_OPT/icu4c/bin
handle-add-path $USER_LOCAL_OPT/icu4c/sbin
handle-add-path $USER_LOCAL_OPT/libpq/bin
handle-add-path $USER_LOCAL_OPT/coreutils/libexec/gnubin
handle-add-path $USER_LOCAL_OPT/sqlite/bin
handle-add-path $USER_LOCAL_OPT/go/libexec/bin
handle-add-path $USER_LOCAL_OPT/gnu-tar/libexec/gnubin
handle-add-path $USER_LOCAL_OPT/libarchive/bin
handle-add-path $USER_LOCAL_OPT/openssl/bin
handle-add-path $USER_LOCAL_OPT/gnu-sed/libexec/gnubin
handle-add-path $USER_LOCAL_GO/bin
handle-add-path $USER_LOCAL_OPT/go/libexec/bin
handle-add-path $PERL_LOCAL_LIB_ROOT/bin

handle-add-infopath $USER_SHARE/info

handle-add-manpath $USER_LOCAL_OPT/gnu-tar/libexec/gnuman
handle-add-manpath $USER_LOCAL_OPT/gnu-sed/libexec/gnuman
handle-add-manpath $USER_LOCAL_OPT/coreutils/libexec/gnuman

handle-add-pkgconfigpath libffi
handle-add-pkgconfigpath icu4c
handle-add-pkgconfigpath libpq
handle-add-pkgconfigpath sqlite
handle-add-pkgconfigpath libarchive
handle-add-pkgconfigpath openssl

export TERM="xterm-256color"
export ARCHFLAGS="-arch x86_64"
export LDFLAGS=(-L$USER_LOCAL_OPT/{gettext,icu4c,libarchive,openssl,readline}/lib)
export CPPFLAGS=(-I$USER_LOCAL_OPT/{gettext,icu4c,libarchive,openssl,readline}/include)
export XDG_CONFIG_HOME=$HOME/.config
export DEFAULT_MACHINE="default"
export DOCKER_ETC_CONTENTS=/Applications/Docker.app/Contents/Resources/etc
export OOO_FORCE_DESKTOP=gnome

export SSH_PATH=$HOME/.ssh
export SSH_ENV=$SSH_PATH/environment
export SSH_PRIVATE_KEY=$SSH_PATH/id_rsa
export SSH_KEY_PATH=$SSH_PRIVATE_KEY
export SSH_KNOWN_HOSTS=$SSH_PATH/known_hosts

export GREP_COLOR='1;31'
export LESS="-R"
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESSHISTFILE=/dev/null
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;37m'
export OOO_FORCE_DESKTOP=gnome

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.histfile
export HISTCONTROL=erasedups
export HISTIGNORE='&:ls:ll:la:l.:pwd:exit:clear:clr:[bf]g'

export RED='\[\033[0;31m\]'
export PINK='\[\033[1;31m\]'
export YELLOW='\[\033[1;33m\]'
export GREEN='\[\033[0;32m\]'
export LT_GREEN='\[\033[1;32m\]'
export BLUE='\[\033[0;34m\]'
export WHITE='\[\033[1;37m\]'
export PURPLE='\[\033[1;35m\]'
export CYAN='\[\033[1;36m\]'
export BROWN='\[\033[0;33m\]'
export COLOR_NONE='\[\033[0m\]'

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export PAGER='less'
export VISUAL='nano'
export EDITOR='nano'

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

export NVM_DIR=$HOME/.nvm
export ZSH=$HOME/.oh-my-zsh
export ZSHA_BASE=$HOME/.antigen
export ZSH_CUSTOM=$ZSH/custom
export ZSH_THEME=spaceship
export GOPATH=$HOME/projects/go
export JB_ZSH_BASE=$HOME/jbconfig
export GROOVY_HOME=$USER_LOCAL_OPT/groovy/libexec
export ANTIGEN_BUNDLES=$HOME/.antigen/bundles
export WORKON_HOME=$HOME/.virtualenvs
export XDG_DATA_DIRS=$USER_LOCAL_SHARE
export PERL_LOCAL_LIB_ROOT=$HOME/perl5
export PERL5LIB=$PERL_LOCAL_LIB_ROOT/lib/perl5

handle-add-path $(go env GOPATH)/bin

# export ZSH_THEME="powerlevel9k/powerlevel9k"
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
export ADOTDIR=$ZSHA_BASE
export GCLOUD_SDK_PATH=$USER_LOCAL_SHARE/google-cloud-sdk

export POWERLEVEL9K_PROMPT_ON_NEWLINE=true
export POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
export POWERLEVEL9K_MODE='nerdfont-complete'
export POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
export POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "
export POWERLEVEL9K_INSTALLATION_PATH=$ZSH_CUSTOM/themes
export POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S \uE868  %d.%m.%y}"

export JB_ZSH_DEBUG=1
export AUTOENV_DEBUG=0

# Paths
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path
# Set the list of directories that cd searches.
cdpath=(
  $cdpath
)
# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)
fpath=(
	$HOME/.config/completion
	$USER_LOCAL_ETC/bash_completion.d
	$USER_LOCAL_SHARE/zsh-completions
	$USER_LOCAL_SHARE/zsh/site-functions
	$fpath
)

source $HOME/.local/share/fonts/*.sh
source $HOME/antigen/antigen.zsh
source $POWERLEVEL9K_INSTALLATION_PATH/spaceship.zsh-theme

[ -s $NVM_DIR/nvm.sh ] && . $NVM_DIR/nvm.sh
[ -f $USER_LOCAL_ETC/bash_completion ] && \. $USER_LOCAL_ETC/bash_completion
if [ -f $USER_LOCAL_BIN/virtualenvwrapper.sh ]; then
  source $USER_LOCAL_BIN/virtualenvwrapper.sh
  export WORKON_HOME=$HOME/Code/VirtualEnvs
fi
if which rbenv &> /dev/null; then
	if [ -d $HOME/.rbenv ]; then
		handle-add-path $HOME/.rbenv/bin
		handle-add-path $HOME/.rbenv/shims
		eval "$(rbenv init -)"
	fi
fi

COMPLETION_WAITING_DOTS="true"

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

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting    # https://github.com/zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search   # https://github.com/zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions            # https://github.com/zsh-users/zsh-autosuggestions
antigen bundle ascii-soup/zsh-url-highlighter
antigen bundle zsh-users/zsh-completions
antigen bundle djui/alias-tips                          # https://github.com/djui/alias-tips
antigen bundle jocelynmallon/zshmarks                   # https://github.com/jocelynmallon/zshmarks
antigen bundle Joaquin6/git-aliases                     # https://github.com/Joaquin6/git-aliases
antigen bundle zpm-zsh/autoenv              # https://github.com/zpm-zsh/autoenv
# antigen bundle lukechilds/zsh-nvm

load-url-highlighter

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

handle-add-path $(yarn global bin)
handle-add-path $USER_LOCAL/bin
handle-add-path $USER_LOCAL/sbin
handle-add-manpath $USER_LOCAL/share/man
handle-add-manpath $USER_LOCAL_OPT/coreutils/libexec/gnuman
handle-add-infopath $USER_LOCAL/share/info

if [ -f $USER_LOCAL_BIN/virtualenvwrapper.sh ]; then
  source $USER_LOCAL_BIN/virtualenvwrapper.sh
  export WORKON_HOME=$HOME/Code/VirtualEnvs
fi

if [ -f $USER_LOCAL_BIN/aws_zsh_completer.sh ]; then
  source $USER_LOCAL_BIN/aws_zsh_completer.sh
fi

if [ -f $USER_LOCAL_ETC/bash_completion.d ]; then
  . $USER_LOCAL_ETC/bash_completion.d
fi

source $JB_ZSH_BASE/zsh/.zsh_aliases
source $JB_ZSH_BASE/zsh/.zsh_functions

# place this after nvm initialization!
autoload -U add-zsh-hook
load-user-specifics() {
	local incoming_user=$USER
	local machine_hostname="$(hostname -f)"


	# Handle git configs
	if [[ $PWD == *"cattlebruisers"* && $machine_hostname == "ip-192-168-1-26" ]]; then
		jb-zsh-debug "[USER DEBUG]: 	Setting \"CattleBruisers\" git configs"

		git config --local --unset user.name
		git config --local user.name "Joaquin Briceno"
		git config --local --unset user.email
		git config --local user.email joaquin.briceno@insitu.com
	elif [[ $PWD != *"cattlebruisers"* && $machine_hostname == "ip-192-168-1-26" ]]; then
		jb-zsh-debug "[USER DEBUG]: 	Setting \"Joaquin6\" git configs"

		git config --local --unset user.name
		git config --global user.name joaquin6
		git config --local user.name joaquin6
		git config --local --unset user.email
		git config --global user.email joaquinbriceno1@gmail.com
		git config --local user.email joaquinbriceno1@gmail.com
	fi
}
load-nvmrc() {
  load-user-specifics

  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc

autoload -U add-zsh-hook promptinit; promptinit
prompt spaceship
