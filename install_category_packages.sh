#!/usr/bin/env bash

# Use "@" to specify distribution for which this should be installed
# Use "*" to specify ppa for debian distros
declare -a SOFTWARE_SCIENCE=( \
    "libeigen3-dev" \
    "libboost-dev" \
    "libopencv-dev" \
    )
declare -a SOFTWARE_ROBOTICS_SOURCE=( \
    "mrpt@'ssh://git@bitbucket.com/bergercookie/mrpt.git'")

declare -a SOFTWARE_PYTHON=( \
    "python" \
    "python3" \
    "pip" \
    "pip3" \
    )
declare -a SOFTWARE_CPP=( \
    doxygen \
    )
declare -a SOFTWARE_RUBY=( \
    "ruby-bundler" \
    "ruby" \
    )
declare -a SOFTWARE_HASKELL=( \
    "ghc" \
    "ghc-mod" \
    )
declare -a SOFTWARE_PROGRAMMING_LANGUAGES=( \
    "${SOFTWARE_PYTHON[@]}" \
    "${SOFTWARE_CPP[@]}" \
    "${SOFTWARE_HASKELL[@]}" \
    "${SOFTWARE_RUBY[@]}" \
    )

declare -a SOFTWARE_BUILD=( \
    "cmake" \
    "cmake-curses-gui" \
    "make" \
    "autogen" \
    )

declare -a SOFTWARE_COMPILING=( \
    "gcc" \
    "g++" \
    "clang" \
    "clang++" \
    "clang-format-3.8" \
    )
declare -a SOFTWARE_ESSENTIAL=( \
    "ssh|openssh" \
    "bash-completion" \
    "tightvnc" \
    "xclip" \
    "terminator" \
    "curl" \
    "git" \
    "keychain" \
    "vim" \
    "vim-gnome" \
    "gdbgui" \
    "libncurses-dev" \
    "ncurses-bin" \
    "${SOFTWARE_PROGRAMMING_LANGUAGES[@]}" \
    "${SOFTWARE_BUILD[@]}" \
    "${SOFTWARE_COMPILING[@]}" \
    )
declare -a SOFTWARE_TMUX=( \
    "urlview" \
    "automake" \
    "libevent-dev" \
    )
declare -a SOFTWARE_FANCY=( \
    "cowsay" \
    "fortune|fortune-mod" \
    "variety@Debian" \
    "variety@Ubuntu*ppa:peterlevi/ppa" \
    "variety-slideshow@Ubuntu*ppa:peterlevi/ppa" \
    "exuberant-ctags@Debian@Ubuntu" \
    "ctags@Arch" \
    "multitail" \
    "pydf" \
    "mtr" \
    )
declare -a SOFTWARE_PRODUCTIVITY=( \
    "ansible" \
    "checkinstall" \
    "firefox" \
    "shellcheck" \
    "openvpn"
    )
declare -a SOFTWARE_CRYPTO=( \
    "pass" \
    "gpg" \
    "gpg2" \
    "pinentry-ncurses" \
    "cryptsetup" \
    )
declare -a SOFTWARE_MULTIMEDIA=("vlc" \
    "okular" \
    "iw@Arch" \
    "wpa_supplicant@Arch" \
    "dialog@Arch" \
    )

declare -a SOFTWARE_GENERIC_SOURCE=( \
    "grive2@'https://github.com/vitalif/grive2'" \
    )

# determine if pip is to be installed
# TODO
declare -a PIP_PACKAGES=( \
    "numpy" \
    "pandas" \
    "jedi" \
    "vim-vint" \
    "cmakelint" \
    "proselint" \
    "bashate" \
    )
PIP_INSTALL="pip install --user"

function install_category_packages()
{
    source `dirname ${BASH_SOURCE[0]}`/install_package.sh

    if [[ -z "${log}" ]]; then
        echo "No logging module found. Exiting..."
        exit 1
    fi
    if ! [[ "`id -u`" = 0 ]]; then
        echo "Function ${FUNCNAME[0]} executed without superuser rights. Exiting..."
        exit 1
    fi

    name=$1
    name_prefixed=SOFTWARE_${name}
    array=$name_prefixed[@]
    ${log} info "Installing packages for category [${name}]..."
    echo
    for i in "${!array}"; do
        install_package "$i"
    done
} # end of install_category_packages

# [[ "`id -u`" = 0 ]] || exec sudo "$0" "$@"
install_category_packages ${@:1}
