####################################################################################################
############################################# ALIASES ##############################################
####################################################################################################

# Set JB_ZSH_BASE if it isn't already defined
[[ -z $JB_ZSH_BASE ]] && export JB_ZSH_BASE=~/.jbconfig


source ~/.jbconfig/zsh/alias/cd.zsh
source ~/.jbconfig/zsh/alias/docker.zsh
source ~/.jbconfig/zsh/alias/docker-compose.zsh
source ~/.jbconfig/zsh/alias/editor.zsh
source ~/.jbconfig/zsh/alias/ls.zsh
source ~/.jbconfig/zsh/alias/lsof.zsh
source ~/.jbconfig/zsh/alias/vscode.zsh
source ~/.jbconfig/zsh/alias/networking.zsh
source ~/.jbconfig/zsh/alias/tar.zsh
source ~/.jbconfig/zsh/alias/env.zsh

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
