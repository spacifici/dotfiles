executables:=curl gunzip tar sha1sum git
fzf_version:=0.27.2
neovim_version:=v0.5.0
rg_version:=13.0.0

makedir:=$(shell cd $(shell dirname $(MAKEFILE_LIST));pwd)
scriptsdir:=$(makedir)/scripts
cachedir:=$(makedir)/cache
optdir=${HOME}/opt

arch:=$(shell uname -m)
os:=$(shell uname -s | tr [:upper:] [:lower:])

# Helpers scripts
test_sh=$(scriptsdir)/test.sh
install_dotfiles_sh=$(scriptsdir)/install_dotfiles.sh

# {{{ install target
.PHONY: install
install: exc:=$(foreach exec,$(executables),\
	$(if $(shell which $(exec)),no error,$(error "No $(exec) installed")))
install: install-nvim install-fzf install-ripgrep install-oh-my-zsh install-dotfiles

$(optdir):
	mkdir -p ${optdir}
# }}}

# {{{ Dotfiles
.PHONY: install-dotfiles
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

.PHONY: install-fzf
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

.PHONY: install-ripgrep
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

.PHONY: install-nvim
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

.PHONY: install-oh-my-zsh
install-oh-my-zsh: ${omz_dst} ${omz_comp_dst}
# }}}

# {{{ rustup (optional)
.PHONY: install-rustup
install-rustup: tmpfile=/tmp/rustup-installer.sh
install-rustup:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o ${tmpfile}
	sh ${tmpfile} -y -q --no-modify-path
	rm ${tmpfile}
# }}}

# {{{ Testing targets
.PHONY: test
test:
	@${test_sh}

.PHONY: try-it
try-it:
	@${test_sh} -i

# }}}

.PHONY: debug
debug:
	$(foreach v,$(wordlist 2,100,$(MAKECMDGOALS)), \
		$(warning $(v) = $($v)))
