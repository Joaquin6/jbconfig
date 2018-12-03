#!/bin/sh

source ~/.nvm/nvm.sh

set -e # Exit on first error


RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

NODE_CARBON='9.11.2'
NODE_LTS='10.14.1'

SUBMODULES=('zsh/plugins/antigen' 'zsh/plugins/prezto' 'zsh/plugins/oh-my-zsh' 'zsh/themes/spaceship-prompt')

update_submodules() {
	check_args $@

	if [ ! -z $JB_CONFIG_DEBUG ]; then echo "\n\n"; fi

	check_deps
	print_versions

	LANG=C
	LC_CTYPE=C

	logger "Executing Submodule Updates..."

	switch_node_version $NODE_CARBON
	wait

	global_installs

	run_updates

	switch_node_version $NODE_LTS

	logger "Successfully Updated Submodules..."

	echo "\n\n"
}

check_args() {
	while [ $# -gt 0 ]; do
		case "$1" in
            --debug) JB_CONFIG_DEBUG="true" ;;
            -D) JB_CONFIG_DEBUG="true"
		esac
		shift
	done
}

check_deps() {
	logger "Checking dependencies..."
	check_dep git "Go to https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
	check_dep nvm "Go to https://github.com/creationix/nvm"
	check_dep npm "Go to https://www.npmjs.com/get-npm"
	check_dep yarn "brew install yarn"
}

check_dep() {
	local DEP=$1
	local HOW_TO_INSTALL="$2"

	if ! [ -x $(command -v $DEP) ]; then
		local inst_intro="${RED}Error:${NO_COLOR} ${GREEN}${DEP}${NO_COLOR} is not installed."
		echo "${inst_intro}\n\t${HOW_TO_INSTALL}"
		if [ ! -z $JB_CONFIG_DEBUG ]; then echo "\n\n"; fi
		exit 1
	fi
}

print_versions() {
	local intro="Printing versions..."
	local gitV="\n\t\t\tgit@$(git --version)"
	local nvmV="\n\t\t\tnvm@$(nvm --version)"
	local npmV="\n\t\t\tnpm@$(npm --version)"
	local yarnV="\n\t\t\tyarn@$(yarn --version)"

	logger "${intro}${gitV}${nvmV}${npmV}${yarnV}"
}

logger() {
	if [ ! -z $JB_CONFIG_DEBUG ]; then
		echo "${BLUE}[SETUP-DEBUG]${NO_COLOR}\t$1"
	fi
}

switch_node_version() {
	logger "Swicthing Node Version..."
	VER=$1

	nvm install $1 --skip-default-packages & wait
	nvm use $1 & wait
}

nyg () { npm install --global "$1" && yarn global add "$1" ; }

global_installs() {
	logger "Installing Globals..."
	# Spaceship ZSH
	nyg "spaceship-prompt"
}

run_updates() {
	for SUBMODULE in "${SUBMODULES[@]}"; do
		git submodule update $SUBMODULE
	done
}

update_submodules "$@"