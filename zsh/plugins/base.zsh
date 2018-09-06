

if [ ! -d $HOME/antigen ]; then
	mkdir -p $HOME/antigen
	git clone https://github.com/zsh-users/antigen.git $HOME/antigen
fi

if [ ! -d $HOME/.oh-my-zsh ]; then
	mkdir -p $HOME/.oh-my-zsh
	git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi


-load-syntax-highlighting

source $HOME/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh



# Which plugins would you like to load? (plugins can be found in $HOME/.oh-my-zsh/plugins/*)
# Custom plugins may be added to $HOME/.oh-my-zsh/custom/plugins/
antigen bundles <<EOBUNDLES
	autoenv
	battery
	command-not-found
	dotenv
	history
	history-substring-search
	sudo
	gpg-agent
	ssh-agent
	jsontools
	profiles
	git
	node
	nvm
	npm
	npx
	yarn
	gnu-utils
	cygwin
	debian
	systemd
	systemadmin
EOBUNDLES

# OS specific plugins
if [[ $CURRENT_OS == 'OS X' || $OSTYPE == darwin* ]]; then
	antigen bundle iterm2
	antigen bundle gem
	antigen bundle osx
	antigen bundle brew
	antigen bundle cask
	if [[ $DISTRO == 'CentOS' || $CURRENT_OS == 'CentOS' || $OSTYPE == centos* ]]; then
		antigen bundle centos
	fi
elif [[ $CURRENT_OS == 'Linux' || $OSTYPE == linux* ]]; then
	antigen bundle brew
	antigen bundle cask
	if [[ $DISTRO == 'CentOS' || $CURRENT_OS == 'CentOS' || $OSTYPE == centos* ]]; then
		antigen bundle centos
	fi
fi

antigen bundle zsh-users/zsh-syntax-highlighting      			# https://github.com/zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search 			# https://github.com/zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions          			# https://github.com/zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions										# https://github.com/zsh-users/zsh-completions
antigen bundle djui/alias-tips        											# https://github.com/djui/alias-tips
antigen bundle Joaquin6/git-aliases   											# https://github.com/Joaquin6/git-aliases
antigen bundle jocelynmallon/zshmarks 											# https://github.com/jocelynmallon/zshmarks
antigen bundle ascii-soup/zsh-url-highlighter								# https://github.com/ascii-soup/zsh-url-highlighter
# antigen bundle denysdovhan/spaceship-prompt 								# https://github.com/denysdovhan/spaceship-prompt

# if [ -d $DOCKER_ETC_CONTENTS ]; then
# 	ln -s $DOCKER_ETC_CONTENTS/docker.zsh-completion $USER_LOCAL_SHARE/zsh/site-functions/_docker
# 	ln -s $DOCKER_ETC_CONTENTS/docker-machine.zsh-completion $USER_LOCAL_SHARE/zsh/site-functions/_docker-machine
# 	ln -s $DOCKER_ETC_CONTENTS/docker-compose.zsh-completion $USER_LOCAL_SHARE/zsh/site-functions/_docker-compose
# fi
-load-url-highlighter
# antigen theme powerlevel9k
# Suuply the theme - https://denysdovhan.com/spaceship-prompt/
# antigen theme spaceship
# antigen theme spaceship
# https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions
# https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/API.md
# antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship
# Tell antigen that you're done.
antigen apply
