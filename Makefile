# Since we rely on paths relative to the makefile location, abort if make isn't being run from there.
$(if $(findstring /,$(MAKEFILE_LIST)),$(error Please only invoke this makefile from the directory it resides in))
	# Note: With Travis CI:
	#  - the path to urchin is passed via the command line.
	#  - the other utilities are NOT needed, so we skip the test for their existence.
URCHIN := urchin
ifeq ($(findstring /,$(URCHIN)),) # urchin path was NOT passed in.
		# Add the local npm packages' bin folder to the PATH, so that `make` can find them, when invoked directly.
		# Note that rather than using `$(npm bin)` the 'node_modules/.bin' path component is hard-coded, so that invocation works even from an environment
		# where npm is (temporarily) unavailable due to having deactivated an nvm instance loaded into the calling shell in order to avoid interference with tests.
	export PATH := $(shell printf '%s' "$$PWD/node_modules/.bin:$$PATH")
		# The list of all supporting utilities, installed with `npm install`.
	UTILS := $(URCHIN) replace semver
		# Make sure that all required utilities can be located.
	UTIL_CHECK := $(or $(shell PATH="$(PATH)" which $(UTILS) >/dev/null && echo 'ok'),$(error Did you forget to run `npm install` after cloning the repo? At least one of the required supporting utilities not found: $(UTILS)))
endif
	# The files that need updating when incrementing the version number.
VERSIONED_FILES := README.md package.json
	# Define all shells to test with. Can be overridden with `make SHELLS=... <target>`.
SHELLS := sh bash dash zsh # ksh (#574)
	# Generate 'test-<shell>' target names from specified shells.
	# The embedded shell names are extracted on demand inside the recipes.
SHELL_TARGETS := $(addprefix test-,$(SHELLS))
	# Define the default test suite(s). This can be overridden with `make TEST_SUITE=<...>  <target>`.
	# Test suites are the names of subfolders of './test'.
TEST_SUITE := $(shell find ./test/* -type d -prune -exec basename {} \;)
SHELL=/usr/local/bin/zsh
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

VERSION      ?= develop
VERSION_FILE  = ${PROJECT}/VERSION

BANNER_SEP    =$(shell printf '%*s' 70 | tr ' ' '\#')
BANNER_TEXT   =This file was autogenerated by \`make\`. Do not edit it directly!
BANNER        =${BANNER_SEP}\n\# ${BANNER_TEXT}\n${BANNER_SEP}\n

HEADER_TEXT   =\# JBConfig: A simple plugin manager for zsh\n\
\# Author: Joaquin Briceno\n\
\# Homepage: http://github.com/Joaquin6/jbconfig\n

ifeq ($(SYSTEM), Darwin)
	IS_MAC_OS=true
	FONT_PATH=$(HOME)/Library/Fonts
	libgl=-framework OpenGL -framework GLUT
else
	libgl=-lGL -lglut
endif

FONT_DROID_SANS_MONO=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete.otf

BREWCMD=$(shell which brew)
ANTIGENCMD=$(shell which antigen)

YARN_VERSION ?= 1.16.0
ADOTDIR = $(HOME)/antigen

# Default target (by virtue of being the first non '.'-prefixed in the file).
.PHONY: _no-target-specified
_no-target-specified:
	$(error Please specify the target to make - `make list` shows targets. Alternatively, use `npm test` to run the default tests; `npm run` shows all tests)

# Lists all targets defined in this makefile.
.PHONY: list
list:
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

# Set of test-<shell> targets; each runs the specified test suites for a single shell.
# Note that preexisting NVM_* variables are unset to avoid interfering with tests, except when running the Travis tests (where NVM_DIR must be passed in and the env. is assumed to be pristine).
.PHONY: $(SHELL_TARGETS)
$(SHELL_TARGETS):
	@shell='$@'; shell=$${shell##*-}; which "$$shell" >/dev/null || { printf '\033[0;31m%s\033[0m\n' "WARNING: Cannot test with shell '$$shell': not found." >&2; exit 0; } && \
	printf '\n\033[0;34m%s\033[0m\n' "Running tests in $$shell"; \
	[ -z "$$TRAVIS_BUILD_DIR" ] && for v in $$(set | awk -F'=' '$$1 ~ "^NVM_" { print $$1 }'); do unset $$v; done && unset v; \
	for suite in $(TEST_SUITE); do $(URCHIN) -f -s $$shell test/$$suite || exit; done

# All-tests target: invokes the specified test suites for ALL shells defined in $(SHELLS).
.PHONY: test
test: $(SHELL_TARGETS)

.PHONY: _ensure-tag
_ensure-tag:
ifndef TAG
	$(error Please invoke with `make TAG=<new-version> release`, where <new-version> is either an increment specifier (patch, minor, major, prepatch, preminor, premajor, prerelease), or an explicit major.minor.patch version number)
endif

# Ensures there are version tags in repository
.PHONY: _ensure-current-version

_ensure-current-version:
ifeq ($(shell git tag),$(printf ''))
	@git fetch --tags
endif

# Ensures that the git workspace is clean.
.PHONY: _ensure-clean
_ensure-clean:
	@[ -z "$$(git status --porcelain --untracked-files=no || echo err)" ] || { echo "Workspace is not clean; please commit changes first." >&2; exit 2; }

# Makes a release; invoke with `make TAG=<versionOrIncrementSpec> release`.
.PHONY: release
release: _ensure-tag _ensure-clean _ensure-current-version
	@old_ver=`git describe --abbrev=0 --tags --match 'v[0-9]*.[0-9]*.[0-9]*'` || { echo "Failed to determine current version." >&2; exit 1; }; old_ver=$${old_ver#v}; \
	new_ver=`echo "$(TAG)" | sed 's/^v//'`; new_ver=$${new_ver:-patch}; \
	if printf "$$new_ver" | grep -q '^[0-9]'; then \
		semver "$$new_ver" >/dev/null || { echo 'Invalid version number specified: $(TAG) - must be major.minor.patch' >&2; exit 2; }; \
		semver -r "> $$old_ver" "$$new_ver" >/dev/null || { echo 'Invalid version number specified: $(TAG) - must be HIGHER than current one.' >&2; exit 2; } \
	else \
		new_ver=`semver -i "$$new_ver" "$$old_ver"` || { echo 'Invalid version-increment specifier: $(TAG)' >&2; exit 2; } \
	fi; \
	printf "=== Bumping version **$$old_ver** to **$$new_ver** before committing and tagging:\n=== TYPE 'proceed' TO PROCEED, anything else to abort: " && read response && [ "$$response" = 'proceed' ] || { echo 'Aborted.' >&2; exit 2; }; \
	replace "$$old_ver" "$$new_ver" -- $(VERSIONED_FILES) && \
	git commit -m "v$$new_ver" $(VERSIONED_FILES) && \
	git tag -a "v$$new_ver"

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
	@$(MAKE) clone REPO=nvm
	if [ ! -d $(NVM_DIR) ]; then ln -sf $(GIT_USER_PATH)/nvm $(NVM_DIR); fi
	cd $(NVM_DIR); git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags  --max-count=1)`

clone-zsh-url-highlighter:
	@$(MAKE) clone REPO=zsh-url-highlighter
	mkdir -p $(ZSH)/custom/plugins
	ln -sf $(GIT_USER_PATH)/zsh-url-highlighter $(ZSH)/custom/plugins/zsh-url-highlighter

clone-zsh-autosuggestions:
	@$(MAKE) clone REPO=zsh-autosuggestions
	mkdir -p $(ZSH)/custom/plugins
	ln -sf $(GIT_USER_PATH)/zsh-autosuggestions $(ZSH)/custom/plugins/zsh-autosuggestions

install-mongo:
	curl -LO https://fastdl.mongodb.org/osx/mongodb-osx-ssl-x86_64-3.4.9.tgz
	curl -LO https://fastdl.mongodb.org/osx/mongodb-osx-ssl-x86_64-3.4.9.tgz.sig
	curl -LO https://www.mongodb.org/static/pgp/server-3.4.asc
	gpg --import server-3.4.asc
	gpg --verify mongodb-osx-ssl-x86_64-3.4.9.tgz.sig mongodb-osx-ssl-x86_64-3.4.9.tgz

install-cask:
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

install-direnv:
	@$(MAKE) clone REPO=direnv
	cd $(GIT_USER_PATH)/direnv; sudo make install

install-kubectl-plugins:
	sudo chmod +x ./tools/kubectl/plugins/kubectl-*
	sudo mv ./tools/kubectl/plugins/kubectl-* /usr/local/bin

install-nvm:
	@$(MAKE) clone-nvm
	cd $(NVM_DIR); source $(NVM_DIR)/nvm.sh

install-ohmyzsh:
	@$(MAKE) clone REPO=oh-my-zsh
	ln -sf $(GIT_USER_PATH)/oh-my-zsh $(ZSH)

install-antigen:
	@$(MAKE) clone REPO=antigen
	ln -sf $(GIT_USER_PATH)/antigen $(ADOTDIR)

update-antigen:
	cd $(ADOTDIR); git checkout . && git pull origin master && chmod +x $(ADOTDIR)/configure;
	cd $(ADOTDIR); $(ADOTDIR)/configure --with-debug;
	cd $(DIR); make refresh

install-powerline:
	@$(MAKE) clone REPO=fonts GIT_FLAGS=--depth=1
	cd $(GIT_USER_PATH)/fonts; ./install.sh

install-powerlevel9k:
	@$(MAKE) clone REPO=powerlevel9k
	cd $(GIT_USER_PATH)/powerlevel9k; git checkout . && git pull origin master
	ln -sf $(GIT_USER_PATH)/powerlevel9k $(POWERLEVEL9K_PATH)

install-maximum-awesome:
	@$(MAKE) clone REPO=maximum-awesome
	cd $(GIT_USER_PATH)/maximum-awesome; git checkout . && git pull origin master && rake

install-spaceship-prompt:
	@$(MAKE) clone REPO=spaceship-prompt
	ln -sf $(GIT_USER_PATH)/spaceship-prompt $(ZSH)/custom/themes/spaceship-prompt
	ln -sf $(GIT_USER_PATH)/spaceship-prompt/spaceship.zsh-theme $(ZSH)/custom/themes/spaceship.zsh-theme

install-vimrc:
	@$(MAKE) clone REPO=vimrc GIT_FLAGS=--depth=1
	cd $(GIT_USER_PATH)/vimrc; git checkout . && git pull origin master
	ln -sf $(GIT_USER_PATH)/vimrc $(VIMRC_RUNTIME)
	chmod +x $(VIMRC_RUNTIME)/install_awesome_vimrc.sh
	@exec $(VIMRC_RUNTIME)/install_awesome_vimrc.sh

install-zsh-url-highlighter:
	@$(MAKE) clone-zsh-url-highlighter
	mkdir -p $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters
	rm -rf $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters/url
	ln -sf $(ZSH)/custom/plugins/zsh-url-highlighter/url $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters/url

install-zsh-autosuggestions:
	@$(MAKE) clone-zsh-autosuggestions
	mkdir -p $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters
	ln -sf $(ZSH)/custom/plugins/zsh-autosuggestions/url $(HOME)/antigen/bundles/$(GIT_USERNAME)/zsh-syntax-highlighting/highlighters/url

install-rbenv:
	if [ ! -d $(HOME)/.rbenv ]; then git clone https://github.com/rbenv/rbenv.git $(HOME)/.rbenv; fi
	$(HOME)/.rbenv/src/configure
	@$(MAKE) -C $(HOME)/.rbenv/src
	val $(HOME
	cd $(DIR)
	ln -sf  benv/bin/rbenv init -

iterm2-shell-integration:
	@curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash
	@curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
	source ~/.iterm2_shell_integration.zsh

iterm2-profiles:
	if [ ! -d $(ITERM_DYNAMIC_PROFILES) ]; then mkdir -p $(ITERM_DYNAMIC_PROFILES); fi
	if [ -f $(ITERM_DYNAMIC_PROFILES)/profiles.json ]; then rm -rf $(ITERM_DYNAMIC_PROFILES)/profiles.json; fi
	ln -sf $(DIR)/tools/iterm2/profiles.json $(ITERM_DYNAMIC_PROFILES)/profiles.json

iterm2-setup:
	echo 'Running iTerm2 Setup...'
	@$(MAKE) iterm2-shell-integration
	@$(MAKE) iterm2-profiles

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
	@$(MAKE) prepare-project-directories
	if [[ $(SYSTEM) == *'Darwin'* ]]; then @$(MAKE) iterm2-setup; fi
	if [[ $(SYSTEM) == *'Darwin'* ]]; then @$(MAKE) install-brew; fi
	@$(MAKE) install-nvm
	@$(MAKE) install-vimrc
	@$(MAKE) install-ohmyzsh
	@$(MAKE) install-antigen
	@$(MAKE) install-powerline
	@$(MAKE) install-powerlevel9k
	if [[ $(SYSTEM) == *'Darwin'* ]]; then @$(MAKE) install-maximum-awesome; fi
	@$(MAKE) install-spaceship-prompt
	@$(MAKE) install-zsh-url-highlighter
	@$(MAKE) install-zsh-autosuggestions
	@$(MAKE) symlinks
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

refresh:
	chmod +x $(ADOTDIR)/antigen.zsh && source $(ADOTDIR)/antigen.zsh;
	@exec $(shell which antigen) selfupdate \
		&& antigen update \
		&& antigen cleanup \
		&& antigen reset;
	@$(MAKE) reload

ssh-keys:
	chmod +x $(DIR)/scripts/ssh/*.sh
	@exec $(DIR)/scripts/ssh/ssh-add-all.sh

redis:
	@echo
	@echo '	Making Redis...'
	@echo
	mkdir -p $(HOME)/redis \
		&& cd $(HOME)/redis \
		&& curl -O http://download.redis.io/redis-stable.tar.gz \
		&& tar xvzf redis-stable.tar.gz \
		&& cd redis-stable \
		&& make \
		&& sudo make install
	cd $(DIR)
	@echo
	@echo '	Redis Successfully Installed, Built and Tested...'
	@echo '	For help: https://auth0.com/blog/introduction-to-redis-install-cli-commands-and-data-types/'
	@echo

haskell:
	curl https://get-ghcup.haskell.org -sSf | sh

reload:
	@exec $(SHELL) -l
