#   ---------------------------
#   NETWORKING
#   ---------------------------

alias net-cons='lsof -i'                            # netCons:      Show all open TCP/IP sockets
alias open-ports='sudo lsof -i | grep LISTEN'       # openPorts:    All listening connections
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets