#!/usr/bin/env bash

OS_NAME=`uname`
DISTRO_NAME=`head -n 1 /etc/os-release | cut -d '"' -f2`



# Use "@" to specify distribution for which this should be installed
# Use "*" to specify ppa for debian distros
declare -a SOFTWARE_SCIENCE=("libeigen3-dev" \
                             "libboost-dev" \
                             "libopencv-dev" \
                             )
declare -a SOFTWARE_ROBOTICS_SOURCE=( \
    "mrpt@'ssh://git@bitbucket.com/bergercookie/mrpt.git'")

declare -a SOFTWARE_PYTHON=("python" \
                            "python3" \
                            "pip" \
                            "pip3" \
                            )
declare -a SOFTWARE_BUILD=("cmake" \
                           "make" \
                           "autogen" \
                           )
declare -a SOFTWARE_COMPILING=("gcc" \
                               "g++" \
                               "clang" \
                               "clang++" \
                               )
declare -a SOFTWARE_ESSENTIAL=("ssh|openssh" \
                               "bash-completion" \
                               "tightvnc"
                               "xclip" \
                               "curl" \
                               "${SOFTWARE_PYTHON[@]}" \
                               "${SOFTWARE_BUILD[@]}" \
                               "${SOFTWARE_COMPILING[@]}" \
                               "git" \
                               "keychain" \
                               "vim" \
                               "vim-gnome" \
                               "gdbgui" \
                               )
declare -a SOFTWARE_FANCY=("cowsay" \
                           "fortune|fortune-mod" \
                           "variety@Debian" \
                           "variety@Ubuntu*ppa:peterlevi/ppa" \
                           "variety-slideshow@Ubuntu*ppa:peterlevi/ppa" \
                           "exuberant-ctags@Debian@Ubuntu" \
                           "ctags@Arch" \
                           "multitail" \
                           "pydf" \
                           "mtr"
                           )
declare -a SOFTWARE_CRYPTO=("pass" \
                            "gpg" \
                            "gpg2" \
                            "pinentry-ncurses" \
                            "cryptsetup"
                            )
declare -a SOFTWARE_MULTIMEDIA=("vlc" \
                                "okular" \
                                "iw@Arch" \
                                "wpa_supplicant@Arch" \
                                "dialog@Arch" \
                                )

declare -a SOFTWARE_GENERIC_SOURCE=("grive2@'https://github.com/vitalif/grive2'" \
                           )

CATEGORY_NAMES="GENERIC_SOURCE MULTIMEDIA CRYPTO ESSENTIAL COMPILING BUILD
PYTHON ROBOTICS_SOURCE SCIENCE"
for category in `echo ${CATEGORY_NAMES}`
do
    name=SOFTWARE_${category}
    echo ${name}
done

function install_package()
{
} # end of install package

