executables:=curl gunzip tar sha1sum git zip unzip
fzf_version:=0.27.2
neovim_version:=v0.5.0
rg_version:=13.0.0
rust_analyzer_version:=2021-09-06
nvm_version:=v0.38.0

makedir:=$(shell cd $(shell dirname $(MAKEFILE_LIST));pwd)
scriptsdir:=$(makedir)/scripts
cachedir:=$(makedir)/cache
optdir=${HOME}/opt

arch:=$(shell uname -m)
os:=$(shell uname -s | tr [:upper:] [:lower:])

# Helpers scripts
test_sh=$(scriptsdir)/test.sh
install_dotfiles_sh=$(scriptsdir)/install_dotfiles.sh

# Check deps
exc:=$(foreach exec,$(executables),\
	$(if $(shell which $(exec)),no error,$(error "No $(exec) installed")))

.PHONY: help # prints this help message
help:
	@echo "Run \033[1mmake <target>\033[0m where target is one of the following:"
	@sed -n -E -e 's/^\.PHONY:\s+([^\ ]+)\s+#\s+(.*)/\1 \2/p' Makefile|\
		awk '{ printf("\033[32m\033[1m%-18s\033[0m", $$1);$$1="";printf("%s\n", $$0) }'

# {{{ install target
.PHONY: install # installs the dotfiles, nvim, fzf, ripgrep and oh-my-zsh
install: install-nvim install-fzf install-ripgrep install-oh-my-zsh install-dotfiles

.PHONY: install-optional # installs optional packages (rustup, sdkman, java, nvm and node)
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
# }}}

.PHONY: install-nvim # installs neovim in ${HOME}/opt
install-nvim: ${nvim_install_dir} ${packer_nvim_path}
# }}}

# {{{ oh-my-zsh
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

.PHONY: install-oh-my-zsh # installs oh-my-zsh and the extra completion plugin
install-oh-my-zsh: ${omz_dst} ${omz_comp_dst}
# }}}

# {{{ rust (optional)
# {{{ rustup
.PHONY: install-rustup
install-rustup: tmpfile=/tmp/rustup-installer.sh
install-rustup:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o ${tmpfile}
	sh ${tmpfile} -y -q --no-modify-path
	rm ${tmpfile}
# }}}

# {{{ rust-analyzer
rust_analyzer_url:=https://github.com/rust-analyzer/rust-analyzer/releases/download/${rust_analyzer_version}/rust-analyzer-x86_64-unknown-linux-gnu.gz
rust_analyzer_cache_file:=${cachedir}/rust-analyzer.gz
rust_analyzer_dst:=${HOME}/.local/bin/rust-analyzer

.SECONDARY: ${rust_analyzer_cache_file}
${rust_analyzer_cache_file}:
	curl -L ${rust_analyzer_url} -o $@

${rust_analyzer_dst}: dstdir=$(shell dirname ${rust_analyzer_dst})
${rust_analyzer_dst}: ${rust_analyzer_cache_file}
	mkdir -p ${dstdir}
	gzip -c -d $< > $@
	chmod 740 $@
# }}}

.PHONY: install-rust # installs rust (via rustup)
install-rust: install-rustup ${rust_analyzer_dst}
# }}}

# {{{ sdkman (optional)
.PHONY: install-sdkman # installs sdkman
install-sdkman:
	curl -s "https://get.sdkman.io?rcupdate=false" | bash
# }}}

# {{{ Java (optional, require sdkman)
.PHONY: install-java # installs Java (JDK, using sdkman)
install-java: install-sdkman
	env SDKMAN_DIR=${HOME}/.sdkman bash -c 'source $${SDKMAN_DIR}/bin/sdkman-init.sh && sdk install java'
# }}}

# {{{ nvm (optional)
nvm_dst:=${HOME}/.nvm
nvm_repo_url:=https://github.com/nvm-sh/nvm.git
nvm_cache_dir:=${cachedir}/nvm

${nvm_cache_dir}:
	git clone ${nvm_repo_url} $@
	cd $@ && git checkout ${nvm_version}

${nvm_dst}: ${nvm_cache_dir}
	cp -a $< $@

.PHONY: install-nvm # installs nvm
install-nvm: ${nvm_dst}
# }}}

# {{{ Nodejs (optional, require nvm)
.PHONY: install-nodejs # installs Nodejs (using nvm)
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

.PHONY: debug
debug:
	$(foreach v,$(wordlist 2,100,$(MAKECMDGOALS)), \
		$(warning $(v) = $($v)))
