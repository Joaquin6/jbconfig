######################################### docker-compose ###########################################
# Docker-compose related zsh aliases
# Use dco as alias for docker-compose, since dc on *nix is 'dc - an arbitrary precision calculator'
# https://www.gnu.org/software/bc/manual/dc-1.05/html_mono/dc.html

alias dco='docker-compose'
alias dcps='docker-compose ps'
alias dcrm='docker-compose rm'
alias dcr='docker-compose run'
alias dcup='docker-compose up'
alias dcl='docker-compose logs'
alias dce='docker-compose exec'
alias dcb='docker-compose build'
alias dcdn='docker-compose down'
alias dcpull='docker-compose pull'
alias dcstop='docker-compose stop'
alias dclf='docker-compose logs -f'
alias dcstart='docker-compose start'
alias dcrestart='docker-compose restart'