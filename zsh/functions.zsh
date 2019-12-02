####################################################################################################
############################################ FUNCTIONS #############################################
####################################################################################################

# Set JB_ZSH_BASE if it isn't already defined
[[ -z $JB_ZSH_BASE ]] && export JB_ZSH_BASE=~/jbconfig
[[ -z $DEFAULT_MACHINE ]] && export DEFAULT_MACHINE="default"


############################################# private ##############################################
# Set debug level. If enabled (> 0) it will print information to stderr.
# 	0: no debug messages (Default)
# 	1: generic debug logging
# 	2: more verbose messages
# 		messages about adding/removing files on the internal stack
# 	3: everything
# 		sets xtrace option (set -x) while sourcing env files
function -jb-zsh-debug() {
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
function -handle-add-path() {
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
		-jb-zsh-debug "[PATH DEBUG]: 	$incoming_path doesn't exist. Not adding to PATH"
	fi
}
function -handle-add-manpath() {
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
		-jb-zsh-debug "[MANPATH DEBUG]: 	$incoming_path doesn't exist. Not adding to MANPATH"
	fi
}
function -handle-add-infopath() {
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
		-jb-zsh-debug "[INFOPATH DEBUG]: 	$incoming_path doesn't exist. Not adding to INFOPATH"
	fi
}
function -handle-add-pkgconfigpath() {
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
		-jb-zsh-debug "[PKG_CONFIG_PATH DEBUG]: 	$incoming_path doesn't exist."
		# Check if brew is a command. If so, suggest installing with brew
		if which brew &> /dev/null; then
			-jb-zsh-debug "[PKG_CONFIG_PATH DEBUG]: 	Suggestion => \"brew install $1\"" 2
		fi
	fi
}
function -load-nvmrc() {
  if which nvm &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --delete-prefix
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use --delete-prefix default
    fi
    -handle-add-path "$NVM_DIR/versions/node/v10.11.0/bin"
  else
    -jb-zsh-debug "[LOAD NVMRC DEBUG]: 	Can not find nvm command."
  fi

}
function -load-syntax-highlighting() {
	local plugins=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
	local syntax_highlighting=${ANTIGEN_BUNDLES:-~/.antigen/bundles}/zsh-users/zsh-syntax-highlighting
	local highlighter_repo=git@github.com:zsh-users/zsh-syntax-highlighting.git

	if [ ! -d $plugins/zsh-syntax-highlighting ]; then
		-jb-zsh-debug "[LOAD SYNTAX HIGHLIGHTING DEBUG]: 	creating $plugins/zsh-syntax-highlighting"
		mkdir -p $plugins/zsh-syntax-highlighting
		-jb-zsh-debug "[LOAD SYNTAX HIGHLIGHTING DEBUG]: 	$plugins/zsh-syntax-highlighting created."

		-jb-zsh-debug "[LOAD SYNTAX HIGHLIGHTING DEBUG]: 	cloning $highlighter_repo into $plugins/zsh-syntax-highlighting" 2
		git clone $highlighter_repo $plugins/zsh-syntax-highlighting
		-jb-zsh-debug "[LOAD SYNTAX HIGHLIGHTING DEBUG]: 	$highlighter_repo was cloned successfully" 2
	fi
}
function -load-url-highlighter() {
	local plugins=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
	local syntax_highlighting=${ANTIGEN_BUNDLES:-~/.antigen/bundles}/zsh-users/zsh-syntax-highlighting
	local highlighter_repo=git@github.com:ascii-soup/zsh-url-highlighter.git

	if [ ! -d $plugins/zsh-url-highlighter ]; then
		-jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	creating $plugins/zsh-url-highlighter"
		mkdir -p $plugins/zsh-url-highlighter
		-jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	$plugins/zsh-url-highlighter created."

		-jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	cloning $highlighter_repo into $plugins/zsh-url-highlighter" 2
		git clone $highlighter_repo $plugins/zsh-url-highlighter
		-jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	$highlighter_repo was cloned successfully" 2
	fi

  if [ ! -L $syntax_highlighting/highlighters/url ]; then
	  -jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	linking $plugins/zsh-url-highlighter/url to $syntax_highlighting/highlighters/url" 2
	  ln -s $plugins/zsh-url-highlighter/url $syntax_highlighting/highlighters
	  -jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	$plugins/zsh-url-highlighter/url to $syntax_highlighting/highlighters/url linked successfully" 2
  fi
}
function -load-mgdm-theme() {
	local themes=$JB_ZSH_BASE/zsh/themes
	local mgdm_theme=$themes/mgdm.zsh-theme
	local destination=$ZSH_CUSTOM/themes

	if [ ! -d $destination ]; then
		-jb-zsh-debug "[LOAD MGDM THEME DEBUG]: 	creating $destination" 2
		mkdir -p $destination
		-jb-zsh-debug "[LOAD MGDM THEME DEBUG]: 	$destination created." 2
	fi

	if [ ! -f $destination/mgdm.zsh-theme ]; then
		-jb-zsh-debug "[LOAD MGDM THEME DEBUG]: 	copying $mgdm_theme to $destination/mgdm.zsh-theme" 2
		cp $mgdm_theme $destination/mgdm.zsh-theme
		-jb-zsh-debug "[LOAD MGDM THEME DEBUG]: 	copied $mgdm_theme to $destination/mgdm.zsh-theme successfully" 2
	fi
}

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


#   ---------------------------
#   6. SEARCHING
#   ---------------------------

ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

# To get the directory utilitization size of the current directory:
directory-utilitization-size () {
	local DIRSIZE=${1:-$PWD}
	du -sh $DIRSIZE ; 
}

# Count the number files in the folder by piping to the “word count” utility:
# (The -al includes hidden files and folders)
count-files () {
	local DIRCOUNT=${1:-$PWD}
	ls -al $DIRCOUNT | wc -l ;
}
# (The find . includes files nested within folders as well)
count-files-nested () {
	local DIRCOUNT=${1:-$PWD}
	find $DIRCOUNT -print | wc -l ;
}

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
terminate(){
  lsof -P | grep ':$1' | awk '{print $2}' | xargs kill -9 
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
antigen-reload () { 
	emulate -L zsh
	eval antigen reset && reload
}
#   nyg: shortcut to globally install pkgs with npm AND yarn
#   ------------------------------------------------------------
nyg () { npm install --global "$1" && yarn global add "$1" ; }
nygAll () {
	while IFS='' read -r line || [[ -n "$line" ]]; do
	    echo "\tInstalling Globally:\t$line"
	    nyg $line
	done < ~/.nvm/default-packages
}
npm-reinstall () { npm uninstall "$1" && npm install "$@"; }
yarn-reinstall () { yarn remove "$1" && yarn add "$@" ; }
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

# Create a folder and move into it in one command
mkcd() { mkdir -p "$@" && cd "$@"; }


# https://stackoverflow.com/questions/18936337/makefile1-missing-separator-stop/18936393
fix_space_tabs () { perl -pi -e 's/^  */\t/' "$1"; }

#   ---------------------------------------
#   8. PERMISSIONS
#   ---------------------------------------
show_all_users() { cut -d ":" -f 1 /etc/passwd ; }
permitme() {
	local PERMITTING_DIR=${1:-$PWD}
	sudo chown -hR $(whoami) $PERMITTING_DIR;
	sudo chmod u+w $PERMITTING_DIR;
	sudo chmod go-w $PERMITTING_DIR;
}
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

bbget () {
    USER=$(echo $@ | tr "/" " " | awk '{print $1}')
    REPO=$(echo $@ | tr "/" " " | awk '{print $2}')

    mkdir -p ~/projects/bitbucket.org/$USER && cd ~/projects/bitbucket.org/$USER
    git clone https://bitbucket.org/$USER/$REPO.git && cd $REPO
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

upgradejb-zsh() {
  emulate -L zsh
  upgrade_oh_my_zsh
  eval antigen selfupdate && eval antigen update
}

upgradejb-zsh-reload () { upgradejb-zsh && reload; }

git-submodule-rm-clean () {
  git submodule deinit $1 & wait
  git rm $1 & wait
  git commit -m "Removed submodule" && rm -rf .git/modules/$1
}



########################################## docker-machine ##########################################
function docker-up() {
    if [ -z "$1" ]
    then
        docker-machine start "${DEFAULT_MACHINE}"
        eval $(docker-machine env "${DEFAULT_MACHINE}")
    else
        docker-machine start $1
        eval $(docker-machine env $1)
    fi
    echo $DOCKER_HOST
}
function docker-stop() {
    if [ -z "$1" ]
    then
        docker-machine stop "${DEFAULT_MACHINE}"
    else
        docker-machine stop $1
    fi
}
function docker-switch() {
    eval $(docker-machine env $1)
    echo $DOCKER_HOST
}
function docker-vm() {
    if [ -z "$1" ]
    then
        docker-machine create -d virtualbox --virtualbox-disk-size 20000 --virtualbox-memory 4096 --virtualbox-cpu-count 2 "${DEFAULT_MACHINE}"
    else
        docker-machine create -d virtualbox --virtualbox-disk-size 20000 --virtualbox-memory 4096 --virtualbox-cpu-count 2 $1
    fi
}



############################################# iwhois ###############################################
# provide a whois command with a more accurate and up to date list of whois
# servers using CNAMES via whois.geek.nz
function iwhois() {
    resolver="whois.geek.nz"
    tld=`echo ${@: -1} | awk -F "." '{print $NF}'`
    whois -h ${tld}.${resolver} "$@" ;
}



function reload () { exec $SHELL -l ; }

function unzip-from-link() {
	local download_link=$1; shift || return 1
	local temporary_dir

	temporary_dir=$(mktemp -d) \
		&& curl -LO "${download_link:-}" \
		&& unzip -d "$temporary_dir" \*.zip \
		&& rm -rf \*.zip \
		&& mv "$temporary_dir"/* ${1:-"$HOME/Downloads"} \
		&& rm -rf $temporary_dir
}

#   nyg: shortcut to globally install pkgs with npm AND yarn
#   ------------------------------------------------------------
function yarn_reinstall () { sudo yarn remove "$1" && sudo yarn add "$1" ; }
function yarn_reinstall_latest () { sudo yarn remove "$1" && sudo yarn add "$1@latest" ; }
function yarn_reinstall_latest_exact () { sudo yarn remove "$1" && sudo yarn add "$1@latest" --exact ; }
function yarn_reinstall_latest_exact_dev () { sudo yarn remove "$1" && sudo yarn add "$1@latest" --exact --dev ; }

function encodeBase64 () {
	local registry_username="$1"
	local registry_password="$2"

	echo -n "${registry_username}:${registry_password}" | base64
}

#   ---------------------------
#   5. PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
function find-pid () { lsof -t -c "$@" ; }
#   listening-on-port: List processes listening on the provided port
#   ------------------------------------------------------------
function listening-on-port() { lsof -i "tcp:$1" ; }

# Remove workspace auto-switching by running the following command
function workspaceAutoswitch() { defaults write com.apple.dock workspaces-auto-swoosh -bool YES ; }
function noWorkspaceAutoswitch() { defaults write com.apple.dock workspaces-auto-swoosh -bool NO ; }

#   ---------------------------
#   -- PERMISSIONS
#   ---------------------------
function show_all_users() { cut -d ":" -f 1 /etc/passwd ; }

# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs() {
  local section=${1:-all}
  open_command "https://nodejs.org/docs/$(node --version)/api/$section.html"
}

function my-ip() {
 	ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
	ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

add_auth_key () {
  ssh-copy-id $@
}

# dict is a small utility which I used when cheating at IRC games.
# The game was effectively "guess the word" using more or less binary search on a word space.
# Once you got it down to something like "Wah - Water" and you had to guess all the words in
# between there, it got really difficult. If no one could guess the right word,
# I'd do a search for something like dict ^wa and try those words which occurred between the two.

# This is a perfect example of when you want to use a function instead of an alias.
# If this were an alias, we couldn't insert the term before the file name.
# The $@ syntax means "Take the arguments that were passed to this function and put them here."
dict() {
    grep "$@" $USER_SHARE/dict/words
}

# dls will list directories instead of files in the current working directory.
dls () {
 # directory LS
 echo `ls -l | grep "^d" | awk '{ print $9 }' | tr -d "/"`
}

# dgrep will grep everything under the current directory and dfgrep does the same as dgrep save
# that it filters out to only have unique filenames.
dgrep() {
    # A recursive, case-insensitive grep that excludes binary files
    grep -iR "$@" * | grep -v "Binary"
}
dfgrep() {
    # A recursive, case-insensitive grep that excludes binary files
    # and returns only unique filenames
    grep -iR "$@" * | grep -v "Binary" | sed 's/:/ /g' | awk '{ print $1 }' | sort | uniq
}
# To complete the grep triad, I have psgrep which is similar to pgrep in that it is a process grep.
# Unlike pgrep, it shows the entire line of ps rather than just the PID.
psgrep() {
    if [ ! -z $1 ] ; then
        echo "Grepping for processes matching $1..."
        ps aux | grep $1 | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
}

# When I used to run a local copy of postgres, it would occasionally get into a weird state
# where killing it was the only way to proceed. Unfortunately, there were 5-10 postgres processes
# and I could never remember which was the correct one to kill. This function will basically let
# you kill all processes that match a regex. Very handy for "postgres" or "java".
killit() {
    # Kills any process that matches a regexp passed to it
    ps aux | grep -v "grep" | grep "$@" | awk '{print $2}' | xargs sudo kill
}

# If this computer doesn't have an implementation of tree, then let's make a simple one with find and sed.
# Tree basically outputs a directory layout in a tree form.
if [ -z "\${which tree}" ]; then
  tree () {
      find $@ -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
  }
fi

# If you need to kill a process on a particular port, but you don't know the process, portslay handles that.
portslay () {
    kill -9 `lsof -i tcp:$1 | tail -1 | awk '{ print $2;}'`
}

# I download a bunch of github repos. I put them in $HOME/projects/github.com/github_user/project_name. This makes that a bit easier.
ghget () {
    # input: rails/rails
    USER=$(echo $@ | tr "/" " " | awk '{print $1}')
    REPO=$(echo $@ | tr "/" " " | awk '{print $2}')
    mkcd "$HOME/projects/github.com/$USER" && \
    hub clone $@ && \
    cd $REPO
}

# A few debugging tools for IP addresses.
# exip will list your external IP (as determined from myip.dk) and
# ips will list what your NIC things your IP addresses are.
exip () {
    # gather external ip address
    echo -n "Current External IP: "
    curl -s -m 5 http://myip.dk | grep "ha4" | sed -e 's/.*ha4">//g' -e 's/<\/span>.*//g'
}

ips () {
    # determine local IP address
    ifconfig | grep "inet " | awk '{ print $2 }'
}

# The parse_git_branch and parse_svn_rev functions are used primarily for bash prompt use,
# so I can display interesting information whenever I'm in a directory that supports it.
parse_git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1] /';
}

parse_svn_rev(){
    svn info 2> /dev/null | grep "Revision" | sed 's/Revision: \(.*\)/[r\1] /';
}

update_git_dirs() {
    # so what the below does is finds all files named .git in my home
    # directory, but excludes the .virtualenvs folder then strips the .git from
    # the end, cd's into the directory, pulls from the origin master, then
    # repeats

    OLD_DIR=`pwd`
    cd ~
    for i in `find . -type d -name ".virtualenvs" -prune -o -name ".git" | sed 's/\.git//'`; do
        echo "Going into $i"
        cd $i
        git pull origin master
        cd ~
    done
    cd $OLD_DIR
}

# Its surprisingly hard to figure out what shell you're currently in, so the shell command will
# tell you. Note that the environment variable SHELL will tell you what you started in, but if you change it it doesn't update.
shell () {
  ps | grep `echo $$` | awk '{ print $4 }'
}

# unegg and unpatch basically clean up crufty files.
# unegg will take a .egg file (which is actually a zip archive) and make it a directory.
# This will still be loadable by python. unpatch will clean up after some failed patches
# (for instance, when you get the wrong patch level when applying a diff) by recursing through the
# current directory removing any .orig or .rej files, as well as any directories named b.
unegg () {
    unzip $1 -d tmp
    rm $1
    mv tmp $1
}

unpatch () {
  find . -name "*.orig" -o -name "*.rej"  -type f -exec rm {} \;
  find . -name "b" -type d -exec rm -rf {} \;
}

# So, I play counterstrike on my linux laptop. The gamma isn't set correctly for the game due to
# some issues in Steam v1. This script will update the gamma for the laptop to be at playable levels.
set_gamma () {
  xrandr --output eDP1 --gamma $1:$1:$1
}

cs_on() {
  set_gamma 1.7
}

cs_off()  {
  set_gamma 1.0
}

confirm_existence()
{
    if [[ -d $1 ]] && [[ -n $1 ]] ; then
        echo "\t\tDeleting Directory $1"
        return 0
    fi

    if [[ -f $1 ]] && [[ -n $1 ]] ; then
        echo "\t\tDeleting File $1"
        return 0
    fi

    return 1
}

trash()
{
    if confirm_existence $1; then
        if which rimraf &> /dev/null; then
            rimraf $1 -s
        else
            rm -rf $1
        fi
        echo "\n\t\tSuccessfully Trashed $1"
    fi
    echo
}

set-aws-profile()
{
	export AWS_PROFILE="$1"
	export AWS_DEFAULT_PROFILE="$1"

	aws configure --profile "$1"
}

gi() { curl -sLw "\n" https://www.gitignore.io/api/\$@ ; }

dotnet-refresh()
{
	if command_exists dotnet; then
		dotnet clean $1 && rm -rf ./{*,**}/{obj,bin} && dotnet restore $1 && dotnet build $1
	else
		jb-zsh-debug "Command 'dotnet' is not installed!"
	fi
}
