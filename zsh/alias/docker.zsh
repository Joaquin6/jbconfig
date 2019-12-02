############################################# docker ###############################################

alias docker-clean-unused='docker system prune --all --force --volumes'
alias docker-clean-all='docker stop $(docker container ls -a -q) && docker system prune -a -f --volumes'
alias docker-clean-containers='docker container stop $(docker container ls -a -q) && docker container rm $(docker container ls -a -q)'
alias docker-clean-dangling-images='docker rmi $(docker images --filter dangling=true -q --no-trunc)'

drm() { docker rm $(docker ps -a | grep $1 | awk '{print $1}') ; }
# docker rm $(docker ps -a | grep "46 hours ago")
drmt() { docker rm $(docker ps -a | grep "$1") ; }
