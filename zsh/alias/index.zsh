
alias zshversion='echo ${ZSH_PATCHLEVEL}'
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias ohmyzshconfig="$EDITOR ~/.oh-my-zsh"

zshrc() {
	local editor=${EDITOR:-code}

	if [ -f "$JB_ZSH_BASE/zsh/base" ]; then
		$editor $JB_ZSH_BASE/zsh/base
	elif [ -f "$HOME/.zshrc" ]; then
		$editor $HOME/.zshrc
	else
		echo "\n\tCant find an zshrc file!"
	fi
}


#   -----------------------------
#   2. MAKE TERMINAL BETTER
#   -----------------------------

# Detect which `ls` flavor is in use.
# List all files colorized in long format, including dot files
if ls --color > /dev/null 2>&1; then
  colorflag="--color" # GNU `ls`
else
  colorflag="-G"      # OS X `ls`
fi

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh --color=always --group-directories-first'
alias la='ls -lAFh ${colorflag}'
alias lr='ls -tRFh'
alias lt='ls -ltFh'
alias ll='ls -l'
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias lh='ls -a | egrep "^\."'
alias llgf='ls -GFlAhp'
alias lla='ls -la'
alias lsg='ls -GFh'
alias lrtg='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias filecount='ls -aRF | wc -l'
alias sl=ls
alias lsc='colorls'
alias lc='colorls -lA --sd'

alias ~="cd ~"                          # Go Home
alias cd..='cd ../'               		# Go back 1 directory level
alias ..='cd ../'                       # Go back 1 directory level
alias ...='cd ../../'                   # Go back 2 directory levels
alias .3='cd ../../../'                 # Go back 3 directory levels
alias .4='cd ../../../../'              # Go back 4 directory levels
alias .5='cd ../../../../../'           # Go back 5 directory levels
alias .6='cd ../../../../../../'        # Go back 6 directory levels
cd() { builtin cd "$@"; ls -l; }        # Always list directory contents upon 'cd'

alias edit='code'		                # edit:     Opens any file in vscode
alias c='clear'                               # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'           # path:         Echo all executable Paths
alias show_options='shopt'                    # Show_options: display bash options settings
alias fix_stty='stty sane'                    # fix_stty:     Restore terminal settings when screwed up
mkcd() { mkdir -p "$@" && cd "$@"; }          # mkcd:          Makes new Dir and jumps inside
alias UN='echo $USER'

alias vsc='code .'
alias vscl='code --log'
alias vsca='code --add'
alias vscd='code --diff'
alias vscg='code --goto'
alias vscw='code --wait'
alias vscv='code --verbose'
alias vscn='code --new-window'
alias vscr='code --reuse-window'
alias vscu='code --user-data-dir'
alias vscext='code --extensions-dir'
alias vscexti='code --install-extension'
alias vscextd='code --disable-extensions'
alias vscextu='code --uninstall-extension'




#   ---------------------------
#   4. NETWORKING
#   ---------------------------
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs


############################################# docker ###############################################
alias docker-clean-unused='docker system prune --all --force --volumes'
alias docker-clean-all='docker stop $(docker container ls -a -q) && docker system prune -a -f --volumes'
alias docker-clean-containers='docker container stop $(docker container ls -a -q) && docker container rm $(docker container ls -a -q)'

drm() { docker rm $(docker ps -a | grep $1 | awk '{print $1}') ; }
# docker rm $(docker ps -a | grep "46 hours ago")
drmt() { docker rm $(docker ps -a | grep "$1") ; }

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



#   ---------------------------------------
#   5. SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

#   cleanupDS:  Recursively delete .DS_Store files
# 	cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -------------------------------------------------------------------
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"
alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   enableWorkspaceAutoswitch:   	Add workspace auto-switching
#   disableWorkspaceAutoswitch:   	Remove workspace auto-switching
#   -------------------------------------------------------------------
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'
alias enableWorkspaceAutoswitch='defaults write com.apple.dock workspaces-auto-swoosh YES'
alias disableWorkspaceAutoswitch='defaults write com.apple.dock workspaces-auto-swoosh NO'

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
