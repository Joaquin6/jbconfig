#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='nano'
export VISUAL='nano'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
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
  $HOME/.zprezto
  $path
)
fpath=(
	$HOME/.config/completions
  $HOME/.zfunctions
	$USER_LOCAL_ETC/bash_completion.d
	$USER_LOCAL_SHARE/zsh-completions
	$USER_LOCAL_SHARE/zsh/site-functions
	$fpath
)

export OOO_FORCE_DESKTOP=gnome

export GREP_COLOR='1;31'

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
# export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESS="-R"
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
  # export LESSOPEN="| src-hilite-lesspipe.sh %s"
  export LESSHISTFILE=/dev/null
  export LESS_TERMCAP_mb=$'\E[01;32m'
  export LESS_TERMCAP_md=$'\E[01;32m'
  export LESS_TERMCAP_me=$'\E[0m'
  export LESS_TERMCAP_se=$'\E[0m'
  export LESS_TERMCAP_so=$'\E[01;44;33m'
  export LESS_TERMCAP_ue=$'\E[0m'
  export LESS_TERMCAP_us=$'\E[01;37m'
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