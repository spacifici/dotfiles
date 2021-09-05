#!/bin/bash
declare -r MODE_ALL="all"
declare -r MODE_ONLY_TESTS="only_tests"
declare -r MODE_INTERACTIVE="interactive"

declare -r DOTFILES_PATH="$(cd "$(dirname $0)/../dotfiles"; pwd)"

mode="${MODE_ONLY_TESTS}"

# check_path <error_msg> <path>
check_path() {
    echo -n "Checking $2... "
    if [ -e "${2}" ]; then
        echo "OK"
    else
        echo $1
    fi
}

# check_command <error_msg> <command>
check_command() {
    echo -n "Checking $2 command... "
    result=$(env -i HOME=~ /bin/bash -l -c "compgen -c|grep $2")
    if [ "${result}" == "$2" ]; then
        echo "OK"
    else
        echo "${1}"
    fi
}

# check_dotfile <error_msg> <dotfile>
check_dotfile() {
    echo -n "Checking dotfile $2... "
    dst="${HOME}/.$2"
    src="${DOTFILES_PATH}/$2"
    if [ ! -f "${src}" ]; then
        echo "${src} doesn't exist"
        return 1
    elif [ ! -f "${dst}" ]; then
        echo "${dst} doesn't exist"
        return 1
    fi
    srcsum=$(sha1sum "${src}"|cut -f1 -d' ')
    dstsum=$(sha1sum "${dst}"|cut -f1 -d' ')
    if [ "${srcsum}" == "${dstsum}" ]; then
        echo "OK"
    else
        echo "$2 differs from the file installed"
    fi
}

# Run make install
run_make_install() {
    cd /src
    make install
}

run_tests() {
    check_dotfile "No message" "profile"
    check_dotfile "No message" "bashrc"
    check_dotfile "No message" "config/nvim/init.vim"
    check_path "Neovim is not correctly installed" "${HOME}/opt/nvim-linux64/bin/nvim"
    check_path "fzf is not correctly installed" "${HOME}/bin/fzf"
    check_command "Neovim is not correctly installed" nvim
    check_command "fzf is not correctly installed" fzf
}

while getopts ":ati" opt; do
    case "${opt}" in
        a ) # Install and run tests
            mode="${MODE_ALL}"
            ;;
        t ) # Run only the tests
            mode="${MODE_ONLY_TESTS}"
            ;;
        i ) # Run interactive
            mode="${MODE_INTERACTIVE}"
            ;;
        \? )
            echo "Invalid option: -${OPTARG}" 1>&2
            exit 1
            ;;
    esac
done

case "${mode}" in
    "${MODE_ALL}" )
        run_make_install
        env -i - HOME=/root /bin/bash -l $0
        ;;
    "${MODE_INTERACTIVE}" )
        echo "Running interactive"
        run_make_install
        exec /bin/bash -l
        ;;
    * )
        echo "Running tests"
        run_tests
        ;;
esac
