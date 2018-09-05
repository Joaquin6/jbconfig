############################################### ls #################################################
# ls, the common ones I use a lot shortened for rapid fire usage

# size,show type,human readable
alias l='ls -lFh'
# long list,show almost all,show type,human readable
alias la='ls -lAFh'
# sorted by date,recursive,show type,human readable
alias lr='ls -tRFh'
# long list,sorted by date,show type,human readable
alias lt='ls -ltFh'
# long list
alias ll='ls -l'
# all hidden files
alias lh='ls -a | egrep "^\."'
alias llgf='ls -GFlAhp'
alias lla='ls -la'
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lsg='ls -GFh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias lrtg='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias filecount='ls -aRF | wc -l'
alias sl=ls