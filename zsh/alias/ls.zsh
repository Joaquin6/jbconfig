####################################################################################################
########################################### ls aliases #############################################
####################################################################################################

# Detect which `ls` flavor is in use.
# List all files colorized in long format, including dot files
if ls --color > /dev/null 2>&1; then
  colorflag="--color" # GNU `ls`
else
  colorflag="-G"      # OS X `ls`
fi

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh --color=always --group-directories-first'     #size,show type,human readable
alias la='ls -lAFh ${colorflag}'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
# all hidden files
alias lh='ls -a | egrep "^\."'
alias llgf='ls -GFlAhp'
alias lla='ls -la'
alias lsg='ls -GFh'
alias lrtg='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias filecount='ls -aRF | wc -l'
alias sl=ls
