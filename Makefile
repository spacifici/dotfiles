executables:=curl gunzip tar sha1sum git
fzf_version:=0.27.2
neovim_version:=v0.5.0

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
	@mkdir -p ${optdir}

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
	@echo -n "Downloading ${file_name}... "
	@mkdir -p ${HOME}/.fzf
	@curl -L "${url}/${file_name}" -o $@ 2> /dev/null
	@echo "OK"

$(fzf_bin): tmpfile=/tmp/fzf.tgz
$(fzf_bin): fzf_url=https://github.com/junegunn/fzf/releases/download/${fzf_version}/fzf-${fzf_version}-linux_amd64.tar.gz
$(fzf_bin): $(fzf_files)
	@echo -n "Downloadinf fzf... "
	@curl -L "${fzf_url}" -o ${tmpfile} 2> /dev/null
	@mkdir -p ${HOME}/bin
	@tar xf ${tmpfile} -C ${HOME}/bin
	@rm -f ${tmpfile}
	@echo "OK"

install-fzf: $(fzf_bin)

nvim_bin:=${optdir}/nvim-linux64/bin/nvim

$(nvim_bin): tmpfile=/tmp/nvim.tgz
$(nvim_bin):
	@echo -n "Installing Neovim... "
	@curl -L "https://github.com/neovim/neovim/releases/download/${neovim_version}/nvim-linux64.tar.gz" -o ${tmpfile} 2> /dev/null
	@tar xf ${tmpfile} -C ${optdir}
	@rm -f ${tmpfile}
	@echo "OK"

packer_nvim_repo="https://github.com/wbthomason/packer.nvim"
packer_nvim_path="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"

$(packer_nvim_path):
	git clone --depth 1 ${packer_nvim_repo} ${packer_nvim_path}

install-nvim: $(optdir) $(nvim_bin) $(packer_nvim_path)

test:
	@${test_sh}

try-it:
	@${test_sh} -i

debug:
	$(foreach v,$(MAKECMDGOALS), \
		$(warning $(v) = $($v)))
