executables:=curl gunzip tar sha1sum
fzf_version:=0.27.2

makedir:=$(shell cd $(shell dirname $(MAKEFILE_LIST));pwd)
scriptsdir:=$(makedir)/scripts
optdir=${HOME}/opt


# Helpers scripts
test_sh=$(scriptsdir)/test.sh
install_dotfiles_sh=$(scriptsdir)/install_dotfiles.sh

install: exc:=$(foreach exec,$(executables),\
	$(if $(shell which $(exec)),no error,$(error "No $(exec) installed")))
install: install-nvim install-fzf install-dotfiles
	@echo "Installed"

$(optdir):
	@echo Creating ${optdir}
	mkdir -p ${optdir}

.PHONY: install-dotfiles
install-dotfiles:
	@${install_dotfiles_sh}

fzf_bin:=${HOME}/bin/fzf
fzf_files:=$(foreach f,\
	completion.bash completion.zsh key-bindings.bash key-bindings.zsh,\
	${HOME}/.fzf/${f})
${HOME}/.fzf/%: url=https://raw.githubusercontent.com/junegunn/fzf/${fzf_version}/shell
${HOME}/.fzf/%: file_name=$(shell basename $@)
${HOME}/.fzf/%:
	mkdir -p ${HOME}/.fzf
	curl -L "${url}/${file_name}" -o $@

$(fzf_bin): tmpfile=/tmp/fzf.tgz
$(fzf_bin): fzf_url=https://github.com/junegunn/fzf/releases/download/${fzf_version}/fzf-${fzf_version}-linux_amd64.tar.gz
$(fzf_bin): $(fzf_files)
	curl -s -L "${fzf_url}" -o ${tmpfile}
	mkdir -p ${HOME}/bin
	tar xf ${tmpfile} -C ${HOME}/bin
	rm -f ${tmpfile}

install-fzf: $(fzf_bin)

nvimbin:=${optdir}/nvim-linux64/bin/nvim

$(nvimbin): tmpfile=/tmp/nvim.tgz
$(nvimbin):
	curl -L "https://github.com/neovim/neovim/releases/download/v0.5.0/nvim-linux64.tar.gz" -o ${tmpfile}
	tar xf ${tmpfile} -C ${optdir}
	rm -f ${tmpfile}

install-nvim: $(optdir) $(nvimbin)

test:
	@${test_sh}

debug:
	$(foreach v,$(MAKECMDGOALS), \
		$(warning $(v) = $($v)))

# vardir=$(makedir)/var
# dotsdir=$(makedir)/dots
# dotssrc=$(wildcard ${dotsdir}/*)
# dotsdst=$(patsubst ${dotsdir}/%,${HOME}/.%,${dotssrc})

# Helpers
# link_sh=$(scriptsdir)/link.sh
# clone_sh=$(scriptsdir)/clone.sh
# install_pkg_sh=$(scriptsdir)/install_pkg.sh

# Packages to be installed
# packages=curl git tmux zsh
# 
# .PHONY: install
# install: packages ${dotsdst} zsh fzf nvim
# 
# .PHONY: force-install
# force-install:
# 	$(MAKE) -B install
# 
# packages:
# 	@${install_pkg_sh} ${packages} && touch $@
# 
# ${HOME}/.%: ${dotsdir}/%
# 	@${link_sh} $< $@
# 
# # Debug targes
# 
# .PHONY: print_vars
# print_vars:
# 	$(foreach v,$(.VARIABLES), $(info $(v)=$($(v))))
# 
# #######
# # fzf #
# #######
# fzfpath=${vardir}/fzf
# fzf_bin=${fzfpath}/bin/fzf
# 
# .PHONY: fzf
# fzf: ${fzf_bin}
# 
# ${fzf_bin}: ${fzfpath}
# 	@${fzfpath}/install --bin
# 
# ${fzfpath}:
# 	@${clone_sh} https://github.com/junegunn/fzf.git $@
# 
# ##########
# # NEOVIM #
# ##########
# nvimurl=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
# nvimdir=${vardir}/nvim
# 
# nvim: ${nvimdir}
# 
# ${nvimdir}:
# 	@scripts/update_nvim.sh -y
# 
# #######
# # zsh #
# #######
# ohmyzshdir=${vardir}/oh-my-zsh
# 
# .PHONY: zsh
# zsh: ${HOME}/.zshrc ${ohmyzshdir}
# 
# ${vardir}/oh-my-zsh:
# 	@${clone_sh} https://github.com/ohmyzsh/ohmyzsh.git $@
