############################################## env #################################################

alias c='clear'                             # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias f_path='echo -e ${fpath//:/\\n}'      # fpath:        Echo all executable fpaths
alias cd_path='echo -e ${cdpath//:/\\n}'    # cdpath:       Echo all executable cdpaths
alias UN='echo $USER'             			# UN:     		Echo Username

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

# sort files in current directory by the number of words they contain
alias wordy='wc -w * | sort | tail -n10'

# $ gp ruby
# (all ruby process will be displayed)
# creates a global alias for grep
alias -g gp='ps ax | grep -i'
alias p='ps -f'

alias hgrep="fc -El 0 | grep"
alias help='man'

alias show_node_processes='ps -a | grep node'