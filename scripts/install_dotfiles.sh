#!/bin/bash
declare -r ROOTDIR=$(cd "$(dirname $0)/../"; pwd)

# Find all the dotfiles we need to install
declare -r DOTFILES=$(cd "${ROOTDIR}/dotfiles"; find . -type f -printf '%P\n')

# Date prefix for the backup files
declare -r BACKUP_DATE=$(date +%s)

# backup <dotfile>
# where dotfile is the path relative to the dotfiles folder
backup() {
	f="${HOME}/.$1"
	b="${ROOTDIR}/backups/${BACKUP_DATE}_$(echo $1|sed 's|/|_|g')"
	cp "$f" "$b"
}

# install <src> <dst>
install() {
	mkdir -p "$(dirname "$2")"
	ln -s "$1" "$2"
}

# For each dotfile...
for dotfile in ${DOTFILES}; do
	echo -n "Installing ${dotfile}... "
	src="${ROOTDIR}/dotfiles/${dotfile}"
	dst="${HOME}/.${dotfile}"
	# ...if a symbolic link already exists, delete it
	if [ -L "${dst}" ]; then
		rm -f "${dst}"
	fi
	# ...if a file with the same name exists, backup it
	if [ -f "${dst}" ]; then
		backup "${dotfile}"
		rm -f "${dst}"
	fi
	# Install the link
	install "${src}" "${dst}"
	echo "OK"
done
