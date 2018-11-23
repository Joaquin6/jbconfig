# Having additional shell completions is handy. Those go in their own file.

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
[[ -s $(dirname $(gem which colorls))/tab_complete.sh ]] && . $(dirname $(gem which colorls))/tab_complete.sh
