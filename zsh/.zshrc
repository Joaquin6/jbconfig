
#   CONFIGURATION VARIABLES
#   -------------------------------

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
export DEFAULT_MACHINE="default"
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



alias zshversion='echo ${ZSH_PATCHLEVEL}'
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias ohmyzshconfig="$EDITOR ~/.oh-my-zsh"

zshrc() {
	local editor=${EDITOR:-code}

	if [ -f "$JB_ZSH_BASE/zsh/base" ]; then
		$editor $JB_ZSH_BASE/zsh/base
	elif [ -f "$HOME/.zshrc" ]; then
		$editor $HOME/.zshrc
	else
		echo "\n\tCant find an zshrc file!"
	fi
}


#   -----------------------------
#   2. MAKE TERMINAL BETTER
#   -----------------------------

# Detect which `ls` flavor is in use.
# List all files colorized in long format, including dot files
if ls --color > /dev/null 2>&1; then
  colorflag="--color" # GNU `ls`
else
  colorflag="-G"      # OS X `ls`
fi

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh --color=always --group-directories-first'
alias la='ls -lAFh ${colorflag}'
alias lr='ls -tRFh'
alias lt='ls -ltFh'
alias ll='ls -l'
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias lh='ls -a | egrep "^\."'
alias llgf='ls -GFlAhp'
alias lla='ls -la'
alias lsg='ls -GFh'
alias lrtg='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias filecount='ls -aRF | wc -l'
alias sl=ls
############################################ colorls ###############################################
#	-------------------------------
#	COLORLS DOCUMENTATION
#	-------------------------------
# https://github.com/athityakumar/colorls
alias lsc='colorls'
alias lc='colorls -lA --sd'

alias ~="cd ~"                          # Go Home
alias cd..='cd ../'               		# Go back 1 directory level
alias ..='cd ../'                       # Go back 1 directory level
alias ...='cd ../../'                   # Go back 2 directory levels
alias .3='cd ../../../'                 # Go back 3 directory levels
alias .4='cd ../../../../'              # Go back 4 directory levels
alias .5='cd ../../../../../'           # Go back 5 directory levels
alias .6='cd ../../../../../../'        # Go back 6 directory levels
cd() { builtin cd "$@"; ls -l; }        # Always list directory contents upon 'cd'

alias edit='code'		                # edit:     Opens any file in vscode
alias c='clear'                               # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'           # path:         Echo all executable Paths
alias show_options='shopt'                    # Show_options: display bash options settings
alias fix_stty='stty sane'                    # fix_stty:     Restore terminal settings when screwed up
mkcd() { mkdir -p "$@" && cd "$@"; }          # mkcd:          Makes new Dir and jumps inside
alias UN='echo $USER'

alias vsc='code .'
alias vscl='code --log'
alias vsca='code --add'
alias vscd='code --diff'
alias vscg='code --goto'
alias vscw='code --wait'
alias vscv='code --verbose'
alias vscn='code --new-window'
alias vscr='code --reuse-window'
alias vscu='code --user-data-dir'
alias vscext='code --extensions-dir'
alias vscexti='code --install-extension'
alias vscextd='code --disable-extensions'
alias vscextu='code --uninstall-extension'




#   ---------------------------
#   4. NETWORKING
#   ---------------------------
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs


############################################# docker ###############################################
alias docker-clean-unused='docker system prune --all --force --volumes'
alias docker-clean-all='docker stop $(docker container ls -a -q) && docker system prune -a -f --volumes'
alias docker-clean-containers='docker container stop $(docker container ls -a -q) && docker container rm $(docker container ls -a -q)'

drm() { docker rm $(docker ps -a | grep $1 | awk '{print $1}') ; }
# docker rm $(docker ps -a | grep "46 hours ago")
drmt() { docker rm $(docker ps -a | grep "$1") ; }

######################################### docker-compose ###########################################
# Docker-compose related zsh aliases
# Use dco as alias for docker-compose, since dc on *nix is 'dc - an arbitrary precision calculator'
# https://www.gnu.org/software/bc/manual/dc-1.05/html_mono/dc.html
alias dco='docker-compose'
alias dcps='docker-compose ps'
alias dcrm='docker-compose rm'
alias dcr='docker-compose run'
alias dcup='docker-compose up'
alias dcl='docker-compose logs'
alias dce='docker-compose exec'
alias dcb='docker-compose build'
alias dcdn='docker-compose down'
alias dcpull='docker-compose pull'
alias dcstop='docker-compose stop'
alias dclf='docker-compose logs -f'
alias dcstart='docker-compose start'
alias dcrestart='docker-compose restart'



#   ---------------------------------------
#   5. SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

#   cleanupDS:  Recursively delete .DS_Store files
# 	cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -------------------------------------------------------------------
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"
alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   enableWorkspaceAutoswitch:   	Add workspace auto-switching
#   disableWorkspaceAutoswitch:   	Remove workspace auto-switching
#   -------------------------------------------------------------------
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'
alias enableWorkspaceAutoswitch='defaults write com.apple.dock workspaces-auto-swoosh YES'
alias disableWorkspaceAutoswitch='defaults write com.apple.dock workspaces-auto-swoosh NO'


#   ---------------------------
#   6. SEARCHING
#   ---------------------------

ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string


#   ---------------------------
#   7. PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
findPid () { lsof -t -c "$@" ; }
myip() {
 	ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
	ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}
#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
my-ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }
hist() { history | grep "$@" ; }
#   extract:  Extract most known archives with one command
#   ---------------------------------------------------------
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
       esac
   else
       echo "'$1' is not a valid file"
   fi
}
#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
ii () {
	echo -e "\nYou are logged on ${RED}$HOST"
	echo -e "\nAdditionnal information:$NC " ; uname -a
	echo -e "\n${RED}Users logged on:$NC " ; w -h
	echo -e "\n${RED}Current date :$NC " ; date
	echo -e "\n${RED}Machine stats :$NC " ; uptime
	echo -e "\n${RED}Current network location :$NC " ; scselect
	echo -e "\n${RED}Public facing IP Address :$NC " ; myip
}
reload () { exec $SHELL -l ; }
#   nyg: shortcut to globally install pkgs with npm AND yarn
#   ------------------------------------------------------------
nyg () { npm install --global "$1" && yarn global add "$1" ; }
nygAll () {
	while IFS='' read -r line || [[ -n "$line" ]]; do
	    echo "\tInstalling Globally:\t$line"
	    nyg $line
	done < ~/.nvm/default-packages
}
upgrade-jb-zsh() {
	emulate -L zsh
	upgrade_oh_my_zsh
	eval antigen selfupdate && eval antigen update
}
#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
showa () { /usr/bin/grep --color=always -i -a1 "$@" $JB_ZSH_BASE/zsh/alias/*.zsh | grep -v '^\s*$' | less -FSRXc ; }
check-web-connectivity() {
	case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
	  [23]) echo "HTTP connectivity is up";;
	  5) echo "The web proxy won't let us through";;
	  *) echo "The network is down or very slow";;
	esac
}




#   ---------------------------------------
#   8. PERMISSIONS
#   ---------------------------------------
show_all_users() { cut -d ":" -f 1 /etc/passwd ; }
permitme() { pkexec chown $USER:adm $PWD -hR ; }
users_by_group() { getent group "$1" | awk -F: '{print $4}' ; }

# I download a bunch of github repos. I put them in $HOME/projects/github.com/github_user/project_name. This makes that a bit easier.
ghget () {
    # input: rails/rails
    USER=$(echo $@ | tr "/" " " | awk '{print $1}')
    REPO=$(echo $@ | tr "/" " " | awk '{print $2}')
    mkcd "$HOME/projects/github.com/$USER" && \
    hub clone $@ && \
    cd $REPO
}

jb-zsh-debug() {
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

load-user-specifics() {
	local incoming_user=${USER:-"joaquinbriceno"}
	local machine_hostname="$(hostname -f)"


	# Handle git configs
	if [[ $PWD == *"cattlebruisers"* && $machine_hostname == "ip-192-168-1-26" ]]; then
		jb-zsh-debug "[USER DEBUG]: 	Setting \"cattlebruisers\" git configs"

		git config --local --unset user.name
		git config --local user.name "Joaquin Briceno"
		git config --local --unset user.email
		git config --local user.email joaquin.briceno@insitu.com
		git config --local --unset commit.gpgsign
		git config --local commit.gpgsign false
	elif [[ $PWD != *"cattlebruisers"* && $machine_hostname == "ip-192-168-1-26" ]]; then
		jb-zsh-debug "[USER DEBUG]: 	Setting \"kraken\" git configs"

		git config --local --unset user.name
		git config --global user.name "joaquinb"
		git config --local user.name "joaquinb"
		git config --local --unset user.email
		git config --global user.email joaquinb@btcx.com
		git config --local user.email joaquinb@btcx.com
		git config --local --unset commit.gpgsign
		git config --global commit.gpgsign true
		git config --local commit.gpgsign true
	fi
}


# place this after nvm initialization!
autoload -U add-zsh-hook
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
load-nvmrc

autoload -U add-zsh-hook promptinit; promptinit
prompt spaceship