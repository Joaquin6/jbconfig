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

source ~/.jbconfig/zsh/environment.zsh
source ~/.jbconfig/zsh/functions.zsh
source ~/.jbconfig/zsh/paths.zsh
source ~/.jbconfig/zsh/plugins/base.zsh
source ~/.jbconfig/zsh/aliases.zsh
source ~/.jbconfig/zsh/theme.zsh
