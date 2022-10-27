executables:=curl gunzip tar sha1sum git zip unzip
fzf_version:=0.34.0
neovim_version:=v0.8.0
rg_version:=13.0.0
rust_analyzer_version:=2022-10-17
nvm_version:=v0.39.2

makedir:=$(shell cd $(shell dirname $(MAKEFILE_LIST));pwd)
scriptsdir:=$(makedir)/scripts
cachedir:=$(makedir)/cache
optdir=${HOME}/opt

arch:=$(shell uname -m)
os:=$(shell uname -s | tr [:upper:] [:lower:])

# {{{ help targer formatting
help_format=terminal
help_format_code_start=\033[1m
help_format_code_end=\033[0m
help_format_target_start=\033[32m\033[1m%-18s
help_format_target_end=\033[0m

ifeq ($(help_format),markdown)
	help_format_code_start=\`
	help_format_code_end=\`
	help_format_target_start=* **%s
	help_format_target_end=**
endif
# }}}

# Helpers scripts
test_sh=$(scriptsdir)/test.sh
install_dotfiles_sh=$(scriptsdir)/install_dotfiles.sh

# Check deps
exc:=$(foreach exec,$(executables),\
	$(if $(shell which $(exec)),no error,$(error "No $(exec) installed")))

# {{{ help targets
.PHONY: help # prints this help message
help:
	@echo "Run ${help_format_code_start}make <target>${help_format_code_end} where target is one of the following:\n"
	@sed -n -E -e 's/^\.PHONY:\s+([^\ ]+)\s+#\s+(.*)/\1 \2/p' $(lastword $(MAKEFILE_LIST))|\
		awk '{ printf("${help_format_target_start}${help_format_target_end}", $$1);$$1="";printf("%s\n", $$0) }'
# }}}

# {{{ install target
.PHONY: install # installs the dotfiles, neovim, fzf, ripgrep and Oh My Zsh
install: install-nvim install-fzf install-ripgrep install-oh-my-zsh install-dotfiles

.PHONY: install-optional # installs optional packages (rustup, SDKMAN, Java, NVM and Node.js)
install-optionals: install install-rust install-sdkman install-java install-nvm install-nodejs

.PHONY: install-all # installs everything
install-all: install-optionals

$(optdir):
	mkdir -p ${optdir}
# }}}

# {{{ Dotfiles
.PHONY: install-dotfiles # installs recursively all the files in the dotfiles dir
install-dotfiles:
	@${install_dotfiles_sh}
# }}}

# {{{ FZF
#/*
# * FZF
# * https://github.com/junegunn/fzf
# * command-line fuzzy search with bash and zsh integration
# */

# FZF binary files
fzf_arch:=$(if $(subst x86_64,,${arch}),$(error "Unknown arch: ${arch}"),amd64)
fzf_bin_dst:=${HOME}/.local/bin/fzf
fzf_release_url:=https://github.com/junegunn/fzf/releases/download/${fzf_version}/fzf-${fzf_version}-${os}_${fzf_arch}.tar.gz
fzf_bin_cache:=${cachedir}/fzf-${fzf_version}.tgz

${fzf_bin_cache}:
	curl -L ${fzf_release_url} -o ${fzf_bin_cache}

${fzf_bin_dst}: bindir=$(shell dirname ${fzf_bin_dst})
${fzf_bin_dst}: ${fzf_bin_cache}
	mkdir -p ${bindir}
	tar xf $< -C ${bindir}

# FZF shell extensions
fzf_shell_srcs:=completion.bash completion.zsh key-bindings.bash key-bindings.zsh
fzf_shell_dsts:=$(foreach f,${fzf_shell_srcs},${HOME}/.fzf/${f})
fzf_shell_dstdir:=${HOME}/.fzf
fzf_shell_cache_prefix=${cachedir}/fzf-${fzf_version}-
fzf_shell_caches:=$(foreach f,${fzf_shell_srcs},${fzf_shell_cache_prefix}${f})

.SECONDARY: ${fzf_shell_caches}

${fzf_shell_cache_prefix}%: f=$(subst ${fzf_shell_cache_prefix},,$@)
${fzf_shell_cache_prefix}%: url="https://raw.githubusercontent.com/junegunn/fzf/${fzf_version}/shell/${f}"
${fzf_shell_cache_prefix}%:
	curl -L ${url} -o $@

${fzf_shell_dstdir}/%: ${fzf_shell_cache_prefix}%
	mkdir -p ${fzf_shell_dstdir}
	cp $< $@

.PHONY: install-fzf # installs fzf in ${HOME}/.local/bin
install-fzf: ${fzf_bin_dst} ${fzf_shell_dsts}
# }}}

# {{{ ripgrep
#/*
# * ripgrep
# * https://github.com/BurntSushi/ripgrep
# * line-oriented search tool that recursively searches the current directory
# * for a regex pattern. It respects gitignore rules and skips hidden files and
# * directories
# */
rg_bin_dst:=${HOME}/.local/bin/rg
rg_man_dst:=${HOME}/.local/share/man/man1/rg.1
rg_release_url:=https://github.com/BurntSushi/ripgrep/releases/download/${rg_version}/ripgrep-${rg_version}-x86_64-unknown-linux-musl.tar.gz
rg_cache_file:=${cachedir}/ripgrep-${rg_version}.tgz

.SECONDARY: ${rg_cache_file}
${rg_cache_file}:
	curl -L ${rg_release_url} -o $@

${rg_bin_dst}: dstdir:=$(shell dirname ${rg_bin_dst})
${rg_bin_dst}: ${rg_cache_file}
	mkdir -p ${dstdir}
	tar xf $< -C ${dstdir} --strip-components=1 --wildcards '*/rg'

${rg_man_dst}: dstdir=$(shell dirname ${rg_man_dst})
${rg_man_dst}: ${rg_cache_file}
	mkdir -p ${dstdir}
	tar xf $< -C ${dstdir} --strip-components=2 --wildcards '*/rg.1'

.PHONY: install-ripgrep # installs ripgrep (rg) in ${HOME}/.local/bin (and its manpage)
install-ripgrep: ${rg_bin_dst} ${rg_man_dst}
# }}}

# {{{ Neovim
#/*
# * Neovim
# * https://neovim.io
# * a Vim-based text editor engineered for extensibility and usability
# */
nvim_os_arch:=$(strip $(if $(subst linux,,${os}),$(error "Os not supported: ${os}"),\
$(if $(subst x86_64,,${arch}),$(error "Arch not supported: ${arch}"),linux64)))
nvim_release_url:=https://github.com/neovim/neovim/releases/download/${neovim_version}/nvim-${nvim_os_arch}.tar.gz
nvim_install_dir:=${optdir}/nvim-${nvim_os_arch}
nvim_cache_file:=${cachedir}/nvim-${neovim_version}.tgz

.SECONDARY: ${nvim_cache_file}
${nvim_cache_file}:
	curl -L ${nvim_release_url} -o $@

${nvim_install_dir}: ${nvim_cache_file}
	mkdir -p ${optdir}
	tar xf $< -C ${optdir}

# {{{ packer.nvim
packer_nvim_repo="https://github.com/wbthomason/packer.nvim"
packer_nvim_path="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
packer_nvim_cache=${cachedir}/packer.vim

.SECONDARY: ${packer_nvim_cache}
${packer_nvim_cache}:
	git clone --depth 1 ${packer_nvim_repo} $@

${packer_nvim_path}: dstdir=$(shell dirname ${packer_nvim_path})
${packer_nvim_path}: ${packer_nvim_cache}
	mkdir -p ${dstdir}
	cp -a $< $@

.PHONY: nvim-bootstrap-packer
nvim-bootstrap-packer:
	${nvim_install_dir}/bin/nvim -u NONE --headless \
		-c 'autocmd User PackerComplete quitall' \
		-c 'source ${makedir}/dotfiles/config/nvim/lua/plugins.lua' \
		-c 'PackerSync'
# }}}

.PHONY: install-nvim # installs neovim in ${HOME}/opt
install-nvim: ${nvim_install_dir} ${packer_nvim_path} nvim-bootstrap-packer

.PHONY: clean-nvim
clean-nvim:
	rm -rf \
		${nvim_install_dir} \
		${packer_nvim_path} \
		${nvim_cache_file} \
		${packer_nvim_cache}

.PHONY: update-nvim # Force nvim update
update-nvim: clean-nvim install-nvim
# }}}

# {{{ OhMyZsh
#/*
# * OhMyZsh
# * https://ohmyz.sh
# * a delightful, open source, community-driven framework for managing your zsh
# * configuration
# */
omz_dst:=${HOME}/.oh-my-zsh
omz_repo_url:=https://github.com/ohmyzsh/ohmyzsh.git
omz_cache_dir:=${cachedir}/oh-my-zsh

${omz_cache_dir}:
	git clone ${omz_repo_url} $@

${omz_dst}: ${omz_cache_dir}
	cp -a $< $@

# {{{ zsh-completion
omz_comp_dst:=${omz_dst}/plugins
omz_comp_repo_url:=https://github.com/zsh-users/zsh-completions.git
omz_comp_cache_dir:=${cachedir}/zsh-completions

${omz_comp_cache_dir}:
	git clone ${omz_comp_repo_url} ${omz_comp_cache_dir}

${omz_comp_dst}: ${omz_dst} ${omz_comp_cache_dir}
	cp -a ${omz_comp_cache_dir} ${omz_comp_dst}
# }}}

.PHONY: install-oh-my-zsh # installs Oh My Zsh and the extra completion plugin
install-oh-my-zsh: ${omz_dst} ${omz_comp_dst}
# }}}

# {{{ rust (optional)
# {{{ rustup
#/*
# * rustup
# * https://rustup.rs
# * installs The Rust Programming Language from the official release channels,
# * enabling you to easily switch between stable, beta, and nightly compilers
# * and keep them updated
# */
.PHONY: install-rustup
install-rustup: tmpfile=/tmp/rustup-installer.sh
install-rustup:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o ${tmpfile}
	sh ${tmpfile} -y -q --no-modify-path
	rm ${tmpfile}
# }}}

# {{{ rust-analyzer
#/*
# * rust-analyzer
# * https://rust-analyzer.github.io
# * an implementation of Language Server Protocol for the Rust programming
# * language that provides features like completion and goto definition for
# * many code editors. We install it via mason
# */
.PHONY: install-rust-analyzer
install-rust-analyzer:
	${nvim_install_dir}/bin/nvim --headless \
		-c 'MasonInstall rust-analyzer' \
		-c 'qall'
# }}}

.PHONY: install-rust # installs rust (via rustup)
install-rust: install-rustup install-rust-analyzer
# }}}

# {{{ SDKMAN (optional)
#/*
# * SDKMAN
# * https://sdkman.io
# * a tool for managing parallel versions of multiple Software Development Kits
# * on most Unix based systems
# */
.PHONY: install-sdkman # installs SDKMAN
install-sdkman:
	curl -s "https://get.sdkman.io?rcupdate=false" | bash
# }}}

# {{{ Java (optional, require SDKMAN)
.PHONY: install-java # installs Java (JDK, using SDKMAN)
install-java: install-sdkman
	env SDKMAN_DIR=${HOME}/.sdkman bash -c 'source $${SDKMAN_DIR}/bin/sdkman-init.sh && sdk install java'
# }}}

# {{{ NVM (optional)
#/*
# * Node Version Manager
# * https://github.com/nvm-sh/nvm-sh
# * a version manager for node.js, designed to be installed per-user, and
# * invoked per-shell
# */
nvm_dst:=${HOME}/.nvm
nvm_repo_url:=https://github.com/nvm-sh/nvm.git
nvm_cache_dir:=${cachedir}/nvm

${nvm_cache_dir}:
	git clone ${nvm_repo_url} $@
	cd $@ && git checkout ${nvm_version}

${nvm_dst}: ${nvm_cache_dir}
	cp -a $< $@

.PHONY: install-nvm # installs NVM
install-nvm: ${nvm_dst}
# }}}

# {{{ Node.js (optional, require NVM)
.PHONY: install-nodejs # installs Node.js (using NVM)
install-nodejs: install-nvm
	env NVM_DIR=${HOME}/.nvm bash -c 'source $${NVM_DIR}/nvm.sh; nvm install --lts'
# }}}

# {{{ Testing targets
.PHONY: test
test:
	@${test_sh}

.PHONY: try-it # creates a docker container, runs `make install` and then runs an interactive shell in the container
try-it:
	@${test_sh} -i
# }}}

# {{{ README.md generation
.PHONY: README.md
README.md:
	@scripts/gen_readme.sh > $@
# }}}

.PHONY: debug
debug:
	$(foreach v,$(wordlist 2,100,$(MAKECMDGOALS)), \
		$(warning $(v) = $($v)))
