#   ---------------------------
#   6. NETWORKING
#   ---------------------------

alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias ip-info0='ipconfig getpacket en0'              # ip-info0:      Get info on connections for en0
alias ip-info1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias show-blocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

# IP addresses
alias dnsip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

alias df='df -h'            # Disk free, in gigabytes, not bytes
alias du='du -h -c'         # Calculate total disk usage for a folder
alias dud='du -d 1 -h'
alias duf='du -sh *'

# https://rtyley.github.io/bfg-repo-cleaner/
alias bfg='java -jar /usr/local/bin/bfg-1.13.0.jar'

alias emc="emacsclient -n" # no blocking terminal waiting for edit
