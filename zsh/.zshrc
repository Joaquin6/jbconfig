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
		jb-zsh-debug "[PATH DEBUG]: 	Adding $incoming_path to PATH" 2
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
		jb-zsh-debug "[PATH DEBUG]: 	$incoming_path doesn't exist. Not adding to PATH" 2
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
		jb-zsh-debug "[MANPATH DEBUG]: 	$incoming_path doesn't exist. Not adding to MANPATH" 2
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
		jb-zsh-debug "[INFOPATH DEBUG]: 	$incoming_path doesn't exist. Not adding to INFOPATH" 2
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
		jb-zsh-debug "[PKG_CONFIG_PATH DEBUG]: 	$incoming_path doesn't exist." 2
		# Check if brew is a command. If so, suggest installing with brew
		if which brew &> /dev/null; then
			jb-zsh-debug "[PKG_CONFIG_PATH DEBUG]: 	Suggestion => \"brew install $1\"" 2
		fi
	fi
}
command_exists () {
  type "$1" &> /dev/null;
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
    nvm use --delete-prefix default --silent
  fi

	handle-add-path $NVM_DIR/versions/node/$node_version/bin
}

handle-add-path $HOME/bin
handle-add-path /usr/local/bin
handle-add-path $HOME/.cask/bin

if command_exists python; then
  export PYTHON_VERSION=$(python -c 'import platform; print(platform.python_version())')
else
  echo "Python has not been installed!"
fi

# If you come from bash you might have to change your $PATH.
handle-add-path $USER_BIN

if [ -d $USER_LOCAL_FRWKS ]; then
	handle-add-path $USER_LOCAL_FRWKS/Python.framework/Versions/Current/bin
fi

if [ -d $USER_LOCAL_OPT ]; then
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
	handle-add-path $USER_LOCAL_OPT/curl-openssl/bin
	handle-add-path $USER_LOCAL_OPT/openldap/bin
	handle-add-path $USER_LOCAL_OPT/openldap/sbin
	handle-add-path $USER_LOCAL_OPT/gnu-sed/libexec/gnubin
	handle-add-path $USER_LOCAL_OPT/go/libexec/bin

	handle-add-manpath $USER_LOCAL_OPT/gnu-tar/libexec/gnuman
	handle-add-manpath $USER_LOCAL_OPT/gnu-sed/libexec/gnuman
	handle-add-manpath $USER_LOCAL_OPT/coreutils/libexec/gnuman
fi

handle-add-path $USER_LOCAL_GO/bin
handle-add-path $PERL_LOCAL_LIB_ROOT/bin

if [[ "$OSTYPE" == darwin* ]]; then
	handle-add-path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

if [ -d /usr/lib/x86_64-linux-gnu ]; then
	handle-add-path /usr/lib/x86_64-linux-gnu
fi

handle-add-infopath $USER_SHARE/info

handle-add-pkgconfigpath libffi
handle-add-pkgconfigpath icu4c
handle-add-pkgconfigpath libpq
handle-add-pkgconfigpath sqlite
handle-add-pkgconfigpath libarchive
handle-add-pkgconfigpath openssl

handle-add-path $GOPATH/bin
handle-add-path $USER_LOCAL/bin
handle-add-path $USER_LOCAL/sbin
handle-add-manpath $USER_LOCAL/share/man
handle-add-infopath $USER_LOCAL/share/info
handle-add-manpath $USER_LOCAL_OPT/coreutils/libexec/gnuman

autoload -Uz compinit && compinit -i

[[ -s $NVM_DIR/nvm.sh ]] && . $NVM_DIR/nvm.sh
[[ -s $USER_LOCAL_BIN/virtualenvwrapper.sh ]] && . $USER_LOCAL_BIN/virtualenvwrapper.sh
[[ -s $USER_LOCAL/etc/profile.d/autojump.sh ]] && . $USER_LOCAL/etc/profile.d/autojump.sh
[[ -s $USER_SHARE/autojump/autojump.zsh ]] && . $USER_SHARE/autojump/autojump.zsh || \
  [[ -s $USER_SHARE/autojump/autojump.sh ]] && . $USER_SHARE/autojump/autojump.sh
[[ -f $USER_LOCAL_BIN/aws_zsh_completer.sh ]] && . $USER_LOCAL_BIN/aws_zsh_completer.sh
[[ -f $USER_LOCAL_ETC/bash_completion.d ]] && . $USER_LOCAL_ETC/bash_completion.d
[[ -s $HOME/.iterm2_shell_integration.zsh ]] && . $HOME/.iterm2_shell_integration.zsh

if which rbenv &> /dev/null; then
	if [ -d $HOME/.rbenv ]; then
		handle-add-path $HOME/.rbenv/bin
		handle-add-path $HOME/.rbenv/libexec
		handle-add-path $HOME/.rbenv/shims
	fi
	if [ -d $LINUXBREW_PATH ]; then
		handle-add-path $LINUXBREW_PATH/bin/rbenv
		handle-add-path $LINUXBREW_PATH/rbenv/shims
	fi
	eval "$(rbenv init -)"
fi
if which hub &> /dev/null; then
	eval "$(hub alias -s)"
fi

source $JB_ZSH_BASE/zsh/alias/index.zsh
source $JB_ZSH_BASE/zsh/functions.zsh
source $JB_ZSH_BASE/zsh/.zshrc-antigen

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s $SDKMAN_DIR/bin/sdkman-init.sh ]] && source $SDKMAN_DIR/bin/sdkman-init.sh

iterm2_prompt_mark
