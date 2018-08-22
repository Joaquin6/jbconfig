# Theme configuration

# All options must be overridden in your .zshrc file after the theme.
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern url)
export ZSH_HIGHLIGHT_URL_HIGHLIGHTER_TIMEOUT=4
export ZSH_HIGHLIGHT_STYLES[url-good]='fg=blue,bold'
export ZSH_HIGHLIGHT_STYLES[url-bad]='fg=magenta,bold'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=green,bold'

# Spaceship Prompt Options -  https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Options.md
export SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  golang        # Go section
  php           # PHP section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  pyenv         # Pyenv section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

export SPACESHIP_RPROMPT_ORDER=(
	time          # Time stampts section
	battery       # Battery level and status
)

export SPACESHIP_TIME_SHOW=true
export SPACESHIP_TIME_12HR=true

# autoload -U compinit && compinit -i
# autoload -U promptinit && promptinit -i
autoload -U add-zsh-hook
add-zsh-hook chpwd -load-nvmrc
-load-nvmrc
add-zsh-hook chpwd -load-user-specifics
-load-user-specifics

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship