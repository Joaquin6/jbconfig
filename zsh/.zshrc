#	-------------------------------
#	JB ZSH DOCUMENTATION
#	-------------------------------

#		autoload
#			The `autoload` feature is not available in bash, but it is in `ksh` (korn shell) and `zsh`.
#			On `zsh` see `man zshbuiltins`.
#
#			Functions are called in the same way as any other command.
#			There can be a name conflict between a program and a function.
#			What autoload does is to mark that name as being a function rather than an external program.
#			The function has to be in a file on its own, with the filename the same as the function name.
#
#			For Example: `autoload -Uz vcs_info`
#
#			The `-U` means mark the function `vcs_info` for autoloading and suppress alias expansion.
#			The `-z` means use `zsh` (rather than `ksh`) style. See also the `functions` command.
#
#			References
#				http://zsh.sourceforge.net/Doc/Release/Files.html
#				http://linux.die.net/man/1/zshbuiltins
#				http://zsh.sourceforge.net/Doc/Release/Functions.html
#				https://stackoverflow.com/questions/12570749/zsh-completion-difference
#				http://bewatermyfriend.org/p/2012/003/
#				https://unix.stackexchange.com/questions/121802/zsh-how-to-check-if-an-option-is-enabled
#				https://www-s.acm.illinois.edu/workshops/zsh/parameters/expansion.html
#
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
	for ((i=0; i<_jb_zsh_debug_indent; i++))
	do
      indent="  $indent"
    done
  fi

  # Split $msg by \n (not newline).
  local lines=(${(ps:\\n:)msg})
  for line in "$lines"; do
    echo -n "${fg_bold[blue]}[jb-zsh-config]${fg_no_bold[default]}	" >&2
    echo ${indent}${line} >&2
  done
}
path-checker() {
	local path2chk="$1"
	if [ -d "$path2chk" ]; then
		jb-zsh-debug "[PATH DEBUG]: 	Checking permissions on path $path2chk" 2
		jb-zsh-debug "$path2chk" | sed 's/\//\n/g' \
		| while read pathElem ; do
		    testPath="${testPath+${testPath}/}${pathElem}"
		    ls -ld "$testPath"
		done
	else
		jb-zsh-debug "[PATH DEBUG]: 	no directory access to $path2chk"
	fi
}
handle-add-path() {
	local incoming_path="$1"
	# Check if $incoming_path exists.
	if [ -d "$incoming_path" ]; then
		# Control will enter here if $incoming_path exists.
		# My check to make sure the new node path is added to the PATH variable
		if [[ "$PATH" != *"$incoming_path"* ]]; then
			jb-zsh-debug "[PATH DEBUG]: 	Adding $incoming_path to PATH" 2
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
		jb-zsh-debug "[PATH DEBUG]: 	$incoming_path doesn't exist. Not adding to PATH" 2
	fi
}
handle-add-manpath() {
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
		jb-zsh-debug "[MANPATH DEBUG]: 	$incoming_path doesn't exist. Not adding to MANPATH" 2
	fi
}
handle-add-infopath() {
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
		jb-zsh-debug "[INFOPATH DEBUG]: 	$incoming_path doesn't exist. Not adding to INFOPATH" 2
	fi
}
handle-add-pkgconfigpath() {
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
		jb-zsh-debug "[PKG_CONFIG_PATH DEBUG]: 	$incoming_path doesn't exist." 2
		# Check if brew is a command. If so, suggest installing with brew
		if which brew &> /dev/null; then
			jb-zsh-debug "[PKG_CONFIG_PATH DEBUG]: 	Suggestion => \"brew install $1\"" 2
		fi
	fi
}
command_exists() {
  type "$1" &> /dev/null;
}
reset-npm-prefix() {
  # https://stackoverflow.com/questions/34718528/nvm-is-not-compatible-with-the-npm-config-prefix-option

  local node_version=$(nvm version)

  npm config delete prefix
  npm config set prefix $NVM_DIR/versions/node/$node_version
}
load-user-specifics() {
	local incoming_user=$USER
	local machine_hostname="$(hostname -f)"

  if [ -d $PWD/.git ]; then
  	# Handle git configs
  	if [[ $PWD == *"cattlebruisers"* ]]; then
  		jb-zsh-debug "[USER DEBUG]: 	Setting \"CattleBruisers\" git configs"

  		git config --local --unset user.name
  		git config --local user.name "Joaquin Briceno"
  		git config --local --unset user.email
  		git config --local user.email joaquin.briceno@insitu.com
  	elif [[ $PWD == *"machine-learning"* ]]; then
  		jb-zsh-debug "[USER DEBUG]: 	Setting \"Machine Learning\" git configs"

  		git config --local --unset user.name
  		git config --local user.name "Joaquin Briceno"
  		git config --local --unset user.email
  		git config --local user.email joaquin.briceno@insitu.com
  	else
  		jb-zsh-debug "[USER DEBUG]: 	Setting \"Joaquin6\" git configs"

  		git config --local --unset user.name
  		git config --global user.name joaquin6
  		git config --local user.name joaquin6
  		git config --local --unset user.email
  		git config --global user.email joaquinbriceno1@gmail.com
  		git config --local user.email joaquinbriceno1@gmail.com
  	fi
  fi
}
load-nvmrc() {
	if which nvm &> /dev/null; then
		local node_version="$(nvm version)"
    	local nvmrc_path="$(nvm_find_nvmrc)"

		if [ -n "$nvmrc_path" ]; then
			local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

			if [ "$nvmrc_node_version" = "N/A" ]; then
				nvm install
			elif [ "$nvmrc_node_version" != "$node_version" ]; then
				nvm use $nvmrc_node_version
			fi
		elif [ "$node_version" != "$(nvm version default)" ]; then
			echo "Reverting to nvm default version"
			nvm use default
		fi

		reset-npm-prefix

		handle-add-path $NVM_DIR/versions/node/$node_version/bin
	else
    	jb-zsh-debug "[LOAD NVMRC DEBUG]: 	Can not find nvm command."
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
load-mgdm-theme() {
	local themes=$JB_ZSH_BASE/zsh/themes
	local mgdm_theme=$themes/mgdm.zsh-theme
	local destination=$ZSH_CUSTOM/themes

	if [ ! -d $destination ]; then
		jb-zsh-debug "[LOAD MGDM THEME DEBUG]: 	creating $destination" 2
		mkdir -p $destination
		jb-zsh-debug "[LOAD MGDM THEME DEBUG]: 	$destination created." 2
	fi

	if [ ! -f $destination/mgdm.zsh-theme ]; then
		jb-zsh-debug "[LOAD MGDM THEME DEBUG]: 	copying $mgdm_theme to $destination/mgdm.zsh-theme" 2
		cp $mgdm_theme $destination/mgdm.zsh-theme
		jb-zsh-debug "[LOAD MGDM THEME DEBUG]: 	copied $mgdm_theme to $destination/mgdm.zsh-theme successfully" 2
	fi
}
check-install() {
	pid=$1;
	name=$2;

	type -P $pid &>/dev/null && echo "- $name is already installed" || {
	        read -p "Do you want to install $name? [y/n]: " install
	        if [ $install == "y" ]; then
			toinstall=("${toinstall[@]}" "$pid")
	        fi
	}
}

JB_ZSH_PATHS=(
	$ADOTDIR
	$HOME/bin
	$USER_BIN
	$USER_LOCAL_BIN
	$HOME/.cabal/bin
	$HOME/.ghcup/bin
	$HOME/depot_tools
	$USER_LOCAL/Homebrew/bin
	$USER_LOCAL_FRWKS/Python.framework/Versions/Current/bin
	$USER_LOCAL_OPT/binutils/bin
	$USER_LOCAL_OPT/sphinx-doc/bin
	$USER_LOCAL_OPT/diffutils/bin
	$USER_LOCAL_OPT/gettext/bin
	$USER_LOCAL_OPT/llvm/bin
	$USER_LOCAL_OPT/apr/bin
	$USER_LOCAL_OPT/m4/bin
	$USER_LOCAL_OPT/file-formula/bin
	$USER_LOCAL_OPT/icu4c/bin
	$USER_LOCAL_OPT/icu4c/sbin
	$USER_LOCAL_OPT/libpq/bin
	$USER_LOCAL_OPT/sqlite/bin
	$USER_LOCAL_OPT/go/libexec/bin
	$USER_LOCAL_OPT/libarchive/bin
	$USER_LOCAL_OPT/openssl/bin
	$USER_LOCAL_OPT/gnu-sed/libexec/gnubin
	$USER_LOCAL_OPT/gnu-tar/libexec/gnubin
	$USER_LOCAL_OPT/coreutils/libexec/gnubin
	$USER_LOCAL_OPT/gnu-indent/libexec/gnubin
	$USER_LOCAL_OPT/gnu-which/libexec/gnubin
	$USER_LOCAL_OPT/grep/libexec/gnubin
	$USER_LOCAL_OPT/findutils/libexec/gnubin
	$USER_LOCAL_OPT/go/libexec/bin
	$USER_LOCAL_GO/bin
	$PERL_LOCAL_LIB_ROOT/bin
	$GOPATH/bin
	$USER_LOCAL/bin
	$USER_LOCAL/sbin
	$USER_LOCAL_OPT/python/libexec/bin
)

if [[ $OSTYPE == linux* ]]; then # linux
	JB_ZSH_PATHS=(
		$HOME/linuxbrew/.linuxbrew/bin
		$HOME/linuxbrew/.linuxbrew/Homebrew/bin
		$JB_ZSH_PATHS
	)
elif [[ $OSTYPE == darwin* ]]; then # macos
	JB_ZSH_PATHS=(
		"/Applications/Sublime Text.app/Contents/SharedSupport/bin"
		$JB_ZSH_PATHS
	)
fi

JB_ZSH_MANPATHS=(
	$USER_LOCAL/share/man
	$USER_LOCAL_OPT/gnu-tar/libexec/gnuman
	$USER_LOCAL_OPT/gnu-sed/libexec/gnuman
	$USER_LOCAL_OPT/coreutils/libexec/gnuman
)

JB_ZSH_PKGCONFIGPATHS=(libffi icu4c libpq sqlite libarchive openssl)

for jbzshpath in $JB_ZSH_PATHS
do
    handle-add-path $jbzshpath
done

for jbzshpath in $JB_ZSH_MANPATHS
do
    handle-add-manpath $jbzshpath
    handle-add-infopath $jbzshpath
done

for jbzshpath in $JB_ZSH_PKGCONFIGPATHS
do
    handle-add-pkgconfigpath $jbzshpath
done

if ! command_exists yarn; then jb-zsh-debug "Command 'yarn' is not installed!"; fi
if ! command_exists compctl; then jb-zsh-debug "Command 'compctl' is not installed!"; fi
if ! command_exists rbenv; then
	if [ -d $HOME/.rbenv ]; then
		handle-add-path $HOME/.rbenv/bin
		handle-add-path $HOME/.rbenv/libexec
		handle-add-path $HOME/.rbenv/shims
	fi
	if [ -d $LINUXBREW_PATH ]; then
		handle-add-path $LINUXBREW_PATH/bin/rbenv
		handle-add-path $LINUXBREW_PATH/rbenv/shims
	fi
fi

[[ -s $NVM_DIR/nvm.sh ]] && . $NVM_DIR/nvm.sh
# [ -f $USER_LOCAL_BIN/virtualenvwrapper_lazy.sh ] && source $USER_LOCAL_BIN/virtualenvwrapper_lazy.sh
[[ -s $USER_LOCAL/etc/profile.d/autojump.sh ]] && . $USER_LOCAL/etc/profile.d/autojump.sh
[[ -s $USER_SHARE/autojump/autojump.zsh ]] && . $USER_SHARE/autojump/autojump.zsh || \
  [[ -s $USER_SHARE/autojump/autojump.sh ]] && . $USER_SHARE/autojump/autojump.sh
# [[ -f $USER_LOCAL_BIN/aws_zsh_completer.sh ]] && . $USER_LOCAL_BIN/aws_zsh_completer.sh
[[ -f $USER_LOCAL_ETC/bash_completion.d ]] && . $USER_LOCAL_ETC/bash_completion.d
[[ -s $HOME/.iterm2/.iterm2_shell_integration.zsh ]] && . $HOME/.iterm2/.iterm2_shell_integration.zsh

if command_exists hub; then eval "$(hub alias -s)"; fi
if command_exists jenv; then eval "$(jenv init -)"; fi
if command_exists direnv; then eval "$(direnv hook zsh)"; fi
if command_exists rbenv; then eval "$(rbenv init -)"; fi
if command_exists python3; then
	export PYTHON_VERSION=$(python3 -c 'import platform; print(platform.python_version())')
	[[ $PYTHON_VERSION == 3.6.8 ]] && export PYTHON_VERSION=3
	handle-add-path $PYTHON_VERSIONS_PATH/$PYTHON_VERSION/bin
	export VIRTUALENVWRAPPER_PYTHON=$PYTHON_VERSIONS_PATH/$PYTHON_VERSION/bin/python3
elif command_exists python; then
	export PYTHON_VERSION=$(python -c 'import platform; print(platform.python_version())')
	handle-add-path $PYTHON_VERSIONS_PATH/$PYTHON_VERSION/bin
	export VIRTUALENVWRAPPER_PYTHON=$PYTHON_VERSIONS_PATH/$PYTHON_VERSION/bin/python
else
	echo "Python has not been installed!"
	check-install python "Python"
fi

source $JB_ZSH_BASE/zsh/alias/index.zsh
source $JB_ZSH_BASE/zsh/.zfunctions
source $JB_ZSH_BASE/zsh/.zshrc-antigen
