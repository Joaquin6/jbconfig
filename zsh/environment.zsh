# -------------------------------
# CONFIGURATION VARIABLES
# -------------------------------

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PYTHON_VERSION=Current
export RUBY_VERSION="2.5.1p57"
export RBENV_VERSION="1.1.1"
export HOME_LIB_PATH=$HOME/Library
export SYS_LIB_PATH=/System/Library
export SYS_FRWKS_PATH=$SYS_LIB_PATH/Frameworks
export USER_BIN=/usr/bin
export USER_LOCAL=/usr/local
export USER_SHARE=/usr/share
export USER_LOCAL_GO=$USER_LOCAL/go
export USER_LOCAL_BIN=$USER_LOCAL/bin
export USER_LOCAL_ETC=$USER_LOCAL/etc
export USER_LOCAL_LIB=$USER_LOCAL/lib
export USER_LOCAL_OPT=$USER_LOCAL/opt
export USER_LOCAL_MAN=$USER_LOCAL/man
export USER_LOCAL_SHARE=$USER_LOCAL/share
export USER_LOCAL_FRWKS=$USER_LOCAL/Frameworks

export TERM="xterm-256color"
export ARCHFLAGS="-arch x86_64"
export LDFLAGS=(-L$USER_LOCAL_OPT/{gettext,icu4c,libarchive,openssl,readline}/lib)
export CPPFLAGS=(-I$USER_LOCAL_OPT/{gettext,icu4c,libarchive,openssl,readline}/include)
export MANPATH="/usr/local/man:$MANPATH"
export XDG_CONFIG_HOME=$HOME/.config
export DOCKER_ETC_CONTENTS=/Applications/Docker.app/Contents/Resources/etc

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

export HISTCONTROL=erasedups
export HISTFILE=~/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
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
export GOPATH=$HOME/projects/go
export MONO_GAC_PREFIX=$USER_LOCAL
export GROOVY_HOME=$USER_LOCAL_OPT/groovy/libexec
export ANTIGEN_BUNDLES=$HOME/.antigen/bundles
export JB_ZSH_BASE=$HOME/.jbconfig
export WORKON_HOME=$HOME/.virtualenvs
export XDG_DATA_DIRS=$USER_LOCAL_SHARE
export PERL_LOCAL_LIB_ROOT=$HOME/perl5
export PERL5LIB=$PERL_LOCAL_LIB_ROOT/lib/perl5

export ZSH=$HOME/.oh-my-zsh
export ZSHA_BASE=$HOME/.antigen
export ZSH_CUSTOM=$ZSH/custom
export ZSH_THEME="spaceship"
# export ZSH_THEME="powerlevel9k/powerlevel9k"
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
export ADOTDIR=$ZSHA_BASE
export GCLOUD_SDK_PATH=$USER_LOCAL_SHARE/google-cloud-sdk

export POWERLEVEL9K_MODE='nerdfont-complete'
export POWERLEVEL9K_INSTALLATION_PATH=$ZSH_CUSTOM/themes
export POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S \uE868  %d.%m.%y}"
export POWERLEVEL9K_PROMPT_ON_NEWLINE=true
export POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
export POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
export POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "

export KRAKEN_REMOTE_DEV=dev.kraken.com
export KRAKEN_REMOTE_DEV_HOME=/home/jbriceno
export NPM_TOKEN=QPASt_5h44AzSHrg4gNv

export AUTOENV_DEBUG=0
export JB_ZSH_DEBUG=1

# Paths
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path
# Set the list of directories that cd searches.
export cdpath=(
  $cdpath
)
# Set the list of directories that Zsh searches for programs.
export path=(
  /usr/local/{bin,sbin}
  $path
)
export fpath=(
	$HOME/.config/completion
	$USER_LOCAL_ETC/bash_completion.d
	$USER_LOCAL_SHARE/zsh-completions
	$USER_LOCAL_SHARE/zsh/site-functions
	$fpath
)