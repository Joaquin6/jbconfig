####################################################################################################
############################################ FUNCTIONS #############################################
####################################################################################################

# Set JB_ZSH_BASE if it isn't already defined
[[ -z $JB_ZSH_BASE ]] && export JB_ZSH_BASE=~/.jbconfig
[[ -z $DEFAULT_MACHINE ]] && export DEFAULT_MACHINE="default"

# source $JB_ZSH_BASE/zsh/plugins/aws.plugin.zsh
# source $JB_ZSH_BASE/zsh/plugins/jira.plugin.zsh




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
	-handle-add-path "$NVM_DIR/versions/node/$(nvm version)/bin"
}
function -load-user-specifics() {
	local incoming_user=${USER:-"joaquinbriceno"}
	local machine_hostname="$(hostname -f)"


	# Handle git configs
	if [[ $PWD == *"cattlebruisers"* && $machine_hostname == "ip-192-168-1-26" ]]; then
		-jb-zsh-debug "[USER DEBUG]: 	Setting \"cattlebruisers\" git configs"

		git config --local --unset user.name
		git config --local user.name "Joaquin Briceno"
		git config --local --unset user.email
		git config --local user.email joaquin.briceno@insitu.com
		git config --local --unset commit.gpgsign
		git config --local commit.gpgsign false
	elif [[ $PWD != *"cattlebruisers"* && $machine_hostname == "ip-192-168-1-26" ]]; then
		-jb-zsh-debug "[USER DEBUG]: 	Setting \"kraken\" git configs"

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

	-jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	linking $plugins/zsh-url-highlighter/url to $syntax_highlighting/highlighters/url" 2
	ln -s $plugins/zsh-url-highlighter/url $syntax_highlighting/highlighters
	-jb-zsh-debug "[LOAD URL HIGHLIGHTER DEBUG]: 	$plugins/zsh-url-highlighter/url to $syntax_highlighting/highlighters/url linked successfully" 2
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

#   nyg: shortcut to globally install pkgs with npm AND yarn
#   ------------------------------------------------------------
function nyg () { npm install --global "$1" && yarn global add "$1" ; }
function nygAll () {
	while IFS='' read -r line || [[ -n "$line" ]]; do
	    echo "\tInstalling Globally:\t$line"
	    nyg $line
	done < ~/.nvm/default-packages
}

function upgrade-jb-zsh () {
	emulate -L zsh
	upgrade_oh_my_zsh
	eval antigen selfupdate && eval antigen update
}

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

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
function showa () { /usr/bin/grep --color=always -i -a1 "$@" $JB_ZSH_BASE/zsh/aliases.zsh | grep -v '^\s*$' | less -FSRXc ; }

function dockerKrakenLogin () { cat "$1" | docker login reg-kakarot.chorse.space -u joaquinb --password-stdin }

function encodeBase64 () {
	local registry_username="$1"
	local registry_password="$2"

	echo -n "${registry_username}:${registry_password}" | base64
}


#   ---------------------------
#   4. SEARCHING
#   ---------------------------

function ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
function ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
function ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

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

#   my-ps: List processes owned by my user:
#   ------------------------------------------------------------
function my-ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

# turn hidden files on/off in Finder
function hiddenOn() { defaults write com.apple.Finder AppleShowAllFiles YES ; }
function hiddenOff() { defaults write com.apple.Finder AppleShowAllFiles NO ; }

# Remove workspace auto-switching by running the following command
function workspaceAutoswitch() { defaults write com.apple.dock workspaces-auto-swoosh -bool YES ; }
function noWorkspaceAutoswitch() { defaults write com.apple.dock workspaces-auto-swoosh -bool NO ; }

# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

#   ---------------------------
#   -- PERMISSIONS
#   ---------------------------
function show_all_users() { cut -d ":" -f 1 /etc/passwd ; }
function permitme() { pkexec chown $USER:adm $PWD -hR ; }
function users_by_group() { getent group "$1" | awk -F: '{print $4}' ; }

__confirm_existence() {
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

__trash() {
		if which rimraf &> /dev/null; then
			sudo rimraf $1 -s
		else
			sudo rm -rf $1
		fi
		echo "\n\t\tSuccessfully Trashed $1"
}

function trash() {
	if __confirm_existence $1; then
		__trash $1
	fi;
	echo
}

# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs() {
  local section=${1:-all}
  open_command "https://nodejs.org/docs/$(node --version)/api/$section.html"
}

function docker-ngrok() {
	local server=$1
	local server_port=${2:80}
  docker run --rm -it --link $server:http wernight/ngrok ngrok http http:$server_port
}

function my-ip() {
 	ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
	ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
function ii () {
	echo -e "\nYou are logged on ${RED}$HOST"
	echo -e "\nAdditionnal information:$NC " ; uname -a
	echo -e "\n${RED}Users logged on:$NC " ; w -h
	echo -e "\n${RED}Current date :$NC " ; date
	echo -e "\n${RED}Machine stats :$NC " ; uptime
	echo -e "\n${RED}Current network location :$NC " ; scselect
	echo -e "\n${RED}Public facing IP Address :$NC " ; myip
}

function check-web-connectivity() {
	case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
	  [23]) echo "HTTP connectivity is up";;
	  5) echo "The web proxy won't let us through";;
	  *) echo "The network is down or very slow";;
	esac
}



