#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Change shell for current user to zsh
if [ -n "$ZSH_VERSION" ]; then
    # include .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
    . "$HOME/.zshrc"
    fi
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
else
  if [[ "$OSTYPE" == linux-gnu ]]; then
  	export BROWSER='xdg-open'
  fi
fi

# Ensure editor is set
export EDITOR=vim
export VISUAL=vim
export PAGER=less

#
# Language
#

if [[ -z "$LANG" ]]; then
  # Ensure languages are set
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
fi

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
	$HOME/.config/completions
  $HOME/functions.zsh
	$USER_LOCAL_ETC/bash_completion.d
	$USER_LOCAL_SHARE/zsh-completions
	$USER_LOCAL_SHARE/zsh/site-functions
	$fpath
)

if type brew &>/dev/null; then
  fpath=(
    $(brew --prefix)/share/zsh/site-functions
    $fpath
  )
fi

if [ -d $LINUXBREW_PATH ]; then
  path=(
    /usr/local/{bin,sbin}
    $LINUXBREW_PATH/{bin,sbin}
    $path
  )

  fpath=(
    $LINUXBREW_LOCAL_SHARE/zsh/site-functions
    $fpath
  )
fi

export OOO_FORCE_DESKTOP=gnome

export GREP_COLOR='1;31'

# Less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-g -i -M -R -S -w -z-4'
# export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
	if [[ "$OSTYPE" == darwin* ]]; then
		# echo "------- DARWIN SYSTEM --------"
		export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
	else
		# echo "------- NON-DARWIN SYSTEM --------"
		export LESSOPEN="|/home/linuxbrew/.linuxbrew/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
	fi
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

# Set iTerm tab title to current directory
precmd() {
  echo -ne "\e]1;${PWD##*/}\a"
}
