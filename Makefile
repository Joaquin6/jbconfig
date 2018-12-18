SHELL=/bin/zsh

LDFLAGS = $(libgl) -lpng -lz -lm

ifeq ($(shell uname -s), Darwin)
	libgl = -framework OpenGL -framework GLUT
else
	libgl = -lGL -lglut
endif

clone-hub:
	git clone \
	--config transfer.fsckobjects=false \
	--config receive.fsckobjects=false \
	--config fetch.fsckobjects=false \
	https://github.com/github/hub.git ~/projects/go/src/github.com/github/hub

clone-maximum-awesome:
	git clone \
	https://github.com/square/maximum-awesome.git ~/projects/go/src/github.com/square/maximum-awesome

clone-vimrc:
	git clone \
	--depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime

clone-zsh-url-highlighter:
	mkdir -p ~/.oh-my-zsh/custom/plugins
	git clone \
	git@github.com:ascii-soup/zsh-url-highlighter.git ~/.oh-my-zsh/custom/plugins/zsh-url-highlighter

install-hub:
	mkdir -p ~/projects/go/src/github.com/github
	if [ ! -d ~/projects/go/src/github.com/github/hub ]; then make clone-hub; fi
	cd ~/projects/go/src/github.com/github/hub \
	&& sudo gem install bundler \
	&& rbenv rehash \
	&& make install prefix=/usr/local

install-fonts:
	cd ~/Library/Fonts \
	&& curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" \
	https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf \
	&& cd ~/jbconfig

install-nvm:
	if [ ! -d ~/.nvm ]; then git clone https://github.com/creationix/nvm.git ~/.nvm; fi
	cd ~/.nvm \
	&& git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` \
	&& . ~/.nvm/nvm.sh \
	&& cd ~/jbconfig

install-ohmyzsh:
	if [ ! -d ~/.oh-my-zsh ]; then git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh; fi

install-antigen:
	if [ ! -d ~/.antigen ]; then git clone https://github.com/zsh-users/antigen.git ~/.antigen; fi

install-powerline:
	git clone https://github.com/powerline/fonts.git --depth=1 \
	&& cd fonts \
	&& ./install.sh \
	&& cd .. \
	&& rm -rf fonts

install-powerlevel9k:
	if [ ! -d ~/powerlevel9k ]; then git clone https://github.com/bhilburn/powerlevel9k.git ~/powerlevel9k; fi

install-maximum-awesome:
	mkdir -p ~/projects/github.com/square
	if [ ! -d ~/projects/github.com/square/maximum-awesome ]; then make clone-maximum-awesome; fi
	cd ~/projects/github.com/square/maximum-awesome \
	&& git checkout . \
	&& git pull origin master \
	&& rake

install-spaceship-prompt:
	if [ ! -d ~/.oh-my-zsh/custom/themes/spaceship-prompt ]; then git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt; fi
	if [ ! -L ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme ]; then ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme; fi

install-vimrc:
	if [ ! -d ~/.vim_runtime ]; then make clone-vimrc; fi
	cd ~/.vim_runtime \
	&& git checkout . \
	&& git pull origin master \
	&& chmod +x ./install_awesome_vimrc.sh \
	&& sh ./install_awesome_vimrc.sh

install-zsh-url-highlighter:
	if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-url-highlighter ]; then make clone-zsh-url-highlighter; fi
	mkdir -p ~/.antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters
	if [ ! -L ~/.antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters/url ]; then ln -s ~/.oh-my-zsh/custom/plugins/zsh-url-highlighter ~/.antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters; fi

update-submodules:
	git submodule update --init --recursive

iterm2-shell-integration:
	curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

brew-i:
	brew bundle install --file=./tools/brew/$(shell uname -s)/Brewfile

brew-ch:
	brew bundle check --file=./tools/brew/$(shell uname -s)/Brewfile --verbose

brew-cl:
	brew bundle cleanup --file=./tools/brew/$(shell uname -s)/Brewfile

.PHONY: update
update:
	@echo 'Running Update...'
	make iterm2-shell-integration
	make brew-i
	make install-nvm
	make install-hub
	make install-fonts
	make install-vimrc
	make install-ohmyzsh
	make install-antigen
	make install-powerline
	make install-powerlevel9k
	make install-maximum-awesome
	make install-spaceship-prompt
	make install-zsh-url-highlighter
