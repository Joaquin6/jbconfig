#   ---------------------------
#   6. NETWORKING
#   ---------------------------

alias flush-DNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias ip-info0='ipconfig getpacket en0'              # ip-info0:      Get info on connections for en0
alias ip-info1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias show-blocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

alias df='df -h'            # Disk free, in gigabytes, not bytes
alias du='du -h -c'         # Calculate total disk usage for a folder
alias dud='du -d 1 -h'
alias duf='du -sh *'

# https://rtyley.github.io/bfg-repo-cleaner/
alias bfg='java -jar /usr/local/bin/bfg-1.13.0.jar'

alias emc="emacsclient -n" # no blocking terminal waiting for edit
