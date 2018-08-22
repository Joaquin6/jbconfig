####################################################################################################
############################################# ALIASES ##############################################
####################################################################################################

# Set JB_ZSH_BASE if it isn't already defined
[[ -z $JB_ZSH_BASE ]] && export JB_ZSH_BASE=~/.jbconfig




############################################### npm ################################################
(( $+commands[npm] )) && {
    __NPM_COMPLETION_FILE="${ZSH_CACHE_DIR:-$ZSH/cache}/npm_completion"

    if [[ ! -f $__NPM_COMPLETION_FILE ]]; then
        npm completion >! $__NPM_COMPLETION_FILE 2>/dev/null
        [[ $? -ne 0 ]] && rm -f $__NPM_COMPLETION_FILE
    fi

    [[ -f $__NPM_COMPLETION_FILE ]] && source $__NPM_COMPLETION_FILE

    unset __NPM_COMPLETION_FILE
}
# npm package names are lowercase
# Thus, we've used camelCase for the following aliases:
alias npmg="npm i -g " 						# Install dependencies globally
alias npmO="npm outdated" 					# Check which npm modules are outdated
alias npmV="npm -v" 						# Check package versions
alias npmL="npm list" 						# List packages
alias npmL0="npm ls --depth=0" 				# List top-level installed packages
alias npmst="npm start" 					# Run npm start
alias npmt="npm test" 						# Run npm test
alias npmR="npm run" 						# Run npm scripts
alias npmP="npm publish" 					# Run npm publish
alias npmI="npm init" 						# Run npm init
alias npmS="npm i -S " 						# Install and save to dependencies in your package.json
											# 	npms is used by https://www.npmjs.com/package/npms
alias npmD="npm i -D " 						# Install and save to dev-dependencies in your package.json
											# 	npmd is used by https://github.com/dominictarr/npmd
alias npmE='PATH="$(npm bin)":"$PATH"' 		# Execute command from node_modules folder based on current directory
											# 	i.e npmE gulp




######################################### docker-compose ###########################################
# Docker-compose related zsh aliases
# Use dco as alias for docker-compose, since dc on *nix is 'dc - an arbitrary precision calculator'
# https://www.gnu.org/software/bc/manual/dc-1.05/html_mono/dc.html
alias dco='docker-compose'
alias dcb='docker-compose build'
alias dce='docker-compose exec'
alias dcps='docker-compose ps'
alias dcrestart='docker-compose restart'
alias dcrm='docker-compose rm'
alias dcr='docker-compose run'
alias dcstop='docker-compose stop'
alias dcup='docker-compose up'
alias dcdn='docker-compose down'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'
alias dcpull='docker-compose pull'
alias dcstart='docker-compose start'




############################################# editor ###############################################
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshrc='$EDITOR ~/.zshrc'
alias zshversion='echo ${ZSH_PATCHLEVEL}'
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias ohmyzshconfig="$EDITOR ~/.oh-my-zsh"




############################################### ls #################################################
# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias lh='ls -a | egrep "^\."' #all hidden files
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
#   ---------------------------
#   NETWORKING
#   ---------------------------
alias net-cons='lsof -i'                            # netCons:      Show all open TCP/IP sockets
alias open-ports='sudo lsof -i | grep LISTEN'       # openPorts:    All listening connections
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets




############################################### cd #################################################
cd() { builtin cd "$@"; ll; }         # Always list directory contents upon 'cd'
alias cd..='cd ../'               # Go back 1 directory level (for fast typers)
alias ..='cd ../'                             # Go back 1 directory level
alias ...='cd ../../'                         # Go back 2 directory levels
alias .3='cd ../../../'                       # Go back 3 directory levels
alias .4='cd ../../../../'                    # Go back 4 directory levels
alias .5='cd ../../../../../'                 # Go back 5 directory levels
alias .6='cd ../../../../../../'              # Go back 6 directory levels
alias edit=$EDITOR               # edit:     Opens any file in sublime editor
alias ~="cd ~"                              # ~:            Go Home




############################################## env #################################################
alias c='clear'                               # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'           # path:         Echo all executable Paths
alias f_path='echo -e ${fpath//:/\\n}'        # fpath:        Echo all executable fpaths
alias cd_path='echo -e ${cdpath//:/\\n}'        # cdpath:        Echo all executable cdpaths
alias UN='echo $USER'             # UN:     Echo Username
alias qfind="find . -name "                 # qfind:    Quickly search for file




############################################## env #################################################
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

# sort files in current directory by the number of words they contain
alias wordy='wc -w * | sort | tail -n10'

# $ gp ruby
# (all ruby process will be displayed)
# creates a global alias for grep
alias -g gp='ps ax | grep -i'
alias p='ps -f'

alias -g hist='history | grep -i'
alias h='history'

alias hgrep="fc -El 0 | grep"
alias help='man'

alias show_node_processes='ps -a | grep node';

#   ---------------------------
#   6. NETWORKING
#   ---------------------------

alias flush-DNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias ip-info0='ipconfig getpacket en0'              # ip-info0:      Get info on connections for en0
alias ip-info1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias show-blocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# https://rtyley.github.io/bfg-repo-cleaner/
alias bfg='java -jar /usr/local/bin/bfg-1.13.0.jar'

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'