#!/bin/bash
declare -r ROOTDIR=$(cd "$(dirname $0)/../"; pwd)

# Find all the dotfiles we need to install
declare -r DOTFILES=$(cd "${ROOTDIR}/dotfiles"; find . -type f -printf '%P\n')

# backup <dotfile>
# where dotfile is the path relative to the dotfiles folder
backup() {
    f="${HOME}/.$1"
    b="${ROOTDIR}/backups/$(date +%s)_$(echo $1|sed 's|/|_|g')"
    cp "$f" "$b"
}

# For each dotfile...
for dotfile in ${DOTFILES}; do
    echo -n "Installing ${dotfile}... "
    src="${ROOTDIR}/dotfiles/${dotfile}"
    dst="${HOME}/.${dotfile}"
    # ...if a symbolic link already exists, delete it
    if [ -L "${dst}" ]; then
        rm -f "${dst}"
    # ...if a file with the same name exists, backup it
    elif [ -f "${dst}" ]; then
        backup "${dotfile}"
        rm -f "${dst}"
    fi
    # Install the link
    ln -s "${src}" "${dst}"
    echo "OK"
done
