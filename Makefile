SHELL=/bin/zsh
SYSTEM=$(shell uname -s)
HOMEBREW_PREFIX=$(shell brew --prefix)
DIR=${HOME}/jbconfig
LDFLAGS = $(libgl) -lpng -lz -lm
PROJECTS=$(HOME)/projects
GOPATH=$(PROJECTS)/go
GITHUBGOPATH=$(GOPATH)/src/github.com
BITBUCKETPATH=$(PROJECTS)/bitbucket.org
GITHUBPATH=$(PROJECTS)/github.com
GITLABPATH=$(PROJECTS)/gitlab.com
GIT_USERNAME=Joaquin6
GIT_USER_PATH=$(GITHUBPATH)/$(GIT_USERNAME)
FONT_PATH=$(HOME)/.local/share/fonts
NVM_DIR=$(HOME)/.nvm
SSHGIT=git@github.com:$(GIT_USERNAME)
HTTPSGIT=https://github.com/$(GIT_USERNAME)
ITERM_SUPPORT=$(HOME)/Library/Application\ Support/iTerm2
ITERM_SCRIPTS=$(ITERM_SUPPORT)/scripts
ITERM_DYNAMIC_PROFILES=$(ITERM_SUPPORT)/DynamicProfiles
DIRENV_USER_PATH=$(GIT_USER_PATH)/direnv
OMZ_USER_PATH=$(GIT_USER_PATH)/oh-my-zsh
ZSH=$(HOME)/.oh-my-zsh
ANTIGEN_USER_PATH=$(GIT_USER_PATH)/antigen
ADOTDIR=$(HOME)/antigen
POWERLINE_USER_PATH=$(GIT_USER_PATH)/powerline
POWERLEVEL9K_PATH=$(HOME)/powerlevel9k
POWERLEVEL9K_USER_PATH=$(GIT_USER_PATH)/powerlevel9k
VIMRC_USER_PATH=$(GIT_USER_PATH)/vimrc
VIMRC_RUNTIME=$(HOME)/.vim_runtime
MAXIMUM_AWESOME_USER_PATH=$(GIT_USER_PATH)/maximum-awesome
IS_MAC_OS=false

ifeq ($(SYSTEM), Darwin)
	IS_MAC_OS=true
	FONT_PATH=$(HOME)/Library/Fonts
	libgl=-framework OpenGL -framework GLUT
else
	libgl=-lGL -lglut
endif

FONT_DROID_SANS_MONO=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete.otf

BREWCMD=$(shell which brew)

YARN_VERSION ?= 1.16.0

default: update

show-env:
	@echo $(YARN_VERSION)

symlinks:
	@ln -sf $(DIR)/zsh/.zlogin $(HOME)/.zlogin
	@ln -sf $(DIR)/zsh/.zlogout $(HOME)/.zlogout
	@ln -sf $(DIR)/zsh/.zprofile $(HOME)/.zprofile
	@ln -sf $(DIR)/zsh/alias/index.zsh $(HOME)/.zaliases
	@ln -sf $(DIR)/zsh/functions.zsh $(HOME)/.zfunctions
	@ln -sf $(DIR)/zsh/.zshenv $(HOME)/.zshenv
	@ln -sf $(DIR)/zsh/.zshrc $(HOME)/.zshrc

prepare-project-directories:
	mkdir -p $(GITHUBPATH)
	mkdir -p $(GITLABPATH)
	mkdir -p $(BITBUCKETPATH)
	mkdir -p $(GITHUBGOPATH)

clone:
	mkdir -p $(GIT_USER_PATH);
	if [ ! -d $(GIT_USER_PATH)/$(REPO) ]; then git clone $(SSHGIT)/$(REPO).git $(GIT_USER_PATH)/$(REPO) $(GIT_FLAGS); fi

clone-nvm:
	make clone REPO=nvm
	if [ ! -d $(NVM_DIR) ]; then ln -sf $(GIT_USER_PATH)/nvm $(NVM_DIR); fi
	cd $(NVM_DIR); git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags  --max-count=1)`

clone-zsh-url-highlighter:
	make clone REPO=zsh-url-highlighter
	mkdir -p $(ZSH)/custom/plugins
	ln -sf $(GIT_USER_PATH)/zsh-url-highlighter $(ZSH)/custom/plugins/zsh-url-highlighter

clone-zsh-autosuggestions:
	make clone REPO=zsh-autosuggestions
	mkdir -p $(ZSH)/custom/plugins
	ln -sf $(GIT_USER_PATH)/zsh-autosuggestions $(ZSH)/custom/plugins/zsh-autosuggestions

install-cask:
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

install-direnv:
	make clone REPO=direnv
	cd $(GIT_USER_PATH)/direnv; sudo make install

install-kubectl-plugins:
	sudo chmod +x ./tools/kubectl/plugins/kubectl-*
	sudo mv ./tools/kubectl/plugins/kubectl-* /usr/local/bin

install-nvm:
	make clone-nvm
	cd $(NVM_DIR); source $(NVM_DIR)/nvm.sh

install-ohmyzsh:
	make clone REPO=oh-my-zsh
	ln -sf $(GIT_USER_PATH)/oh-my-zsh $(ZSH)

install-antigen:
	make clone REPO=antigen
	ln -sf $(GIT_USER_PATH)/antigen $(ADOTDIR)

install-powerline:
	make clone REPO=fonts GIT_FLAGS=--depth=1
	cd $(GIT_USER_PATH)/fonts; ./install.sh

install-powerlevel9k:
	make clone REPO=powerlevel9k
	cd $(GIT_USER_PATH)/powerlevel9k; git checkout . && git pull origin master
	ln -sf $(GIT_USER_PATH)/powerlevel9k $(POWERLEVEL9K_PATH)

install-maximum-awesome:
	make clone REPO=maximum-awesome
	cd $(GIT_USER_PATH)/maximum-awesome; git checkout . && git pull origin master && rake

install-spaceship-prompt:
	make clone REPO=spaceship-prompt
	ln -sf $(GIT_USER_PATH)/spaceship-prompt $(ZSH)/custom/themes/spaceship-prompt
	ln -sf $(GIT_USER_PATH)/spaceship-prompt/spaceship.zsh-theme $(ZSH)/custom/themes/spaceship.zsh-theme

install-vimrc:
	make clone REPO=vimrc GIT_FLAGS=--depth=1
	cd $(GIT_USER_PATH)/vimrc; git checkout . && git pull origin master
	ln -sf $(GIT_USER_PATH)/vimrc $(VIMRC_RUNTIME)
	chmod +x $(VIMRC_RUNTIME)/install_awesome_vimrc.sh
	@exec $(VIMRC_RUNTIME)/install_awesome_vimrc.sh

install-zsh-url-highlighter:
	make clone-zsh-url-highlighter
	mkdir -p $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters
	rm -rf $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters/url
	ln -s $(ZSH)/custom/plugins/zsh-url-highlighter/url $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters/url

install-zsh-autosuggestions:
	make clone-zsh-autosuggestions
	mkdir -p $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters
	ln -sf $(ZSH)/custom/plugins/zsh-autosuggestions/url $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters/url

install-rbenv:
	if [ ! -d $(HOME)/.rbenv ]; then git clone https://github.com/rbenv/rbenv.git $(HOME)/.rbenv; fi
	$(HOME)/.rbenv/src/configure
	make -C $(HOME)/.rbenv/src
	eval $(HOME)/.rbenv/bin/rbenv init -
	cd $(DIR)

iterm2-shell-integration:
	curl -L https://iterm2.com/shell_integration/bash -o $(HOME)/.iterm2_shell_integration.bash
	curl -L https://iterm2.com/shell_integration/zsh -o $(HOME)/.iterm2_shell_integration.zsh
	source $(HOME)/.iterm2_shell_integration.zsh

iterm2-profiles:
	if [ ! -d $(ITERM_DYNAMIC_PROFILES) ]; then mkdir -p $(ITERM_DYNAMIC_PROFILES); fi
	if [ -f $(ITERM_DYNAMIC_PROFILES)/profiles.json ]; then rm -rf $(ITERM_DYNAMIC_PROFILES)/profiles.json; fi
	ln -sf $(DIR)/tools/iterm2/profiles.json $(ITERM_DYNAMIC_PROFILES)/profiles.json

iterm2-setup:
	echo 'Running iTerm2 Setup...'
	make iterm2-shell-integration
	make iterm2-profiles

install-brew:
	@exec $(BREWCMD) bundle install --file=./tools/brew/$(SYSTEM)/Brewfile

brew-check:
	@exec $(BREWCMD) bundle check --file=./tools/brew/$(SYSTEM)/Brewfile --verbose

brew-clean:
	@exec $(BREWCMD) bundle cleanup --file=./tools/brew/$(SYSTEM)/Brewfile

.PHONY: update
update:
	@echo
	@echo '	Running Update...'
	@echo
	make prepare-project-directories
	if [[ $(SYSTEM) == *'Darwin'* ]]; then make iterm2-setup; fi
	make install-brew
	make install-nvm
	make install-vimrc
	make install-direnv
	make install-ohmyzsh
	make install-antigen
	make install-powerline
	make install-powerlevel9k
	if [[ $(SYSTEM) == *'Darwin'* ]]; then make install-maximum-awesome; fi
	make install-spaceship-prompt
	make install-zsh-url-highlighter
	make install-zsh-autosuggestions
	make symlinks
	@echo
	@echo '	Updated succesfully!...'
	@echo

yarn:
	sudo mkdir -p /opt \
		&& cd /opt \
		&& sudo wget https://yarnpkg.com/latest.tar.gz
	wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --import \
		&& wget https://yarnpkg.com/latest.tar.gz.asc \
		&& gpg --verify latest.tar.gz.asc
	sudo tar zvxf latest.tar.gz