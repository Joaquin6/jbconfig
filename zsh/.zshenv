#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

export JB_ZSH_DEBUG=1
export AUTOENV_DEBUG=0
export YARN_VERSION=1.16.0
export JB_ZSH_AUTHOR=joaquin

export OPT_PATH=/opt
export USER_BIN=/usr/bin
export USER_LOCAL=/usr/local
export USER_SHARE=/usr/share
export USER_LIBEXEC=/usr/libexec
export JB_ZSH_BASE=$HOME/jbconfig
export HOME_LIB_PATH=$HOME/Library
export SYS_LIB_PATH=/System/Library
export LINUXBREW_PATH=/home/linuxbrew/.linuxbrew

export USER_LOCAL_GO=$USER_LOCAL/go
export USER_LOCAL_BIN=$USER_LOCAL/bin
export USER_LOCAL_ETC=$USER_LOCAL/etc
export USER_LOCAL_LIB=$USER_LOCAL/lib
export USER_LOCAL_OPT=$USER_LOCAL/opt
export USER_LOCAL_MAN=$USER_LOCAL/man
export USER_LOCAL_SHARE=$USER_LOCAL/share
export SYS_FRWKS_PATH=$SYS_LIB_PATH/Frameworks
export USER_LOCAL_FRWKS=$USER_LOCAL/Frameworks

export LINUXBREW_LOCAL_GO=$LINUXBREW_PATH/go
export LINUXBREW_LOCAL_BIN=$LINUXBREW_PATH/bin
export LINUXBREW_LOCAL_ETC=$LINUXBREW_PATH/etc
export LINUXBREW_LOCAL_LIB=$LINUXBREW_PATH/lib
export LINUXBREW_LOCAL_OPT=$LINUXBREW_PATH/opt
export LINUXBREW_LOCAL_MAN=$LINUXBREW_PATH/man
export LINUXBREW_LOCAL_SHARE=$LINUXBREW_PATH/share

export PROJECTS=$HOME/projects
export GITHUBPATH=$PROJECTS/github.com
export GIT_USERNAME=Joaquin6
export GIT_USER_PATH=$GITHUBPATH/$GIT_USERNAME
export ANTIGEN_USER_PATH=$GIT_USER_PATH/antigen

export SHELL=/bin/zsh
export RBENV_SHELL=$SHELL
export NVM_DIR=$HOME/.nvm
export MANPATH=$USER_LOCAL_MAN
export RBENV_ROOT=$HOME/.rbenv
export SDKMAN_DIR=$HOME/.sdkman
export GOPATH=$HOME/projects/go
export RBENV_DIR=$RBENV_ROOT/bin
export MONO_PREFIX=$OPT_PATH/mono
export MONO_GAC_PREFIX=/usr/local
export GNOME_PREFIX=$OPT_PATH/gnome
export XDG_CONFIG_HOME=$HOME/.config
export WORKON_HOME=$HOME/.virtualenvs
export XDG_DATA_DIRS=$USER_LOCAL_SHARE
export XDG_DATA_HOME=$HOME/.local/share
export JAVA_HOME=$USER_LIBEXEC/java_home
export GCLOUD_SDK_PATH=$USER_LOCAL_SHARE/google-cloud-sdk
export PKG_CONFIG_PATH="/Library/Frameworks/Mono.framework/Versions/Current/lib/pkgconfig/"
export ACLOCAL_FLAGS="-I /Library/Frameworks/Mono.framework/Versions/Current/share/aclocal"
export DYLD_FALLBACK_LIBRARY_PATH="/Library/Frameworks/Mono.framework/Versions/Current/lib:/lib:/usr/lib"
export LD_LIBRARY_PATH=$MONO_PREFIX/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$MONO_PREFIX/include:$GNOME_PREFIX/include
export PKG_CONFIG_PATH=$MONO_PREFIX/lib/pkgconfig:$GNOME_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

export TERM="xterm-256color"
export ARCHFLAGS="-arch x86_64"
export LDFLAGS=(-L$USER_LOCAL_OPT/{m4,binutils,diffutils,gettext,icu4c,libarchive,libpq,libffi,openssl,curl-openssl,openldap,readline,portable-readline,coreutils}/lib)
export CPPFLAGS=(-I$USER_LOCAL_OPT/{m4,binutils,diffutils,gettext,icu4c,libarchive,libpq,libffi,openssl,curl-openssl,openldap,readline,portable-readline,coreutils}/include)
export OOO_FORCE_DESKTOP=gnome
if type brew &>/dev/null; then
	export HOMEBREW_PREFIX=$(brew --prefix)
  if [[ $OSTYPE == darwin* ]]; then
	  export CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
  else
    export CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include"
  fi
fi

if [ -d $LINUXBREW_PATH ]; then
  export LDFLAGS=(-L$LINUXBREW_LOCAL_OPT/{m4,gettext,icu4c,libarchive,libpq,libffi,openssl,curl-openssl,openldap,readline,portable-readline,coreutils}/lib $LDFLAGS)
  export CPPFLAGS=(-I$LINUXBREW_LOCAL_OPT/{m4,gettext,icu4c,libarchive,libpq,libffi,openssl,curl-openssl,openldap,readline,portable-readline,coreutils}/include $CPPFLAGS)
  export XDG_DATA_DIRS=$LINUXBREW_PATH/share:$XDG_DATA_DIRS
fi

export SSH_PATH=$HOME/.ssh
export SSH_ENV=$SSH_PATH/environment
export SSH_PRIVATE_KEY=$SSH_PATH/id_rsa
export SSH_KEY_PATH=$SSH_PRIVATE_KEY
export SSH_KNOWN_HOSTS=$SSH_PATH/known_hosts

export AWS_CONFIG_FILE=$HOME/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=$HOME/.aws/credentials
export AWS_DEFAULT_PROFILE=$JB_ZSH_AUTHOR
if type aws &>/dev/null; then
	export POLICYARN=$(aws iam list-policies --query 'Policies[?PolicyName==`PowerUserAccess`].{ARN:Arn}' --output text)
fi

export HISTSIZE=10000
export SAVEHIST=10000
export HISTCONTROL=erasedups
export HISTFILE=$HOME/.histfile
export BOOKMARKS_FILE=$HOME/.bookmarks
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

if [ -d $HOME/.antigen ]; then
  export ADOTDIR=$HOME/.antigen
fi

export GROOVY_HOME=$USER_LOCAL_OPT/groovy/libexec
export COMPLETION_WAITING_DOTS="true"
export ITERM2_SQUELCH_MARK=1

[[ -s $HOME/.ghcup/env ]] && source $HOME/.ghcup/env

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "$HOME/.zprofile" ]]; then
  source "$HOME/.zprofile"
fi
