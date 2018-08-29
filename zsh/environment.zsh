# -------------------------------
# CONFIGURATION VARIABLES
# -------------------------------

export SYS_LIB_PATH=/System/Library
export SYS_FRWKS_PATH=$SYS_LIB_PATH/Frameworks
export USER_BIN=/usr/bin
export USER_LOCAL=/usr/local
export USER_LOCAL_GO=$USER_LOCAL/go
export USER_LOCAL_BIN=$USER_LOCAL/bin
export USER_LOCAL_LIB=$USER_LOCAL/lib
export USER_LOCAL_OPT=$USER_LOCAL/opt
export USER_LOCAL_MAN=$USER_LOCAL/man
export USER_LOCAL_SHARE=$USER_LOCAL/share
export USER_LOCAL_FRWKS=$USER_LOCAL/Frameworks
export USER_BIN_PATH=/bin:/sbin:/usr/sbin:$USER_BIN:$USER_LOCAL_BIN
export XDG_CONFIG_HOME=$HOME/.config
# export XDG_CONFIG_HOME=$HOME/.config/fontconfig/fonts.conf
export DOCKER_ETC_CONTENTS=/Applications/Docker.app/Contents/Resources/etc

export PYTHON_VERSION=Current
export RUBY_VERSION="2.5.1p57"
export RBENV_VERSION="1.1.1"

export PAGER='less'
export VISUAL='nano'
export EDITOR='nano'

export LANG=en_US.UTF-8
export GROOVY_HOME=$USER_LOCAL_OPT/groovy/libexec
export NPM_TOKEN=QPASt_5h44AzSHrg4gNv
export ANTIGEN_BUNDLES=$HOME/.antigen/bundles
export JB_ZSH_BASE=$HOME/.jbconfig
export WORKON_HOME=$HOME/.virtualenvs
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
export XDG_DATA_DIRS=$USER_LOCAL_SHARE
export PERL_LOCAL_LIB_ROOT=$HOME/perl5
export PERL5LIB=$PERL_LOCAL_LIB_ROOT/lib/perl5
export LDFLAGS=(-L$USER_LOCAL_OPT/{gettext,icu4c,libarchive,openssl,readline}/lib)
export CPPFLAGS=(-I$USER_LOCAL_OPT/{gettext,icu4c,libarchive,openssl,readline}/include)

export BROWSER=open
export SSH_PATH=$HOME/.ssh
export SSH_ENV=$SSH_PATH/environment
export SSH_PRIVATE_KEY=$SSH_PATH/id_rsa
export SSH_KEY_PATH=$SSH_PRIVATE_KEY
export SSH_KNOWN_HOSTS=$SSH_PATH/known_hosts

export KRAKEN_REMOTE_DEV=dev.kraken.com
export KRAKEN_REMOTE_DEV_HOME=/home/jbriceno

export ARCHFLAGS="-arch x86_64"
export GOPATH=$HOME/projects/go
export MONO_GAC_PREFIX=$USER_LOCAL
export NVM_DIR=$HOME/.nvm
export NVM_AUTO_USE=true

export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom
export ZSH_THEME=spaceship
export ZSHA_BASE=$HOME/.antigen
export ADOTDIR=$ZSHA_BASE
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "
export POWERLEVEL9K_INSTALLATION_PATH=$ZSH_CUSTOM/themes
export POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S \uE868  %d.%m.%y}"
export POWERLEVEL9K_PROMPT_ON_NEWLINE=true
export POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
export POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
export POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "

export AUTOENV_DEBUG=0
export JB_ZSH_DEBUG=1