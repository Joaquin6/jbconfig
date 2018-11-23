function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
  if ! [ -x "$(command -v powerline-shell)" ]; then
    echo "You should install powerline-shell from https://github.com/milkbikis/powerline-shell/"
  elif which powerline-shell > /dev/null; then
    install_powerline_precmd
  fi
fi

# Support for bash
PROMPT_COMMAND='prompt'

# Mirrored support for zsh. See: https://superuser.com/questions/735660/whats-the-zsh-equivalent-of-bashs-prompt-command/735969#735969
precmd() { eval "$PROMPT_COMMAND" }

function prompt() {
    if [ "$PWD" != "$MYOLDPWD" ]; then
        MYOLDPWD="$PWD"
        test -e .venv && workon `cat .venv`
    fi
}
