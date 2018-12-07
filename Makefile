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

iterm2-shell-integration:
	curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

brew-i:
	brew bundle install

brew-ch:
	brew bundle check --verbose

brew-cl:
	brew bundle cleanup

update:
	make iterm2-shell-integration
	make brew-i
	make install-fonts
	make install-nvm
  make install-hub
