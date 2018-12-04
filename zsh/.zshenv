#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

export USER_BIN=/usr/bin
export USER_LOCAL=/usr/local
export USER_SHARE=/usr/share
export JB_ZSH_BASE=$HOME/jbconfig
export HOME_LIB_PATH=$HOME/Library
export SYS_LIB_PATH=/System/Library

export JB_ZSH_DEBUG=1
export AUTOENV_DEBUG=0

export JB_ZSH_BASE=$HOME/jbconfig
export HOME_LIB_PATH=$HOME/Library
export USER_LOCAL_GO=$USER_LOCAL/go
export USER_LOCAL_BIN=$USER_LOCAL/bin
export USER_LOCAL_ETC=$USER_LOCAL/etc
export USER_LOCAL_LIB=$USER_LOCAL/lib
export USER_LOCAL_OPT=$USER_LOCAL/opt
export USER_LOCAL_MAN=$USER_LOCAL/man
export USER_LOCAL_SHARE=$USER_LOCAL/share
export SYS_FRWKS_PATH=$SYS_LIB_PATH/Frameworks
export USER_LOCAL_FRWKS=$USER_LOCAL/Frameworks
export MANPATH=$USER_LOCAL_MAN

export RBENV_SHELL=zsh
export NVM_DIR=$HOME/.nvm
export PYTHON_VERSION="2.7"
export RBENV_ROOT=$HOME/.rbenv
export GOPATH=$HOME/projects/go
export RUBY_VERSION="2.5.3p105"
export RBENV_VERSION="rbx-3.105"
export RBENV_DIR=$RBENV_ROOT/bin
export MONO_GAC_PREFIX=$USER_LOCAL
export XDG_CONFIG_HOME=$HOME/.config
export WORKON_HOME=$HOME/.virtualenvs
export GCLOUD_SDK_PATH=$USER_LOCAL_SHARE/google-cloud-sdk

export TERM="xterm-256color"
export ARCHFLAGS="-arch x86_64"
export LDFLAGS=(-L$USER_LOCAL_OPT/{gettext,icu4c,libarchive,openssl,readline}/lib)
export CPPFLAGS=(-I$USER_LOCAL_OPT/{gettext,icu4c,libarchive,openssl,readline}/include)
export DEFAULT_MACHINE="default"
export DOCKER_ETC_CONTENTS=/Applications/Docker.app/Contents/Resources/etc
export OOO_FORCE_DESKTOP=gnome

export SSH_PATH=$HOME/.ssh
export SSH_ENV=$SSH_PATH/environment
export SSH_PRIVATE_KEY=$SSH_PATH/id_rsa
export SSH_KEY_PATH=$SSH_PRIVATE_KEY
export SSH_KNOWN_HOSTS=$SSH_PATH/known_hosts

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.histfile
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

export GROOVY_HOME=$USER_LOCAL_OPT/groovy/libexec
export XDG_DATA_DIRS=$USER_LOCAL_SHARE

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
