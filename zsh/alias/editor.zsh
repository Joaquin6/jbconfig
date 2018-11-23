############################################# editor ###############################################
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

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