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

clone-direnv:
	mkdir -p $(GIT_USER_PATH)
	if [ ! -d $(DIRENV_USER_PATH) ]; then git clone $(SSHGIT)/direnv.git $(DIRENV_USER_PATH); fi

clone-nvm:
	if [ ! -d $(NVM_DIR) ]; then git clone https://github.com/creationix/nvm.git $(NVM_DIR); fi
	cd $(NVM_DIR) \
		&& git checkout \
			`git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags  --max-count=1)` \
		&& cd $(DIR)

clone-hub:
	mkdir -p $(GITHUBGOPATH)/github
	git clone \
	  --config transfer.fsckobjects=false \
	  --config receive.fsckobjects=false \
	  --config fetch.fsckobjects=false \
	  https://github.com/github/hub.git $(GITHUBGOPATH)/github/hub
	cd $(GITHUBGOPATH)/github/hub
	make install prefix=/usr/local

clone-antigen:
	mkdir -p $(GIT_USER_PATH)
	if [ ! -d $(ANTIGEN_USER_PATH) ]; then git clone $(SSHGIT)/antigen.git $(ANTIGEN_USER_PATH); fi

clone-ohmyzsh:
	mkdir -p $(GIT_USER_PATH)
	if [ ! -d $(OMZ_USER_PATH) ]; then git clone $(SSHGIT)/oh-my-zsh.git $(OMZ_USER_PATH); fi

clone-powerline:
	mkdir -p $(GIT_USER_PATH)
	if [ ! -d $(POWERLINE_USER_PATH) ]; then git clone $(SSHGIT)/fonts.git --depth=1 $(POWERLINE_USER_PATH); fi

clone-powerlevel9k:
	mkdir -p $(GIT_USER_PATH)
	if [ ! -d $(POWERLEVEL9K_USER_PATH) ]; then git clone $(SSHGIT)/powerlevel9k.git $(POWERLEVEL9K_USER_PATH); fi

clone-maximum-awesome:
	mkdir -p $(GIT_USER_PATH)
	if [ ! -d $(MAXIMUM_AWESOME_USER_PATH) ]; then git clone $(SSHGIT)/maximum-awesome.git $(MAXIMUM_AWESOME_USER_PATH); fi

clone-vimrc:
	mkdir -p $(GIT_USER_PATH)
	if [ ! -d $(VIMRC_USER_PATH) ]; then git clone $(SSHGIT)/vimrc.git --depth=1 $(VIMRC_USER_PATH); fi

clone-zsh-url-highlighter:
	mkdir -p $(ZSH)/custom/plugins
	git clone \
	git@github.com:ascii-soup/zsh-url-highlighter.git $(ZSH)/custom/plugins/zsh-url-highlighter

clone-zsh-autosuggestions:
	mkdir -p $(GIT_USER_PATH)
	git clone $(SSHGIT)/zsh-autosuggestions.git $(GIT_USER_PATH)/zsh-autosuggestions
	mkdir -p $(ZSH)/custom/plugins
	ln -sf $(GIT_USER_PATH)/zsh-autosuggestions $(ZSH)/custom/plugins/zsh-autosuggestions

clone-spaceship-prompt:
	mkdir -p $(GIT_USER_PATH)
	if [ ! -d $(GIT_USER_PATH)/spaceship-prompt ]; then git clone $(SSHGIT)/spaceship-prompt.git $(GIT_USER_PATH)/spaceship-prompt; fi

install-cask:
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

install-direnv:
	make clone-direnv
	cd $(DIRENV_USER_PATH) \
		&& sudo make install \
		&& cd $(DIR)

install-hub:
	mkdir -p $(PROJECTS)/go/src/github.com/github
	if [ ! -d $(PROJECTS)/go/src/github.com/github/hub ]; then make clone-hub; fi
	cd $(PROJECTS)/go/src/github.com/github/hub \
	&& sudo gem install bundler
	$(exec $(shell which rbenv) rehash)

install-eksctl:
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/eksctl /usr/local/bin

install-kubectl:
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl

install-kubectl-plugins:
	sudo chmod +x ./tools/kubectl/plugins/kubectl-*
	sudo mv ./tools/kubectl/plugins/kubectl-* /usr/local/bin

install-minikube:
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
	chmod +x minikube
	sudo mv minikube /usr/local/bin

install-fonts:
	@mkdir -p $(FONT_PATH)
	@cd $(FONT_PATH)
	@curl -fLo $(FONT_DROID_SANS_MONO) \
		https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
	@mv $(FONT_DROID_SANS_MONO) $(FONT_PATH)/

install-nvm:
	make clone-nvm
	@cd $(NVM_DIR)
	@source $(NVM_DIR)/nvm.sh
	@cd $(DIR)

install-ohmyzsh:
	make clone-ohmyzsh
	if [ ! -L $(ZSH) ]; then ln -sf $(OMZ_USER_PATH) $(ZSH); fi

install-antigen:
	make clone-antigen
	if [ ! -L $(ADOTDIR) ]; then ln -sf $(ANTIGEN_USER_PATH) $(ADOTDIR); fi

install-powerline:
	make clone-powerline
	cd $(POWERLINE_USER_PATH) && ./install.sh

install-powerlevel9k:
	make clone-powerlevel9k
	cd $(POWERLEVEL9K_USER_PATH) \
		&& git checkout . \
		&& git pull origin master \
		&& ln -sf $(POWERLEVEL9K_USER_PATH) $(POWERLEVEL9K_PATH)

install-maximum-awesome:
	make clone-maximum-awesome
	cd $(MAXIMUM_AWESOME_USER_PATH) \
		&& git checkout . \
		&& git pull origin master \
		&& rake \
		&& cd $(DIR)

install-spaceship-prompt:
	make clone-spaceship-prompt
	if [ ! -d $(ZSH)/custom/themes/spaceship-prompt ]; then ln -sf $(GIT_USER_PATH)/spaceship-prompt $(ZSH)/custom/themes/spaceship-prompt; fi
	if [ ! -f $(ZSH)/custom/themes/spaceship.zsh-theme ]; then ln -sf $(GIT_USER_PATH)/spaceship-prompt/spaceship.zsh-theme $(ZSH)/custom/themes/spaceship.zsh-theme; fi

install-vimrc:
	make clone-vimrc
	cd $(VIMRC_USER_PATH) \
		&& git checkout . \
		&& git pull origin master \
		&& cd $(DIR) \
		&& ln -sf $(VIMRC_USER_PATH) $(VIMRC_RUNTIME) \
		&& chmod +x $(VIMRC_RUNTIME)/install_awesome_vimrc.sh
	$(exec $(VIMRC_RUNTIME)/install_awesome_vimrc.sh)

install-zsh-url-highlighter:
	if [ ! -d $(ZSH)/custom/plugins/zsh-url-highlighter ]; then make clone-zsh-url-highlighter; fi
	mkdir -p $(HOME)/antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters
	rm -rf $(HOME)/antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters/url
	if [ ! -L $(HOME)/antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters/zsh-url-highlighter ]; then ln -s $(ZSH)/custom/plugins/zsh-url-highlighter/url $(HOME)/antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters/url; fi

install-zsh-autosuggestions:
	if [ ! -d $(ZSH)/custom/plugins/zsh-autosuggestions ]; then make clone-zsh-autosuggestions; fi
	mkdir -p $(HOME)/antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters
	ln -sf $(ZSH)/custom/plugins/zsh-autosuggestions/url $(HOME)/antigen/bundles/zsh-users/zsh-syntax-highlighting/highlighters/url

install-rbenv:
	if [ ! -d $(HOME)/.rbenv ]; then git clone https://github.com/rbenv/rbenv.git $(HOME)/.rbenv; fi
	$(HOME)/.rbenv/src/configure
	make -C $(HOME)/.rbenv/src
	eval $(HOME)/.rbenv/bin/rbenv init -
	cd $(DIR)

iterm2-shell-integration:
	@curl -L https://iterm2.com/shell_integration/bash -o $(HOME)/.iterm2_shell_integration.bash
	@curl -L https://iterm2.com/shell_integration/zsh -o $(HOME)/.iterm2_shell_integration.zsh
	@source $(HOME)/.iterm2_shell_integration.zsh

iterm2-profiles:
	if [ ! -d $(ITERM_DYNAMIC_PROFILES) ]; then mkdir -p $(ITERM_DYNAMIC_PROFILES); fi
	if [ -f $(ITERM_DYNAMIC_PROFILES)/profiles.json ]; then rm -rf $(ITERM_DYNAMIC_PROFILES)/profiles.json; fi
	@ln -sf $(DIR)/tools/iterm2/profiles.json $(ITERM_DYNAMIC_PROFILES)/profiles.json

iterm2-setup:
	echo 'Running iTerm2 Setup...'
	make iterm2-shell-integration
	make iterm2-profiles

brew-install:
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
	@$(ifeq ($(strip $(SYSTEM)), Darwin) make iterm2-setup endif)
	make brew-i
	make install-nvm
	make install-hub
	make install-fonts
	make install-vimrc
	make install-direnv
	make install-ohmyzsh
	make install-antigen
	make install-powerline
	make install-powerlevel9k
	@$(ifeq ($(strip $(SYSTEM)), Darwin) make install-maximum-awesome endif)
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