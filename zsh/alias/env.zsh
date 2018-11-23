############################################## env #################################################

# Mac Helpers
alias show_hidden='defaults write com.apple.Finder AppleShowAllFiles YES && killall Finder'
alias hide_hidden='defaults write com.apple.Finder AppleShowAllFiles NO && killall Finder'

# I like to have a fancy looking emacs session in my terminal.
# According to this [stack-overflow question](http://unix.stackexchange.com/questions/1045/getting-256-colors-to-work-in-tmux),
# tmux suggests not altering the TERM in your shell init. Instead, we'll alias tmux to set the variable.
# The backslash here makes it so we don't risk looping on the alias.
alias tmux='TERM=xterm-256color \tmux'

alias c='clear'                             # c:            Clear terminal display
alias clr='clear;echo "Currently logged in on $(tty), as $(whoami) in directory $(pwd)."'
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias f_path='echo -e ${fpath//:/\\n}'      # fpath:        Echo all executable fpaths
alias cd_path='echo -e ${cdpath//:/\\n}'    # cdpath:       Echo all executable cdpaths
alias UN='echo $USER'             			# UN:     		Echo Username
alias ping='ping -c 5'      # Pings with 5 packets, not unlimited

alias grep='grep --color=auto' # Always highlight grep search term
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

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# zsh is able to auto-do some kungfoo
# depends on the SUFFIX :)
if is-at-least 4.2.0; then
  # open browser on urls
  if [[ -n "$BROWSER" ]]; then
    _browser_fts=(htm html de org net com at cx nl se dk)
    for ft in $_browser_fts; do alias -s $ft=$BROWSER; done
  fi

  _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
  for ft in $_editor_fts; do alias -s $ft=$EDITOR; done

  if [[ -n "$XIVIEWER" ]]; then
    _image_fts=(jpg jpeg png gif mng tiff tif xpm)
    for ft in $_image_fts; do alias -s $ft=$XIVIEWER; done
  fi

  _media_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
  for ft in $_media_fts; do alias -s $ft=mplayer; done

  #read documents
  alias -s pdf=acroread
  alias -s ps=gv
  alias -s dvi=xdvi
  alias -s chm=xchm
  alias -s djvu=djview

  #list whats inside packed file
  alias -s zip="unzip -l"
  alias -s rar="unrar l"
  alias -s tar="tar tf"
  alias -s tar.gz="echo "
  alias -s ace="unace l"
fi

# Nifty extras
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias pypath='python -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"'
alias pycclean='find . -name "*.pyc" -exec rm {} \; && find . -name "__pycache__" -exec rm -rf {} \;'
alias ssh='ssh -R 10999:localhost:22'
alias nethack='telnet nethack.alt.org'

# I've been hit a few times with sites that block the curl user agent,
# so I have a pair of simple aliases which will masquerade as IE6 or Firefox to get around it.
# curl for useragents
alias iecurl="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)\""
alias ffcurl="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.8) Gecko/2009032609 Firefox/3.0.0 (.NET CLR 3.5.30729)\""

# Recursively delete `.DS_Store` files
alias clean-ds-stores="find . -name '*.DS_Store' -type f -ls -delete"
