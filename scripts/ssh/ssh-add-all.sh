#!/bin/bash
set -e # Exit on first error

declare -a SSH_KEYS=(
	~/.ssh/bitbucket_id_rsa
	~/.ssh/gitlab_id_rsa
	~/.ssh/gitlab_uk_id_rsa
	~/.ssh/gitlab_uk_inexa_id_rsa
	~/.ssh/codecommit_id_rsa
	~/.ssh/id_rsa
	~/.ssh/mac_id_rsa
)

declare -a IGNORE=(
	~/.ssh/ignored_id_rsa
)

confirm_existence()
{
	if [[ -f $1 ]] && [[ -n $1 ]] ; then
		return 0
	else
		return 1
	fi
}

is_ssh_add_installed()
{
	if hash ssh-add 2>/dev/null; then
		return 0
	else
		return 1
	fi
}

add_key()
{
	ssh-add $1

	echo "Successfully Added $1"
}

handle_key()
{
	if confirm_existence $1; then
		add_key $1
	else
		echo "$1 Does Not Exist."
	fi;
	echo
}

ignore()
{
	for IGNORE_SRC in "${IGNORE[@]}"
	do
		if [[ $1 == "$IGNORE_SRC" ]]; then
			return 0
		fi
	done
	return 1
}

echo

if [[ is_ssh_add_installed ]]; then
	echo "Adding SSH Keys...";

	for i in "${SSH_KEYS[@]}"
	do
		if ignore $i ; then
			echo "Not Adding $i Key"
		else
			handle_key $i
		fi
	done

	echo "Done Adding All SSH Keys";

	echo

	ssh-add -l
else
	echo "ssh-add command is not installed!"
fi

echo
