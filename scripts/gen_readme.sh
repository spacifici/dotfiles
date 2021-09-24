#!/bin/bash
declare -r ROOTDIR=$(cd "$(dirname $0)/../"; pwd)

cat << EOF
# dotfiles

A collection of dotfiles, utils, dev tools and editor I generally like to have
installed on every machine I work on, both local (my laptop) and remote (heavy
duty build server).

## Software

Trought the \`Makefile\` targets, the following softwares can be installed. See
[Make targets](#make-targets) to check which target install which software.

$(
section=0

cat $ROOTDIR/Makefile| while read line
do
	if [[ "${line}" =~ ^#\ +\*/.*$ ]]; then
		section=0
		echo "* **[${name}](${url})** ${descr}"
		name=""
		url=""
		descr=""
	fi
	if (( ${section} > 0 )); then
		line=${line#"# * "}
		if [ -z "${name}" ]; then
			name="${line}"
		elif [ -z "${url}" ]; then
			url="${line}"
		else
			descr="${descr} ${line}"
		fi
	fi
	if [[ "${line}" =~ ^#/\*.*$ ]]; then
		section=1
	fi
done
)

## Make targets

$(cd $ROOTDIR; make -s help help_format=markdown)

## Neovim plugins

Neovim configuration comes with the following plugins listed in
[plugins.lua](dotfiles/config/nvim/lua/plugins.lua). They get installed with
the \`install-nvim\` Makefile target.

$(
	cd $ROOTDIR
	sed -nEe \
		"s/^\s+(use)?\s+'([^']+)',?\s+--\s(.*)/\2 \3/p" \
		dotfiles/config/nvim/lua/plugins.lua \
	|awk '{
		url=sprintf("* **[%s](https://github.com/%s)**", $1, $1);
		$1="";
		printf("%s %s\n", url, $0)
	}'
)
EOF
