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

. ~/.jbconfig/zsh/environment.zsh
. ~/.jbconfig/zsh/plugins/base.zsh
. ~/.jbconfig/zsh/alias/index.zsh
. ~/.jbconfig/zsh/functions.zsh
. ~/.jbconfig/zsh/paths.zsh
. ~/.jbconfig/zsh/plugins/git-flow-completion.zsh
. ~/.jbconfig/zsh/theme.zsh
. ~/.jbconfig/zsh/completions.zsh
. ~/.jbconfig/zsh/prompt.zsh
. ~/.jbconfig/zsh/host_specific.zsh

[[ -s $USER_LOCAL_BIN/virtualenvwrapper.sh ]] && . $USER_LOCAL_BIN/virtualenvwrapper.sh
[[ -s $USER_LOCAL/etc/profile.d/autojump.sh ]] && . $USER_LOCAL/etc/profile.d/autojump.sh
[[ -s $USER_SHARE/autojump/autojump.zsh ]] && . $USER_SHARE/autojump/autojump.zsh || \
  [[ -s $USER_SHARE/autojump/autojump.sh ]] && . $USER_SHARE/autojump/autojump.sh
[[ -s $HOME/.iterm2_shell_integration.zsh ]] && . $HOME/.iterm2_shell_integration.zsh

# The next line updates PATH for the Google Cloud SDK.
[[ -f $GCLOUD_SDK_PATH/path.zsh.inc ]] && . $GCLOUD_SDK_PATH/path.zsh.inc
# The next line enables shell command completion for gcloud.
[[ -f $GCLOUD_SDK_PATH/completion.zsh.inc ]] && . $GCLOUD_SDK_PATH/completion.zsh.inc

# Make prompt prettier
# autoload -U compinit && compinit -i
# autoload -U promptinit && promptinit -i
autoload -U add-zsh-hook promptinit; promptinit

add-zsh-hook chpwd -load-nvmrc
-load-nvmrc

add-zsh-hook chpwd -load-user-specifics
-load-user-specifics

# Set Spaceship ZSH as a prompt
# prompt spaceship

# Set Spaceship ZSH as a prompt
# autoload -U promptinit; promptinit
prompt spaceship