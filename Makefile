executables:=curl gunzip tar sha1sum git
fzf_version:=0.27.2
neovim_version:=v0.5.0

makedir:=$(shell cd $(shell dirname $(MAKEFILE_LIST));pwd)
scriptsdir:=$(makedir)/scripts
cachedir:=$(makedir)/cache
optdir=${HOME}/opt


# Helpers scripts
test_sh=$(scriptsdir)/test.sh
install_dotfiles_sh=$(scriptsdir)/install_dotfiles.sh

# {{{ install target
.PHONY: install
install: exc:=$(foreach exec,$(executables),\
	$(if $(shell which $(exec)),no error,$(error "No $(exec) installed")))
install: install-nvim install-fzf install-rustup install-dotfiles

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
fzf_bin_dst:=${HOME}/bin/fzf
fzf_release_url:=https://github.com/junegunn/fzf/releases/download/${fzf_version}/fzf-${fzf_version}-linux_amd64.tar.gz
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

# {{{ Old script
# 
# nvim_bin:=${optdir}/nvim-linux64/bin/nvim
# 
# $(nvim_bin): tmpfile=/tmp/nvim.tgz
# $(nvim_bin):
# 	@echo -n "Installing Neovim... "
# 	@curl -L "https://github.com/neovim/neovim/releases/download/${neovim_version}/nvim-linux64.tar.gz" -o ${tmpfile} 2> /dev/null
# 	@tar xf ${tmpfile} -C ${optdir}
# 	@rm -f ${tmpfile}
# 	@echo "OK"
# 
# packer_nvim_repo="https://github.com/wbthomason/packer.nvim"
# packer_nvim_path="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
# 
# $(packer_nvim_path):
# 	git clone --depth 1 ${packer_nvim_repo} ${packer_nvim_path}
# 
# .PHONY: install-nvim
# install-nvim: $(optdir) $(nvim_bin) $(packer_nvim_path)
# 
# .PHONY: install-rustup
# install-rustup: tmpfile=/tmp/rustup-installer.sh
# install-rustup:
# 	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o ${tmpfile}
# 	sh ${tmpfile} -y -q --no-modify-path
# 	rm ${tmpfile}
# }}}

# {{{ Testing targets
.PHONY: test
test:
	@${test_sh}

.PHONY: try-it
try-it:
	@${test_sh} -i

# }}}

debug:
	$(foreach v,$(MAKECMDGOALS), \
		$(warning $(v) = $($v)))
