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
	git submodule update --init --recursive zsh/plugins/oh-my-zsh
	make link-ohmyzsh

unlink-ohmyzsh:
	if [ -L ~/.oh-my-zsh ]; then rm -rf ~/.oh-my-zsh; fi

link-ohmyzsh:
	make unlink-ohmyzsh
	ln -s ~/jbconfig/zsh/plugins/oh-my-zsh ~/.oh-my-zsh

install-antigen:
	git submodule update --init --recursive zsh/plugins/antigen
	make link-antigen

unlink-antigen:
	if [ -L ~/antigen ]; then rm -rf ~/antigen; fi

link-antigen:
	make unlink-antigen
	ln -s ~/jbconfig/zsh/plugins/antigen ~/antigen

install-powerline:
	git clone https://github.com/powerline/fonts.git --depth=1 \
	&& cd fonts \
	&& ./install.sh \
	&& cd .. \
	&& rm -rf fonts

install-maximum-awesome:
	mkdir -p ~/projects/github.com/square
	if [ ! -d ~/projects/github.com/square/maximum-awesome ]; then make clone-maximum-awesome; fi
	cd ~/projects/github.com/square/maximum-awesome \
	&& git checkout . \
	&& git pull origin master \
	&& rake

install-vimrc:
	if [ ! -d ~/.vim_runtime ]; then make clone-vimrc; fi
	cd ~/.vim_runtime \
	&& git checkout . \
	&& git pull origin master \
	&& chmod +x ./install_awesome_vimrc.sh \
	&& sh ./install_awesome_vimrc.sh

update-submodules:
	git submodule update --init --recursive

iterm2-shell-integration:
	curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

brew-i:
	brew bundle install

brew-ch:
	brew bundle check --verbose

brew-cl:
	brew bundle cleanup

.PHONY: update
update:
	@echo 'Running Update...'
	make iterm2-shell-integration
	make brew-i
	make update-submodules
	make install-fonts
	make install-nvm
	make install-hub
	make install-maximum-awesome
	make install-powerline
	make install-vimrc
	make install-ohmyzsh
	make install-antigen
