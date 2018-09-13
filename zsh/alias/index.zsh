####################################################################################################
############################################# ALIASES ##############################################
####################################################################################################

# Set JB_ZSH_BASE if it isn't already defined
[[ -z $JB_ZSH_BASE ]] && export JB_ZSH_BASE=~/.jbconfig


. ~/.jbconfig/zsh/alias/ls.zsh
. ~/.jbconfig/zsh/alias/docker.zsh
. ~/.jbconfig/zsh/alias/docker-compose.zsh
. ~/.jbconfig/zsh/alias/editor.zsh
. ~/.jbconfig/zsh/alias/vscode.zsh
. ~/.jbconfig/zsh/alias/lsof.zsh
. ~/.jbconfig/zsh/alias/networking.zsh
. ~/.jbconfig/zsh/alias/tar.zsh
. ~/.jbconfig/zsh/alias/colorls.zsh
. ~/.jbconfig/zsh/alias/cd.zsh
. ~/.jbconfig/zsh/alias/env.zsh

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
